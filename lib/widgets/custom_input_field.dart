import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;

  const CustomTextFormField(
      {super.key,
      required this.onSaved,
      required this.regEx,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (value) => onSaved(value!),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      validator: (value) {
        return RegExp(regEx).hasMatch(value!) ? null : 'Enter a valid value.';
      },
      decoration: InputDecoration(
          hintText: hintText,
          fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
          hintStyle: const TextStyle(color: Colors.white54)),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final Function(String) onEditingComplete;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  IconData? icon;

  CustomTextField(
      {super.key,
      required this.onEditingComplete,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
   controller: controller,
      onEditingComplete: ()=>onEditingComplete(controller.value.text),
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration:InputDecoration(
        fillColor: Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        hintText: hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none),
          hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon,color: Colors.white54)
      ),
    );
  }
}
