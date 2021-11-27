import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/core/utils/output_converter.dart';

void main() {
  group('OutputConverter', () {
    group('commaSeparatedNumber should return', () {
      late OutputConverter outputConverter;

      setUp(() {
        outputConverter = OutputConverter();
      });

      test(
        '"12"',
        () async {
          // act
          final result = outputConverter.commaSeparatedNumber(12);
          // assert
          expect(result, '12');
        },
      );
      test(
        '"123"',
        () async {
          // act
          final result = outputConverter.commaSeparatedNumber(123);
          // assert
          expect(result, '123');
        },
      );
      test(
        '"1,234"',
        () async {
          // act
          final result = outputConverter.commaSeparatedNumber(1234);
          // assert
          expect(result, '1,234');
        },
      );
      test(
        '"123,456"',
        () async {
          // act
          final result = outputConverter.commaSeparatedNumber(123456);
          // assert
          expect(result, '123,456');
        },
      );
      test(
        '"1,234,567"',
        () async {
          // act
          final result = outputConverter.commaSeparatedNumber(1234567);
          // assert
          expect(result, '1,234,567');
        },
      );
    });
  });
}
