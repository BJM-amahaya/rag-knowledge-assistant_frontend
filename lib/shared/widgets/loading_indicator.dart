import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  const LoadingIndicator({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          if (message != null)
            Padding(
              padding: EdgeInsetsGeometry.only(top: 16),
              child: Text(message!),
            ),
        ],
      ),
    );
  }
}
