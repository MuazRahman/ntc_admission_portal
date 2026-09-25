/// One roster row from the students sheet: roll + name.
class StudentModel {
  final String rollNumber;
  final String fullName;

  StudentModel({required this.rollNumber, required this.fullName});

  /// Maps a sheet row ([roll, name, ...]) to a student.
  factory StudentModel.fromRow(List<dynamic> row) {
    return StudentModel(
      rollNumber: row[0]?.toString() ?? '',
      fullName: row[1]?.toString() ?? '',
    );
  }
}
