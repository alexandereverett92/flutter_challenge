import 'package:flutter/material.dart';

class SizedLoadingIndicator extends StatelessWidget {
  const SizedLoadingIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(
        width: 24,
        height: 24,
      ),
      child: const CircularProgressIndicator(),
    );
  }
}
