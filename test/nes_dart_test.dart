import 'package:NES_Dart/nes_dart.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    Register register;
    const int maxUint8 = 255;
    const int maxUint16 = 65535;
    const int maxUint32 = 4294967295;
    const int maxUint64 = 922337203685477580;

    setUp(() {
      register = Register(size: 100);
    });

    test('Register Initialization', () {
      print(register.value);
      expect(register.value, isNotEmpty);
      expect(register.value[0], 0);
    });

    test('Setting Uint8 value', () {
      register.setValue(maxUint8);
      print(register.value);
      expect(register.value[0], 255);

      register.setValue(maxUint8);
      print(register.value);
      expect(register.value[0], 255);
    });

    test('Setting Uint16 value', () {
      register.setValue(maxUint16, size: 2);
      print(register.value);
      expect(register.value[0], 255);
    });
  });
}
