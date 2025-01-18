import 'dart:io';
import 'package:dart_application_1/dart_application_1.dart'
    as dart_application_1;

void main(List<String> arguments) {
  print('Hello world: ${dart_application_1.calculate()}!');
  print('Hello world2: ${dart_application_1.calculate()}!');

  // New input functionality
  stdout.write('Enter your name: ');
  String? name = stdin.readLineSync();
  print('Hello, $name!');
}
