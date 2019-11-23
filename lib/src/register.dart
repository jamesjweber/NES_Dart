import 'dart:typed_data';

import 'constants.dart';

extension Byte on int {
  /// Operator override for [] allows us to access each bit as a boolean.
  bool operator [](int i) => (this & 0x01 << i) != 0;

  /// Operator override for []= allows us to set each bit.
  void operator []=(int i, bool set) => this & ~((set ? 0x1 : 0x0) << i);

  /// Returns the value of the bit at [index] as a [bool].
  bool bit(int index) => this[index];

  /// Sets the bit at [index] to 1 or 0 based on the value in [set].
  /// If a value is not provided, the bit is set to true.
  void setBit(int index, [bool set]) => this[index] = set ?? true;
}

/// A base class used to represent registers that will hold [size] number
/// of [bytes] using a [Uint8List] implementation to be memory efficient.
class Register {
  /// Size of the register in bytes.
  final int size;

  /// A [Uint8List] that's [size] bytes long, that holds data in the [Register].
  final Uint8List bytes;

  /// Creates a [Register] of that is [size] bytes.
  Register({this.size = 1}) : bytes = Uint8List(size);

  @override
  String toString() => bytes.toString();

  /// Operator override for [] allows us to access each byte.
  int operator [](int i) => bytes[i];

  /// Operator override for []= allows us to set each byte.
  void operator []=(int i, int value) => setBytes(value, byteOffset: i);

  /// Returns a [ByteData] _view_ of the buffer that
  /// can be used to get/set unsigned int values.
  ByteData get _byteData => ByteData.view(bytes.buffer);

  /// Sets the [value] in the register at the [byteOffset].
  void setBytes(int value, {int byteOffset = 0}) {
    try {
      // Very large unsigned ints represented as negatives cause dart sucks.
      if (value.sign == -1) return _byteData.setUint64(byteOffset, value);

      // If value is positive, find properly size representation.
      if (value <= maxUint8) return _byteData.setUint8(byteOffset, value);
      if (value <= maxUint16) return _byteData.setUint16(byteOffset, value);
      if (value <= maxUint32) return _byteData.setUint32(byteOffset, value);
      if (value <= maxUint64) return _byteData.setUint64(byteOffset, value);
    } catch (e) {
      rethrow;
    }
  }

  /// Converts the value in the [Register] to an [int]. You may optionally
  /// provide a [byteSize] to specify how many bytes you'd like. You can also
  /// specify an [byteOffset] to get an int from that location.
  int toInt({int byteOffset = 0, int byteSize = 1}) {
    try {
      if (byteSize == 1) return _byteData.getUint8(byteOffset);
      if (byteSize == 2) return _byteData.getUint16(byteOffset);
      if (byteSize == 4) return _byteData.getUint32(byteOffset);
      if (byteSize == 8) return _byteData.getUint64(byteOffset);
    } catch (e) {
      rethrow;
    }
    throw Exception("Byte size must be 1, 2, 4, or 8");
  }

  /// Clears all the bytes in the [Register].
  void clear() => bytes.forEach((byte) => byte = 0);
}

/// The program counter is a 16 bit register which points to the next
/// instruction to be executed. The value of program counter is modified
/// automatically as instructions are executed.
///
/// The value of the program counter can be modified by executing a jump, a
/// relative branch or a subroutine call to another memory address or by
/// returning from a subroutine or interrupt.
class ProgramCounter extends Register {
  ProgramCounter() : super(size: 2) {
    print("Program Counter created");
  }

  int toInt({byteOffset = 0, byteSize = 1}) => super.toInt(byteSize: this.size);
}

