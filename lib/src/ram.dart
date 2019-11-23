import 'dart:typed_data';

import 'constants.dart';
import 'register.dart';

class RAM extends Register {
  RAM() : super(size: memorySize) {
    print("RAM created");
  }

  /// Get [page] (a 256 byte chunk of memory) at index [i].
  /// There are 256 pages of memory in the ram.
  Uint8List page(int i) => bytes.sublist(i * pageSize, pageSize + i * pageSize);

  /// Gets the zero page, which is commonly used for special addressing modes
  get zeroPage => page(0);

  /// Applies the function [f] to each page in the [RAM].
  void forEach(void Function(Uint8List page) f) {
    for (var i = 0; i < pageSize; i++) {
      f(page(i));
    }
  }

  @override
  String toString() {
    String myString = "";
    int i = 0;

    forEach((page) {
      myString += (i < 10 ? "-" : "") +
          "------------------- PAGE ${i} -------------------" +
          (i < 100 ? "-" : "") +
          "\n";

      for (int j = 0; j < 16; j++) {
        myString += page.sublist(j, j + 16).toString() + "\n";
      }

      i += 1;
    });

    return myString;
  }
}
