import 'package:flutter/material.dart';

//Login/Signup Textfields
class TextFieldMethod extends StatefulWidget {
  TextEditingController textController;
  TextInputAction inputAction;
  String label;
  int? maxLines;
  bool showMaxLength;
  int? maxLength;
  bool showObscureIcon;
  TextFieldMethod({
    Key? key,
    required this.textController,
    required this.inputAction,
    required this.label,
    this.maxLines = 1,
    this.showMaxLength = false,
    this.maxLength,
    this.showObscureIcon = false,
  }) : super(key: key);

  @override
  State<TextFieldMethod> createState() => _TextFieldMethodState();
}

class _TextFieldMethodState extends State<TextFieldMethod> {

  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      maxLength: widget.showMaxLength ? widget.maxLength : null,
      controller: widget.textController,
      textInputAction: widget.inputAction,
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.blue.shade700,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: widget.showObscureIcon == true ? IconButton(
          onPressed: (){
            setState(() {
              obscureText = !obscureText;
            });
          }, 
          icon: obscureText ? 
          const Icon(Icons.visibility, color: Colors.grey,) : 
          const Icon(Icons.visibility_off, color: Colors.grey,)
        ) : null,
        labelText: widget.label,
        labelStyle: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black.withOpacity(.5)
        ),
        floatingLabelStyle: TextStyle(color: Colors.blue.shade700),
        filled: true,
        fillColor: Colors.blue.shade100.withOpacity(.19),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade700, width: 1.7)
        ),
        counterText: widget.showMaxLength ? null : '',
      ),
    );
  }
}



//Profile textfields
class MyTextField extends StatefulWidget {
  TextEditingController textController;
  String hintText;
  int? maxLines;
  bool showMaxLength;
  int? maxLength;
  ValueChanged<String?>? onChanged;
  MyTextField({
    Key? key,
    required this.textController,
    required this.hintText,
    this.maxLines = 1,
    this.showMaxLength = false,
    this.maxLength,
    required this.onChanged
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textController,
      maxLines: widget.maxLines,
      maxLength: widget.showMaxLength ? widget.maxLength : null,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.transparent)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.transparent)
        ),
        counterText: widget.showMaxLength ? null : '',
      ),
    );
  }
}