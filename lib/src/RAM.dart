class RAM {
  static const MEMORY_SIZE = 0xFFFF;
  final List<int> _bytes;

  RAM() : _bytes = List(MEMORY_SIZE);

  operator [](int i) => _bytes[i];

  operator []=(int i, int value) => _bytes[i] = value;
}
