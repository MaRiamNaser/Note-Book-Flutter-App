import 'package:flutter/material.dart';

class ExitConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
        height: 300,
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'images/bin2.png',
                  height: 120,
                  width: 120,
                ),
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              /*DemoLocalizations.of(context)
                  .getTranslatedValue("areYouSuretodeleteIt"),*/
              "Are You sure to delete it?🔪🔪",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontFamily: 'Chewy',
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: Text(
                //'If back button is pressed by mistake then click on no to continue.'
                // 'If you deleted it You cannot restore it again!'
                "",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    /*DemoLocalizations.of(context).getTranslatedValue("no"),*/
                    "No",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Chewy',
                    ),
                  ),
                  textColor: Colors.white,
                ),
                SizedBox(
                  width: 8,
                ),
                RaisedButton(
                  onPressed: () {
                    return Navigator.of(context).pop(true);
                  },
                  child: Text(
                    /*DemoLocalizations.of(context).getTranslatedValue("yes"),*/
                    "Yes",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Chewy',
                    ),
                  ),
                  color: Colors.white,
                  textColor: Colors.pinkAccent,
                )
              ],
            )
          ],
        ),
      );
}
