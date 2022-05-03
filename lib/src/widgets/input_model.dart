import 'package:ctpat/src/tokens/colors.dart';
import 'package:ctpat/src/tokens/typography.dart';
import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final Color color;
  final Icon icon;
  final Icon prefixIcon;
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final validator;
  final autofillHint;
  final isRequired;
  final autoFocus;

  const Input(
      {Key key,
      this.color,
      this.icon,
      this.prefixIcon,
      this.label,
      this.hintText,
      this.keyboardType,
      this.controller,
      this.validator,
      this.autofillHint,
      this.isRequired,
      this.autoFocus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isRequired != null
            ? Text("$label *", style: subtitle)
            : Text("$label", style: subtitle),
        SizedBox(height: 4),
        TextFormField(
            autofillHints: autofillHint,
            minLines: 1, //Normal textInputField will be displayed
            maxLines: 5,
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            style: bodyBlack,
            autocorrect: false,
            autofocus: autoFocus ?? false,
            decoration: InputDecoration(
                prefixIcon: prefixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 8.0),
                        child: prefixIcon,
                      )
                    : null,
                hintText: hintText,
                hintStyle: bodyGray40,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(color: gray20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(color: primaryClr),
                ),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: accentRed)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: accentRed)))),
      ],
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final validator;
  final String label;
  final hintText;

  final isRequired;
  const PasswordField(
      {Key key,
      this.controller,
      this.validator,
      this.label,
      this.hintText,
      this.isRequired})
      : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  @override
  bool _obscureText = true;
  bool _password = true;
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    void _toggle() {
      setState(() {
        _obscureText = !_obscureText;
      });
      void _showPassword() {
        setState(() {
          _password = !_password;
        });
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.isRequired != null
            ? Text("${widget.label} *", style: subtitle)
            : Text("${widget.label}", style: subtitle),
        SizedBox(height: 4),
        TextFormField(
          obscureText: _obscureText,
          style: bodyBlack,
          controller: widget.controller,
          autocorrect: false,
          validator: widget.validator,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 8.0),
              child: Icon(Icons.lock),
            ),
            hintText: widget.hintText,
            hintStyle: bodyGray40,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: gray20),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: primaryClr),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(color: accentRed)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(color: accentRed)),
            suffixIcon: GestureDetector(
              onTap: () {
                _toggle();
              },
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
