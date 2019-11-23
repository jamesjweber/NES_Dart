import 'ram.dart';
import 'register.dart';

class CPU {
  ProgramCounter PC;
  StackPointer SP;
  Accumulator A;
  IndexRegisterX X;
  IndexRegisterY Y;
  StatusRegister P;

  RAM ram;

  /// Creates the [CPU] and initializes all it's [Register]s
  CPU() {
    // Create Memory
    ram = RAM();

    // Create Registers
    PC = ProgramCounter();
    SP = StackPointer();
    A = Accumulator();
    X = IndexRegisterX();
    Y = IndexRegisterY();
    P = StatusRegister();

    print("CPU created");
  }

  loadRom(dynamic ROM) {

  }
}
