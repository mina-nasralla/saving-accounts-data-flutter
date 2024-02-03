import 'package:flutter/material.dart';
import 'package:valo_accounts/constants/components.dart';

class Textfield extends StatefulWidget {
  String? hint;
  final IconData icon;
  IconData? suffix;
  final TextInputType keyboardtype;
  final bool obsecure;
  TextEditingController? textEditingController;

  Textfield({
    super.key,
    required this.onclick,
    this.hint,
    this.suffix,
    required this.icon,
    required this.keyboardtype,
    required this.obsecure,
    required this.textEditingController,
  });

  late Function(String)? onclick;

  @override
  State<Textfield> createState() => _TextfieldState();
}

class _TextfieldState extends State<Textfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obsecure,
      onChanged: widget.onclick,
      controller: widget.textEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'This Field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.red),
        hintText: widget.hint,
        prefixIcon: Icon(
          widget.icon,
          color: Colors.white,
        ),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: primaryColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: primaryColor)),
      ),
    );
  }
}
