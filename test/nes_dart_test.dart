import 'package:NES_Dart/nes_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Register tests', () {
    Register register1, register2, register4, register8, register128;

    List<Register> registers;

    const int maxUint8 = 255;
    const int maxUint16 = 65535;
    const int maxUint32 = 4294967295;
    const int maxUint64 = -1; // Can't compile actual largest unsigned int

    setUp(() {
      // Create test registers
      register1 = Register(size: 1);
      register2 = Register(size: 2);
      register4 = Register(size: 4);
      register8 = Register(size: 8);
      register128 = Register(size: 128);

      // Add to generic registers list
      registers = [register1, register2, register4, register8, register128];
    });

    checkAllBytesSetTo(Register register, int value) {
      register.bytes.forEach((byte) => expect(byte, value));
    }

    test('Register Initialization', () {
      for (var register in registers) {
        expect(register.bytes, isNotEmpty);
        checkAllBytesSetTo(register, 0);
      }
    });

    test('Setting Uint8 value', () {
      register1.setBytes(maxUint8);
      checkAllBytesSetTo(register1, 255);
    });

    test('Setting Uint8 to wrong byte offset throws RangeError', () {
      expect(() => register1.setBytes(0x94CB, byteOffset: 2), throwsRangeError);
    });

    test('Adding oversized Uint16 value in Uint8 throws RangeError', () {
      expect(() => register1.setBytes(maxUint16), throwsRangeError);
    });

    test('Setting Uint16 value', () {
      register2.setBytes(maxUint16);
      checkAllBytesSetTo(register2, 255);
    });

    test('Setting Uint32 value', () {
      register4.setBytes(maxUint32);
      checkAllBytesSetTo(register4, 255);
    });

    test('Setting Uint64 value', () {
      register8.setBytes(maxUint64);
      checkAllBytesSetTo(register8, 255);
    });

    test('Clearing register', () {
      register1.clear();
      expect(register1.toInt(), 0);
    });
  });
}
