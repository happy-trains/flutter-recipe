class OutputConverter {
  static final _regExp = RegExp(r'(\d{3})+$');

  String commaSeparatedNumber(int number) {
    final numberString = number.toString();

    return numberString.splitMapJoin(
      _regExp,
      onMatch: (match) {
        final _match = match[0]!;

        if (match.start > 0 || match[0]!.length > 3) {
          final digits = _match.split('');
          final stringBuffer = StringBuffer();

          if (match.start > 0) {
            stringBuffer.write(',${digits[0]}');
          } else {
            stringBuffer.write(digits[0]);
          }

          for (var i = 1; i < digits.length; i++) {
            if (i % 3 == 0) {
              stringBuffer.write(',');
            }
            stringBuffer.write(digits[i]);
          }

          return stringBuffer.toString();
        }

        return _match;
      },
      onNonMatch: (n) {
        return n;
      },
    );
  }
}