/// The processor supports a 256 byte stack located between $0100 and $01FF.
/// The stack pointer is an 8 bit register and holds the low 8 bits of the next
/// free location on the stack. The location of the stack is fixed and cannot
/// be moved.
///
/// Pushing bytes to the stack causes the stack pointer to be decremented.
/// Conversely pulling bytes causes it to be incremented.
///
/// The CPU does not detect if the stack is overflowed by excessive pushing or
/// pulling operations and will most likely result in the program crashing.
class StackPointer extends Register {
  StackPointer() {
    print("Stack Pointer created");
  }
}

/// The 8 bit accumulator is used all arithmetic and logical operations
/// (with the exception of increments and decrements). The contents of the
/// accumulator can be stored and retrieved either from memory or the stack.
///
/// Most complex operations will need to use the accumulator for arithmetic
/// and efficient optimization of its use is a key feature of time critical
/// routines.
class Accumulator extends Register {
  Accumulator() {
    print("Accumulator created");
  }
}

/// The 8 bit index register is most commonly used to hold counters or offsets
/// for accessing memory. The value of the X register can be loaded and saved in
/// memory, compared with values held in memory or incremented and decremented.
///
/// The X register has one special function. It can be used to get a copy of
/// the stack pointer or change its value.
class IndexRegisterX extends Register {
  IndexRegisterX() {
    print("Index Register X created");
  }
}

/// The Y register is similar to the X register in that it is available for
/// holding counter or offsets memory access and supports the same set of
/// memory load, save and compare operations as wells as increments and
/// decrements. It has no special functions.
class IndexRegisterY extends Register {
  IndexRegisterY() {
    print("Index Register Y created");
  }
}

/// As instructions are executed a set of processor flags are set or clear to
/// record the results of the operation. This flags and some additional control
/// flags are held in a special status register. Each flag has a single bit
/// within the register.
///
/// Instructions exist to test the values of the various bits, to set or clear
/// some of them and to push or pull the entire set to or from the stack.
class StatusRegister extends Register {
  StatusRegister() {
    print("Status Register created");
  }

  /// Helper that gets the value of the register.
  int get _byte => toInt();

  /// Gets the [C]arry flag as a bool.
  get C => _byte.bit(7);

  /// Sets the [C]arry flag to [set].
  set C(bool set) => _byte.setBit(7, set);

  /// Gets the [Z]ero flag as a bool.
  get Z => _byte.bit(6);

  /// Sets the [Z]ero flag to [set].
  set Z(bool set) => _byte.setBit(6, set);

  /// Gets the [I]nterrupt disable flag as a bool.
  get I => _byte.bit(5);

  /// Sets the [I]nterrupt disable flag to [set].
  set I(bool set) => _byte.setBit(5, set);

  /// Gets the [D]ecimal flag as a bool.
  get D => _byte.bit(4);

  /// Sets the [D]ecimal flag to [set].
  set D(bool set) => _byte.setBit(4, set);

  /// Gets the [NEM] No Effect MSB (Most Significant Bit) flag as a bool.
  get NEM => _byte.bit(3);

  /// Sets the [NEM] No Effect MSB (Most Significant Bit) flag to [set].
  set NEM(bool set) => _byte.setBit(3, set);

  /// Gets the [NEL] No Effect LSB (Least Significant Bit) flag as a bool.
  get NEL => _byte.bit(2);

  /// Sets the [NEL] No Effect LSB (Least Significant Bit) flag to [set].
  set NEL(bool set) => _byte.setBit(2, set);

  /// Gets the [NE] No Effect flags as a list of bools.
  get NE => [NEM, NEL];

  /// Sets the [NE] No Effect flags to [set].
  set NE(List<bool> set) {
    NEM = set[1];
    NEL = set[0];
  }

  /// Gets the O[V]erflow flag as a bool.
  get V => _byte.bit(1);

  /// Sets the O[V]erflow flag to [set].
  set V(bool set) => _byte.setBit(1, set);

  /// Gets the [N]egative flag as a bool.
  get N => _byte.bit(0);

  /// Sets the [N]egative flag to [set].
  set N(bool set) => _byte.setBit(0, set);
}
