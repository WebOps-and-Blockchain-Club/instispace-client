//this contains models for councellors of InstiHospital,
//the data is used in the Instihospital Section of WellnessCare Center,

class InstiCounselor {
  final int slNo;
  final String nameOfTheCounselor;
  final String designation;
  final String gender;
  final String dutyTiming;
  final String mobileNumber;

  InstiCounselor({
    required this.slNo,
    required this.nameOfTheCounselor,
    required this.designation,
    required this.gender,
    required this.dutyTiming,
    required this.mobileNumber,
  });
}
