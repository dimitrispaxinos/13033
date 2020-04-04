import 'package:metakinisi/shared/amplitudeLogProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metakinisi/helper.dart';
import 'package:metakinisi/shared/profileService.dart';
import 'package:metakinisi/shared/ratingService.dart';

import 'package:metakinisi/viewModels/sendSmsViewModel.dart';
import 'package:metakinisi/views/main/bloc/bloc/main_bloc.dart';
import 'package:metakinisi/views/sendSmsForm/bloc/bloc/sendsms_bloc.dart';
import 'package:flutter_sms/flutter_sms.dart';
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
    //_bloc.dispatch(new AddMovingCodeEvent())
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: BlocBuilder<SendsmsEvent, SendsmsState>(
      bloc: _bloc,
      builder: (BuildContext context, SendsmsState state) {
        return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
                backgroundColor: Helper.getStandardThemeColor(),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.share),
                      disabledColor: Colors.grey,
                      //enabled: widget.alert.id != null,
                      onPressed: () {
                        BlocProvider.of<MainBloc>(context)
                            .dispatch(ShareApplication());
                      })
                ],
                title: Text(widget.viewModel.movingCode == null
                    ? '13033: Λόγος μετακίνησης'
                    : '')),
            body: new Container(
                padding: new EdgeInsets.all(10.0),
                child: widget.viewModel.movingCode == null
                    ? _createForm()
                    : _createSendForm()));
      },
    ));
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
        _createButton(1, 'Φαρμακείο ή Γιατρός'),
        _createButton(2, 'Σούπερ μάρκετ)'),
        _createButton(3, 'Τράπεζα'),
        _createButton(4, 'Παροχή βοήθειας'),
        _createButton(5, 'Τελετή'),
        _createButton(5, 'Μετάβαση διαζευγμένων γονέων'),
        _createButton(6, 'Σωματική άσκηση'),
        _createButton(6, 'Βόλτα με κατοικίδιο'),
        _createEditPersonalDetailsButton(),
        _createSentMessagesText()
      ],
    );

    var form = Form(child: col);

    return form;
  }

  Widget _createSendForm() {
    ListView col = new ListView(
      children: <Widget>[
        _createSendButton(),
        _createBackButton(),
        _createSentMessagesText(),
        _createFooter(),
        _createRatingFooter()
      ],
    );

    var form = Form(child: col);

    return form;
  }

  Widget _createButton(int movingCode, String buttonText) {
    var sb = new Container(
        padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 15.0),
        child: SizedBox(
            width: double.infinity,
            height: 50.0,
            child: new RaisedButton(
              elevation: 5.0,
              // shape: new RoundedRectangleBorder(
              //     borderRadius: new BorderRadius.circular(30.0)),
              color: Helper.getStandardThemeColor(),
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
                // shape: new RoundedRectangleBorder(
                //     borderRadius: new BorderRadius.circular(30.0)),
                color: Helper.getStandardThemeColor(),
                child: new Text(
                    'Δημιουργία SMS για \n' + widget.viewModel.reasonText,
                    textAlign: TextAlign.center,
                    style: new TextStyle(fontSize: 18.0, color: Colors.white)),
                //onPressed: () => Scaffold.of(context).showSnackBar(snackBar)),
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
    var messagesNotification = widget.viewModel.numberOfSentMessages != 0
        ? 'Σημέρα έχουν δημιουγηθεί ${widget.viewModel.numberOfSentMessages.toString()} μηνύματα.'
        : '';

    return new Text(messagesNotification,
        textAlign: TextAlign.center,
        style: new TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Helper.getStandardThemeColor()));
  }

  void _showSnackBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        'Το SMS εστάλη επιτυχώς',
        style: Helper.getIntroTextStyle(),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Helper.getStandardThemeColor(),
    ));
  }

  Widget _createBackButton() {
    var sb = new Container(
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
        child: SizedBox(
            width: double.infinity,
            height: 30.0,
            child: new RaisedButton(
              elevation: 5.0,
              // shape: new RoundedRectangleBorder(
              //     borderRadius: new BorderRadius.circular(30.0)),
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
    var text = new Text(
      'Developed by Dimitris Paxinos',
      style: new TextStyle(color: Colors.grey),
      textAlign: TextAlign.center,
    );

    var gd = GestureDetector(
        child: Text("Επικοινωνία",
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Helper.getStandardThemeColor())),
        onTap: () {
          _bloc.dispatch(new OpenEmailEvent(widget.viewModel));

          // do what you need to do when "Click here" gets clicked
        });
    var children = new List<Widget>();

    children.add(text);

    if (!(widget.viewModel.numberOfSentMessages > 2 &&
        widget.viewModel.numberOfSentMessages < 8)) {
      children.add(gd);
    }

    var cont = new Container(
        child: new Column(
          children: children,
        ),
        margin: new EdgeInsets.fromLTRB(0, 20, 0, 0));

    return cont;
  }

  Widget _createRatingFooter() {
    var gd = GestureDetector(
        child: Text("Βαθμολογήστε μας",
            style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.none,
                color: Helper.getStandardThemeColor())),
        onTap: () {
          var rs = new RatingService();
          rs.showDialog2(context);
          // do what you need to do when "Click here" gets clicked
        });

    var cont = new Container(
        child: new Column(
          children: <Widget>[gd],
        ),
        margin: new EdgeInsets.fromLTRB(0, 20, 0, 0));

    if (widget.viewModel.numberOfSentMessages > 2 &&
        widget.viewModel.numberOfSentMessages < 8) {
      return cont;
    }
    return new Container();
  }
}
