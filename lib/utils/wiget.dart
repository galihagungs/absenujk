import 'package:flutter/material.dart';

SizedBox uniButton(
  BuildContext context, {
  required Text title,
  required VoidCallback func,
  required Color warna,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(warna),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      onPressed: func,
      // child: Text(title, style: kanit16semiBoldMainWhite),
      child: title,
    ),
  );
}
