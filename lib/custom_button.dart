// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

Widget customButton(
    Color bgClr, String text, Color txtClr, BuildContext context,
    {IconData? iconData}) {
  return Container(
    height: 56,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: bgClr,
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconData != null)
            Icon(
              iconData,
              color: txtClr,
            ),
          if (iconData != null) const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

Center loadingButton() {
  return Center(
    child: Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.teal[500],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
        ),
      ),
    ),
  );
}
