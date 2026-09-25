/// HSC exam details.
class HSCModel {
  final String roll;
  final String registrationNumber;
  final String board;
  final String passingYear;
  final String gpa;

  const HSCModel({
    this.roll = '',
    this.registrationNumber = '',
    this.board = '',
    this.passingYear = '',
    this.gpa = '',
  });

  HSCModel copyWith({
    String? roll,
    String? registrationNumber,
    String? board,
    String? passingYear,
    String? gpa,
  }) {
    return HSCModel(
      roll: roll ?? this.roll,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      board: board ?? this.board,
      passingYear: passingYear ?? this.passingYear,
      gpa: gpa ?? this.gpa,
    );
  }
}
