import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RatingService {
  final RateMyApp rateMyApp = RateMyApp(
    //preferencesPrefix: 'rateMyApp_',
    //minDays: 7,
    // minLaunches: 2,
    remindDays: 2,
    remindLaunches: 11,
    googlePlayIdentifier: 'metakinisi.app',
  );

  void showDialog(BuildContext context) {
    rateMyApp.showStarRateDialog(
      context,
      title: 'Βαθμολογία', // The dialog title.
      message:
          'Αν σου αρέσει η εφαρμογή, αφιέρωσε ελάχιστο χρόνο για να τη βαθμολογήσεις :', // The dialog message.
      actionsBuilder: (_, stars) {
        // Triggered when the user updates the star rating.
        return [
          // Return a list of actions (that will be shown at the bottom of the dialog).
          FlatButton(
            child: Text('OK'),
            onPressed: () async {
              print('Thanks for the ' +
                  (stars == null ? '0' : stars.round().toString()) +
                  ' star(s) !');
              // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
              // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
              await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
              Navigator.pop<RateMyAppDialogButton>(
                  context, RateMyAppDialogButton.rate);
            },
          ),
        ];
      },
      ignoreIOS:
          false, // Set to false if you want to show the native Apple app rating dialog on iOS.
      dialogStyle: DialogStyle(
        // Custom dialog styles.
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        messagePadding: EdgeInsets.only(bottom: 20),
      ),
      starRatingOptions: StarRatingOptions(), // Custom star bar rating options.
      onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
          .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
    );
  }

  void showDialog2(BuildContext context) {
    rateMyApp.init().then((_) {
   //   if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(
          context,
          title: 'Βαθμολόγησε το 13033', // The dialog title.
          message:
              'Αν σου αρέσει η εφαρμογή, θα αφιερώσεις 2 λεπτά για να μας βαθμολογήσεις?', // The dialog message.
          rateButton: 'Ναι', // The dialog "rate" button text.
          noButton: 'Όχι', // The dialog "no" button text.
          laterButton: 'Ίσως αργότερα', // The dialog "later" button text.
          listener: (button) {
            // The button click listener (useful if you want to cancel the click event).
            switch (button) {
              case RateMyAppDialogButton.rate:
                print('Clicked on "Rate".');
                break;
              case RateMyAppDialogButton.later:
                print('Clicked on "Later".');
                break;
              case RateMyAppDialogButton.no:
                print('Clicked on "No".');
                break;
            }

            return true; // Return false if you want to cancel the click event.
          },
          ignoreIOS:
              false, // Set to false if you want to show the native Apple app rating dialog on iOS.
          dialogStyle: DialogStyle(), // Custom dialog styles.
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
              .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
          // actionsBuilder: (_) => [], // This one allows you to use your own buttons.
        );
     // }
    });
  }
}
