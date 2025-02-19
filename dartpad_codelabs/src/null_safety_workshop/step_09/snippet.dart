import 'dart:math';

class StringProvider {
  String? value = 'A String!';
}

class RandomStringProvider extends StringProvider {
  @override
  void set value(String? v) {}

  @override
  String? get value =>
    Random().nextBool() ? 'A String!' : null;
}

void printString(String str) => print(str);

void main() {
  StringProvider provider = RandomStringProvider();

  if (provider.value == null) {
    print('The value is null.');
  }

  printString(provider.value);
}
