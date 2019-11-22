/// Support for doing something awesome.
///
/// More dartdocs go here.
library nes_dart;

import 'package:NES_Dart/src/CPU.dart';

export 'src/CPU.dart';
export 'src/register.dart';

// TODO: Export any libraries intended for clients of this package.
main() {
  CPU cpu = CPU();
  print("cpu $cpu");
}