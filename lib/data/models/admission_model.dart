import 'identity_model.dart';
import 'ssc_model.dart';
import 'hsc_model.dart';

/// Whole admission form state; immutable, updated via copyWith.
class AdmissionModel {
  final String phoneNumber;
  final String fullName;
  final String fatherName;
  final String motherName;
  final IdentityModel identity;
  final SSCModel ssc;
  final HSCModel hsc;
  final bool hscComplete;
  final String? imagePath;
  final String? imageUrl;
  final String referenceNumber;

  AdmissionModel({
    this.phoneNumber = '',
    this.fullName = '',
    this.fatherName = '',
    this.motherName = '',
    this.identity = const IdentityModel(),
    this.ssc = const SSCModel(),
    this.hsc = const HSCModel(),
    this.hscComplete = true,
    this.imagePath,
    this.imageUrl,
    this.referenceNumber = '',
  });

  /// Returns a copy with the given fields replaced.
  AdmissionModel copyWith({
    String? rollNumber,
    String? fullName,
    String? fatherName,
    String? motherName,
    IdentityModel? identity,
    SSCModel? ssc,
    HSCModel? hsc,
    bool? hscComplete,
    String? imagePath,
    String? imageUrl,
    String? referenceNumber,
  }) {
    return AdmissionModel(
      phoneNumber: rollNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      identity: identity ?? this.identity,
      ssc: ssc ?? this.ssc,
      hsc: hsc ?? this.hsc,
      hscComplete: hscComplete ?? this.hscComplete,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      referenceNumber: referenceNumber ?? this.referenceNumber,
    );
  }

  /// Serializes to a sheet row (column order must match Apps Script).
  /// Only fields collected in the active flow (Step1/3/4/6) are saved.
  /// PhotoURL omitted — photo is stored in Drive as {phoneNumber}.jpg.
  List<dynamic> toSheetRow() {
    return [
      referenceNumber,
      phoneNumber,
      fullName,
      identity.documentType == DocumentType.birthCertificate ? 'BC' : 'NID',
      identity.documentNumber,
      ssc.roll,
      ssc.registrationNumber,
      ssc.board,
      ssc.passingYear,
      DateTime.now().toIso8601String(),
    ];
  }
}
