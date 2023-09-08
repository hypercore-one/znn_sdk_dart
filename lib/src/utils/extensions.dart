import 'package:big_decimal/big_decimal.dart';

extension StringExtensions on String {
  BigInt extractDecimals(int decimals) {
    if (!contains('.')) {
      if (decimals == 0 && isEmpty) {
        return BigInt.zero;
      }
      return BigInt.parse(this + ''.padRight(decimals, '0'));
    }
    List<String> parts = split('.');

    return BigInt.parse(parts[0] +
        (parts[1].length > decimals
            ? parts[1].substring(0, decimals)
            : parts[1].padRight(decimals, '0')));
  }
}

extension BigIntExtensions on BigInt {
  String addDecimals(int decimals) {
    return BigDecimal.createAndStripZerosForScale(this, decimals, 0)
        .toPlainString();
  }
}
