/// SSC exam details.
class SSCModel {
  final String roll;
  final String registrationNumber;
  final String board;
  final String passingYear;
  final String gpa;

  const SSCModel({
    this.roll = '',
    this.registrationNumber = '',
    this.board = '',
    this.passingYear = '',
    this.gpa = '',
  });

  SSCModel copyWith({
    String? roll,
    String? registrationNumber,
    String? board,
    String? passingYear,
    String? gpa,
  }) {
    return SSCModel(
      roll: roll ?? this.roll,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      board: board ?? this.board,
      passingYear: passingYear ?? this.passingYear,
      gpa: gpa ?? this.gpa,
    );
  }
}
