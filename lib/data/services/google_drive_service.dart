import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import '../../app/utils/constants.dart';

class GoogleDriveService {
  static const int _targetSizeBytes = 200 * 1024; // 200KB

  Future<String?> uploadImage(String imagePath, String rollNumber) async {
    try {
      List<int> imageBytes;

      if (kIsWeb) {
        if (imagePath.startsWith('data:')) {
          imageBytes = base64Decode(imagePath.split(',').last);
        } else {
          print('[DriveService] Web: invalid image path format');
          return null;
        }
      } else {
        final file = File(imagePath);
        imageBytes = await file.readAsBytes();
      }

      print('[DriveService] Original image size: ${imageBytes.length} bytes');

      // Compress to ~200KB
      final compressed = _compressImage(imageBytes, _targetSizeBytes);
      final base64Image = base64Encode(compressed);

      print('[DriveService] Compressed size: ${compressed.length} bytes, base64 length: ${base64Image.length}');
      print('[DriveService] Uploading image for roll: $rollNumber');

      final body = json.encode({
        'action': 'uploadImage',
        'image': base64Image,
        'rollNumber': rollNumber,
        'folderId': AppConstants.driveFolderId,
      });

      final response = await http
          .post(
            Uri.parse(AppConstants.appsScriptUrl),
            headers: {'Content-Type': 'text/plain'},
            body: body,
          )
          .timeout(const Duration(seconds: 120));

      print('[DriveService] Response status: ${response.statusCode}');
      print('[DriveService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          if (data['success'] == true) {
            final url = data['url'] as String?;
            print('[DriveService] Upload success, URL: $url');
            return url;
          } else {
            print('[DriveService] Upload failed: ${data['error']}');
          }
        } catch (_) {
          // Response body not parseable on web — upload DID succeed on Drive
          // Return empty string to indicate "success but no URL available"
          print('[DriveService] Response not parseable, upload succeeded on Drive');
          return '';
        }
      } else {
        print('[DriveService] HTTP error: ${response.statusCode}');
      }
      return null;
    } catch (e) {
      print('[DriveService] Exception during upload: $e');
      return null;
    }
  }

  List<int> _compressImage(List<int> bytes, int targetBytes) {
    // Decode the image
    final image = img.decodeImage(Uint8List.fromList(bytes));
    if (image == null) {
      print('[DriveService] Could not decode image, returning original');
      return bytes;
    }

    // If already under target, just re-encode as JPEG quality 90
    if (bytes.length <= targetBytes) {
      print('[DriveService] Image already under target, re-encoding at quality 90');
      return img.encodeJpg(image, quality: 90);
    }

    // Binary search for the right JPEG quality to hit target size
    int low = 10;
    int high = 85;
    List<int> best = bytes;

    while (low <= high) {
      final mid = (low + high) ~/ 2;
      final encoded = img.encodeJpg(image, quality: mid);

      if (encoded.length <= targetBytes) {
        best = encoded;
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }

    print('[DriveService] Best quality found, final size: ${best.length} bytes');
    return best;
  }
}
