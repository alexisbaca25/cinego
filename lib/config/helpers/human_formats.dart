import 'package:intl/intl.dart';

class HumanFormats {

  // El cambio está aquí: agregamos el parámetro opcional [int decimals = 0]
  static String number(double number, [int decimals = 0]) {

    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: decimals, 
      symbol: '',
      locale: 'en_US',
    ).format(number);

    return formattedNumber;
  }

}