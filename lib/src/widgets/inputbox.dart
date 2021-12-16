// ignore_for_file: camel_case_types

import 'package:e_chalan/src/theme/colors.dart';
import 'package:e_chalan/src/theme/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class inputBox extends StatefulWidget {
  TextEditingController? controller;
  String? labelText, errorText;
  Function? onchanged;
  List<TextInputFormatter>? inuptformat;
  bool? obscureText, error;
  bool? ispassword = false;
  bool? istextarea = false;
  bool? readonly = false;
  int? minLine;
  Widget? suffixIcon;
  inputBox(
      {Key? key,
      this.controller,
      this.labelText,
      this.error,
      this.errorText,
      this.inuptformat,
      this.obscureText,
      this.ispassword,
      this.istextarea,
      this.readonly,
      this.minLine,
      this.suffixIcon,
      this.onchanged})
      : super(key: key);

  @override
  _inputBoxState createState() => _inputBoxState();
}

class _inputBoxState extends State<inputBox> {
  bool? error, obscureText, hidepass = false;

  @override
  void initState() {
    if (widget.obscureText!) {
      setState(() {
        hidepass = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: todo
    // TODO: implement build
    return TextField(
      controller: widget.controller,
      cursorColor: Theme.of(context).primaryColor,
      obscureText: hidepass!,
      onChanged: widget.onchanged as void Function(String)?,
      inputFormatters: widget.inuptformat,
      maxLines: widget.istextarea!
          ? null
          : widget.obscureText!
              ? 1
              : widget.minLine,
      minLines: widget.minLine,
      textAlignVertical: TextAlignVertical.top,
      readOnly: widget.readonly!,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: black,
      ),
      decoration: InputDecoration(
        focusColor: black,
        fillColor: grey,
        errorText: widget.error! ? widget.errorText : null,

        contentPadding: const EdgeInsets.all(subMargin),
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: black, fontSize: subMargin + 2),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
          borderSide:
              BorderSide(width: 2, color: Theme.of(context).primaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
          borderSide: const BorderSide(width: 1, color: grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
          borderSide: const BorderSide(width: 1, color: black),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            borderSide: const BorderSide(
              width: 1,
            )),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            borderSide: const BorderSide(width: 1.5, color: errorColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            borderSide: const BorderSide(width: 2, color: errorColor)),
        //  isDense: true,
        errorStyle: const TextStyle(color: errorColor, height: 0),
        alignLabelWithHint: true,

        suffixIcon: widget.ispassword!
            ? IconButton(
                onPressed: () {
                  if (widget.ispassword!) {
                    setState(() {
                      if (hidepass == true) {
                        hidepass = false;
                      } else {
                        hidepass = true;
                      }
                    });
                  }
                },
                splashColor: Colors.transparent,
                icon: Icon(
                  hidepass! ? Icons.password : Icons.remove_red_eye,
                  color: widget.ispassword! ? black.withOpacity(0.6) : white,
                ),
              )
            : widget.suffixIcon,
      ),
    );
  }
}

SnackBar redsnackBar(String text) {
  return SnackBar(
    content: Text(text),
    backgroundColor: errorColor,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(20),
    duration: Duration(seconds: 1),
  );
}

SnackBar greensnackBar(String text) {
  return SnackBar(
    content: Text(text),
    backgroundColor: succses,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(20),
    duration: Duration(seconds: 1),
  );
}

Center greenProgressBar({BuildContext? context}) {
  return Center(
      child: Container(
    width: 60,
    height: 60,
    child: CircularProgressIndicator(
      valueColor:
          AlwaysStoppedAnimation<Color>(Theme.of(context!).primaryColor),
      backgroundColor: grey,
    ),
  ));
}

Center progressBar({required BuildContext context}) {
  return Center(
      child: Container(
    width: 60,
    height: 60,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      backgroundColor: grey,
    ),
  ));
}
