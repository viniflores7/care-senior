import 'package:care_senior_study/data/models/guardian.dart';
import 'package:care_senior_study/data/models/staff_member.dart';

class AuthStore {
  Guardian? guardian;
  StaffMember? staff;

  bool get isAuthenticated => guardian != null || staff != null;

  void setGuardian(Guardian value) {
    guardian = value;
    staff = null;
  }

  void setStaff(StaffMember value) {
    staff = value;
    guardian = null;
  }

  void updateGuardian(Guardian value) {
    guardian = value;
  }

  void updateStaff(StaffMember value) {
    staff = value;
  }

  void logout() {
    guardian = null;
    staff = null;
  }
}
