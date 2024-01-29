import 'package:flutter/material.dart';

//Definindo um campo de texto customizado o qual pode ser usado nos formulários de login e cadastro
class CustomTextFieldConfig extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSecret;
  final String? initialValue;
  final bool readOnly;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const CustomTextFieldConfig({
    super.key,
    required this.icon,
    required this.label,
    this.isSecret = false,
    this.controller,
    this.initialValue,
    this.readOnly = false,
    this.keyboardType,
    this.validator,
  });

  @override
  State<CustomTextFieldConfig> createState() => _CustomTextFieldConfigState();
}

class _CustomTextFieldConfigState extends State<CustomTextFieldConfig> {
  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isSecret;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15,
      ),
      child: TextFormField(
        obscureText: isObscure,
        initialValue: widget.initialValue,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.isSecret
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon:
                      Icon(isObscure ? Icons.visibility : Icons.visibility_off),
                )
              : null,
          labelText: widget.label,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        controller: widget.controller,
        readOnly: widget.readOnly,
      ),
    );
  }
}
