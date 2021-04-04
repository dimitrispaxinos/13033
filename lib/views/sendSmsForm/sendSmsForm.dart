import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metakinisi/helper.dart';
import 'package:metakinisi/shared/profileService.dart';

import 'package:metakinisi/viewModels/sendSmsViewModel.dart';
import 'package:metakinisi/views/main/bloc/bloc/main_bloc.dart';
import 'package:metakinisi/views/sendSmsForm/bloc/bloc/sendsms_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SendSmsView extends StatefulWidget {
  SendSmsView({Key key, this.viewModel}) : super(key: key);
  final SendSmsViewModel viewModel;

  @override
  State<StatefulWidget> createState() => SendSmsViewState();
}

class SendSmsViewState extends State<SendSmsView> {
  Bloc<SendsmsEvent, SendsmsState> _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _bloc = new SendsmsBloc();
  }

  @override
  Widget build(BuildContext context) {
    var ps = new ProfileService();
    var totalNumberOfMessage = ps.getTotalMessagesNumber();

    var cont = Container(
        child: BlocBuilder<SendsmsEvent, SendsmsState>(
      bloc: _bloc,
      builder: (BuildContext context, SendsmsState state) {
        return Scaffold(
            bottomNavigationBar: BottomAppBar(
                child: new Container(
                    padding: new EdgeInsets.fromLTRB(5, 10, 5, 20),
                    child: _createFooter())),
            key: _scaffoldKey,
            appBar: AppBar(
                backgroundColor: Helper.getStandardThemeColor(),
                actions: <Widget>[
                  IconButton(
                      color: totalNumberOfMessage >= 4
                          ? Colors.white
                          : Colors.transparent,
                      icon: Icon(Icons.star),
                      disabledColor: Colors.grey,
                      onPressed: () {
                        var marketurl =
                            'https://play.google.com/store/apps/details?id=metakinisi.app';

                        launch(marketurl);
                      }),
                  IconButton(
                      icon: Icon(Icons.share),
                      disabledColor: Colors.grey,
                      //enabled: widget.alert.id != null,
                      onPressed: () {
                        BlocProvider.of<MainBloc>(context)
                            .dispatch(ShareApplication());
                      }),
                ],
                title: Text(widget.viewModel.movingCode == null
                    ? 'Λόγος μετακίνησης'
                    : '')),
            body: new Container(
                padding: new EdgeInsets.all(10.0),
                child: widget.viewModel.movingCode == null
                    ? _createForm()
                    : _createSendForm()));
      },
    ));
//return cont;
    return WillPopScope(
        onWillPop: () {
          if (widget.viewModel.movingCode != null) {
            _bloc.dispatch(new RemoveMovingCodeEvent(widget.viewModel));
          } else {
            SystemNavigator.pop();
            //Navigator.of(context).pop();
          }
          return;
        },
        child: cont);
  }

  void _addCodeToViewModel(int movingCode, String reasonText) {
    widget.viewModel.movingCode = movingCode;
    widget.viewModel.reasonText = reasonText;
    var event = new AddMovingCodeEvent(widget.viewModel);
    _bloc.dispatch(event);
  }

  Widget _createForm() {
    ListView col = new ListView(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
        ),
        _createNineToFiveWarning(),
        _createButton(1, 'Φαρμακείο / Γιατρός'),
        _createButton(2, 'Σούπερ Μάρκετ'),
        _createButton(3, 'Τράπεζα / Δημόσιες Υπηρεσίες'),
        _createButton(4, 'Παροχή Βοήθειας / Συνοδεία Μαθητών'),
        _createButton(5, 'Τελετή / Διαζευγμένοι Γονείς'),
        _createButton(6, 'Άσκηση / Βόλτα με κατοικίδιο'),
        _createButton(7, 'Κατάστημα (13032)'),
        _createEditPersonalDetailsButton(),
      ],
    );

    var form = Form(child: col);

    return form;
  }

  Widget _createNineToFiveWarning() {
    var widget = new Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
        child: new Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: new Text(
              "Από τις 9 το βράδυ μέχρι τις 5 το πρωί επιτρέπονται οι μετακινήσεις αποκλειστικά και μόνο για λόγους εργασίας, εξαιρετικές περιπτώσεις υγείας και μικρή βόλτα κατοικίδιου ζώου σε απόσταση κοντινή από την κατοικία.",
              style: TextStyle(color: Colors.red),
            )));
    var thisInstant = new DateTime.now();

    if (_goingOutIsNotPermitted()) {
      return widget;
    }
    return new Container();
  }

  Widget _createSendForm() {
    ListView col = new ListView(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.fromLTRB(0, 12.0, 0, 0),
        ),
        _createSendButton(),
        _createBackButton(),
        _createRatingControl(),
      ],
    );

    var form = Form(child: col);

    return form;
  }

  Widget _createButton(int movingCode, String buttonText) {
    var buttonColor = Helper.getStandardThemeColor();
    if ((movingCode != 1 && movingCode != 6) && (_goingOutIsNotPermitted())) {
      return new Container();
      buttonColor = Colors.grey;
    }

    if (movingCode == 6 && _goingOutIsNotPermitted()) {
      buttonText = "Βόλτα με Κατοικίδιο";
    }

    var sb = new Container(
        padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 15.0),
        child: SizedBox(
            width: double.infinity,
            height: 50.0,
            child: new RaisedButton(
              elevation: 5.0,
              // shape: new RoundedRectangleBorder(
              //     borderRadius: new BorderRadius.circular(30.0)),
              color: buttonColor,
              child: new Text(buttonText,
                  textAlign: TextAlign.center,
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: () => _addCodeToViewModel(movingCode, buttonText),
            )));
    return sb;
  }

  Widget _createSendButton() {
    var sb = new Container(
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
        child: SizedBox(
            width: double.infinity,
            height: 70.0,
            child: new RaisedButton(
                elevation: 5.0,
                color: Helper.getStandardThemeColor(),
                child: new Text(
                    'Δημιουργία SMS για \n' + widget.viewModel.reasonText,
                    textAlign: TextAlign.center,
                    style: new TextStyle(fontSize: 18.0, color: Colors.white)),
                onPressed: () {
                  _bloc.dispatch(CreateSmsEvent(widget.viewModel));
                })));
    return sb;
  }

  Widget _createEditPersonalDetailsButton() {
    var sb = new Container(
        padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 15.0),
        child: SizedBox(
            width: double.infinity,
            height: 70.0,
            child: new RaisedButton(
                elevation: 5.0,
                color: Colors.yellow,
                child: new Text('Αλλαγή Προσωπικών Στοιχείων',
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 18.0, color: Helper.getStandardThemeColor())),
                onPressed: () {
                  BlocProvider.of<MainBloc>(context)
                      .dispatch(LoadCreatedProfile());
                })));
    return sb;
  }

  Widget _createSentMessagesText() {
    var totalDailySms = widget.viewModel.smsStatistics.getTotalSmsOfTheDay();

    var messagesNotification =
        (totalDailySms != 0 && widget.viewModel.movingCode == null)
            ? 'Συνολικά Σημερινά Μηνύματα: ${totalDailySms.toString()}'
            : '';

    return new Text(messagesNotification,
        textAlign: TextAlign.center,
        style: new TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Helper.getStandardThemeColor()));
  }

  Widget _createBackButton() {
    var sb = new Container(
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
        child: SizedBox(
            width: double.infinity,
            height: 40.0,
            child: new RaisedButton(
              elevation: 5.0,
              color: Colors.grey,
              child: new Text('Αλλαγή Λόγου Μετακίνησης',
                  textAlign: TextAlign.center,
                  style: new TextStyle(fontSize: 18.0, color: Colors.white)),
              onPressed: () =>
                  _bloc.dispatch(new RemoveMovingCodeEvent(widget.viewModel)),
            )));
    return sb;
  }

  Widget _createFooter() {
    return _createCreditsAndCommunication();
    // if (widget.viewModel.movingCode == null &&
    //     widget.viewModel.smsStatistics.getTotalSmsOfTheDay() > 0) {
    //   return _createSentMessagesText();
    // } else {
    //   return _createCreditsAndCommunication();
    // }
  }

  Widget _createCreditsAndCommunication() {
    var text = new Text(
      'Developed by Dimitris Paxinos',
      style: new TextStyle(color: Colors.grey),
      textAlign: TextAlign.center,
    );

    var gd = GestureDetector(
        child: Text("Επικοινωνία",
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 18, color: Helper.getStandardThemeColor())),
        onTap: () {
          _bloc.dispatch(new OpenEmailEvent(widget.viewModel));

          // do what you need to do when "Click here" gets clicked
        });
    var children = new List<Widget>();

    children.add(text);

// Show communicate
    if (widget.viewModel.movingCode != null) {
      children.add(gd);
    }

    var cont = new SizedBox(
      child: new Column(
        children: children,
      ),
      height: 40.0,
    );

    return cont;
  }

  Widget _createRatingControl() {
    var gd = GestureDetector(
        child: Text("Βαθμολογήστε μας",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
                color: Helper.getStandardThemeColor())),
        onTap: () {
          var marketurl =
              'https://play.google.com/store/apps/details?id=metakinisi.app';

          launch(marketurl);
        });

    var cont = new Container(
      child: new Column(
        children: <Widget>[gd],
      ),
      padding: EdgeInsets.fromLTRB(5, 30, 5, 0),
    );

    var ps = new ProfileService();
    var totalNumberOfMessage = ps.getTotalMessagesNumber();

    if (totalNumberOfMessage >= 2 && totalNumberOfMessage <= 4) {
      return cont;
    }

    return new Container();
  }

  bool _goingOutIsNotPermitted() {
    var thisInstant = new DateTime.now();
    if (thisInstant.hour >= 21 || thisInstant.hour < 5) {
      return true;
    }
    return false;
  }
}
