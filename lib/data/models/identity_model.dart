enum DocumentType { birthCertificate, nid }

class IdentityModel {
  final DocumentType documentType;
  final String documentNumber;

  const IdentityModel({
    this.documentType = DocumentType.birthCertificate,
    this.documentNumber = '',
  });

  IdentityModel copyWith({
    DocumentType? documentType,
    String? documentNumber,
  }) {
    return IdentityModel(
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
    );
  }
}
