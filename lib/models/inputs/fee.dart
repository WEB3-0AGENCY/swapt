import 'package:formz/formz.dart';

const ALPHABET = "0123456789";

class FeeInput extends FormzInput<String, String> {
  static const String labelText = "Fee";
  static const String hintText = "1000";

  const FeeInput.pure() : super.pure("");
  const FeeInput.dirty({String value = ""}) : super.dirty(value);

  @override
  String? validator(String value) {
    if(value.contains("."))
      return "Please use mojo / smallest unit to specify the fee!";
    if(value.length == 0)
      return "Uh...";
    if(value.length > 24)
      return "Hm...";
    for(int i = 0;i < value.length; ++i)
      if(!ALPHABET.contains(value[i]))
        return "That's not a number!";
    return null;
  }
}
