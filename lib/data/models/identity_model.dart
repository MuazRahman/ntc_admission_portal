enum DocumentType { birthCertificate, nid }

class IdentityModel {
  final DocumentType documentType;
  final String documentNumber;

  const IdentityModel({
    this.documentType = DocumentType.nid,
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
