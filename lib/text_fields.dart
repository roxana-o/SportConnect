//Some icons used in this projetc are made by Freepik from www.flaticon.com

import 'package:flutter/material.dart';

class NewTextField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;
  final int noLines;
  final hintStyle;
  final inputType;
  final context;
  final suffixIcon;

  final String? Function(String?)? validateText;

  const NewTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.noLines,
    this.validateText,
    this.hintStyle,
    this.inputType,
    this.context,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          controller: controller,
          maxLines: noLines,
          obscureText: obscureText,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          //hintStyle,
          validator: validateText,
          //suffixIcon:suffixIcon,

          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            fillColor: Theme.of(context).colorScheme.background,
            filled: true,
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}

Widget customField({
  iconPath,
  text,
  Function? onPressed,
  bool isReadOnly = false,
  TextEditingController? textController,
  TextInputType inputType = TextInputType.text,
  Function? inputValidator,
  double containerHeight = 30,
  double containerWidth = 130,
}) {
  return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.1, color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        height: containerHeight,
        width: containerWidth,
        child: TextFormField(
          validator: (String? input) => inputValidator!(input!),
          controller: textController,
          keyboardType: inputType,
          readOnly: isReadOnly,
          onTap: () {
            onPressed!();
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 2),
            prefixIcon: Container(
              child: Image.asset(
                iconPath,
                cacheHeight: 20,
              ),
            ),
            hintText: text,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            border: isReadOnly
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5))
                : OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ));
}

Widget newText(
    {String? customText, TextStyle? customStyle, TextAlign? customTextAlign}) {
  return Padding(
      padding: EdgeInsets.only(
        left: 20,
        bottom: 5,
      ),
      child: Text(
        customText!,
        style: customStyle,
        textAlign: customTextAlign,
        //overflow: TextOverflow.ellipsis,
      ));
}
