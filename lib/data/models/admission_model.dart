import 'identity_model.dart';
import 'ssc_model.dart';
import 'hsc_model.dart';

class AdmissionModel {
  final String rollNumber;
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
    this.rollNumber = '',
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
      rollNumber: rollNumber ?? this.rollNumber,
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

  List<dynamic> toSheetRow() {
    return [
      referenceNumber,
      rollNumber,
      fullName,
      fatherName,
      motherName,
      identity.documentType == DocumentType.birthCertificate ? 'BC' : 'NID',
      identity.documentNumber,
      ssc.roll,
      ssc.registrationNumber,
      ssc.board,
      ssc.passingYear,
      ssc.gpa,
      hsc.roll,
      hsc.registrationNumber,
      hsc.board,
      hsc.passingYear,
      hsc.gpa,
      imageUrl ?? '',
      DateTime.now().toIso8601String(),
    ];
  }
}
