import 'register.dart';

class CPU {
  ProgramCounter PC;
  StackPointer SP;
  Accumulator A;
  IndexRegisterX X;
  IndexRegisterY Y;
  StatusRegister P;

  /// Creates the [CPU] and initializes all it's [Register]s
  CPU()
      : PC = ProgramCounter(),
        SP = StackPointer(),
        A = Accumulator(),
        X = IndexRegisterX(),
        Y = IndexRegisterY(),
        P = StatusRegister() {
    print("cpu created");
  }

  get programCounter => PC;

  get stackPointer => SP;

  get accumulator => A;

  get indexRegX => X;

  get indexRegY => Y;

  get statusReg => P;
}
