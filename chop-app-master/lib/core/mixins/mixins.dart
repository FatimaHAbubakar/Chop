import 'package:flutter/material.dart';

mixin ErrorDialog {
  void errorDialog(context, message, {Function? onPressed, Function? then}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () => onPressed == null ? {} : onPressed(),
                    child: const Text('Back'))
              ],
            )).then((value) => then == null ? {} : then()));
  }
}
