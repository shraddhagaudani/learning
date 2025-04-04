
class CommonTextMessages {
  CommonTextMessages._internalConstructor();

  static final CommonTextMessages _instance = CommonTextMessages._internalConstructor();

  factory CommonTextMessages() {
    return _instance;
  }

  ///TextFiled Format
  final String nameFormat = "name";
  final String emailFormat = "email";
  final String passFormat = "password";
  final String numberFormat = "number";
  final String descriptionFormat = "description";
  final String textFormat = "text";
  final String exDateFormat = "exDate";
  final String cardNoFormat = "cardNumber";
  final String idFormat = "id";
  final String titleFormat = "title";
  final String totalAmountFormat = "totalamount";
  final String receiveAmountFormat = "receiveamount";
  final String companyNameFormat = "companyname";
}


class AppStrings {
  static String token = 'token';
  static String isSignedUp = 'isSignedUp';
  static String deviceId = 'deviceId';
  static String image = 'image';
  static String weekly = 'Weekly';
  static String monthly = 'Monthly';
  static String yearly = 'Yearly';

}
