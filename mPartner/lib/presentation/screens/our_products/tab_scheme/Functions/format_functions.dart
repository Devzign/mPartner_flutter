import '../components/Functions/constants/userType.dart';

String formatCurrentMonth(List<String> list) {
  // print("${list[0]} ${list[1].substring(2)}");
  return "${list[0]},${list[1].substring(2)}";
}

String formatLuminousUserTypeToString(LuminuousUserType customerType) {
  switch (customerType) {
    case LuminuousUserType.ALL:
      return "All";
    case LuminuousUserType.DEALER:
      return "Dealer";
    case LuminuousUserType.DISTY:
      return "Distributor";
    case LuminuousUserType.ELECTRICIAN:
      return "Electrician";
    default:
      {
        return "All";
      }
  }
}

String getMonthName(int month) {
  // Convert the numeric month to its name
  switch (month) {
    case 1:
      return 'January ${DateTime.now().year.toString()}';
    case 2:
      return 'February ${DateTime.now().year.toString()}';
    case 3:
      return 'March ${DateTime.now().year.toString()}';
    case 4:
      return 'April ${DateTime.now().year.toString()}';
    case 5:
      return 'May ${DateTime.now().year.toString()}';
    case 6:
      return 'June ${DateTime.now().year.toString()}';
    case 7:
      return 'July ${DateTime.now().year.toString()}';
    case 8:
      return 'August ${DateTime.now().year.toString()}';
    case 9:
      return 'September ${DateTime.now().year.toString()}';
    case 10:
      return 'October ${DateTime.now().year.toString()}';
    case 11:
      return 'November ${DateTime.now().year.toString()}';
    case 12:
      return 'December ${DateTime.now().year.toString()}';
    default:
      return 'Unknown ${DateTime.now().year.toString()}';
  }
}
