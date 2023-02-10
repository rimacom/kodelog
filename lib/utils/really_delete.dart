import 'package:flutter/material.dart';

showReallyDelete(BuildContext context, void Function() onPressed,
    {text = "Odstranit tuto položku?", bool doNavigatorPop = true}) async {
  if (doNavigatorPop) Navigator.of(context, rootNavigator: true).pop("dialog");
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text(text),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () =>
                      Navigator.of(ctx, rootNavigator: true).pop("dialog"),
                  child:
                      const Text("Ne", style: TextStyle(color: Colors.blue))),
              TextButton(onPressed: onPressed, child: const Text("Ano"))
            ],
          ));
}
