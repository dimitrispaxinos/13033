import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metakinisi/helper.dart';
import 'package:metakinisi/shared/profileService.dart';

import 'package:metakinisi/viewModels/sendSmsViewModel.dart';
import 'package:metakinisi/views/sendSmsForm/bloc/bloc/sendsms_bloc.dart';
import 'package:flutter_sms/flutter_sms.dart';

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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(widget.viewModel.movingCode == null
              ? 'Επιλέξτε το λόγο μετακίνησης'
              : '')),
      body: new Container(
        child: BlocBuilder<SendsmsEvent, SendsmsState>(
          bloc: _bloc,
          builder: (BuildContext context, SendsmsState state) {
            if (widget.viewModel.movingCode == null) {
              return Form(
                child: _createForm(),
              );
            } else {
              return Form(
                child: _createSendForm(),
              );
            }
          },
        ),
        padding: new EdgeInsets.all(20.0),
      ),
    );
  }

  void _addCodeToViewModel(int movingCode, String reasonText) {
    widget.viewModel.movingCode = movingCode;
    widget.viewModel.reasonText = reasonText;
    var event = new AddMovingCodeEvent(widget.viewModel);
    _bloc.dispatch(event);
  }

  Widget _createForm() {
    Column col = new Column(
      children: <Widget>[
        // new Text('Επιλέξτε τον λόγο μετακίνησης'),
        _createButton(1, 'Φαρμακείο ή επίσκεψη σε γιατρό'),
        _createButton(
            2, 'Προμήθεια αγαθών πρώτης ανάγκης (σούπερ/μίνι μάρκετ)'),
        _createButton(3, 'Τράπεζα'),
        _createButton(
            4, 'Παροχή βοήθειας σε ανθρώπους που βρίσκονται σε ανάγκη'),
        _createButton(5, 'Μετάβαση σε τελετή \n (π.χ. κηδεία, γάμος, βάφτιση)'),
        _createButton(5, 'Μετάβαση διαζευγμένων γονέων'),
        _createButton(6, 'Σωματική άσκηση σε \n εξωτερικό χώρο'),
        _createButton(6, 'Κίνηση με κατοικίδιο'),
      ],
    );

    var form = Form(child: col);

    return form;
  }

  Widget _createSendForm() {
    Column col = new Column(
      children: <Widget>[_createSendButton(), _createBackButton()],
    );

    var form = Form(child: col);

    return form;
  }

  Widget _createButton(int movingCode, String buttonText) {
    var sb = new Container(
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
        child: SizedBox(
            width: double.infinity,
            height: 60.0,
            child: new RaisedButton(
              elevation: 5.0,
              // shape: new RoundedRectangleBorder(
              //     borderRadius: new BorderRadius.circular(30.0)),
              color: Helper.getStandardThemeColor(),
              child: new Text(buttonText,
                  textAlign: TextAlign.center,
                  style: new TextStyle(fontSize: 18.0, color: Colors.white)),
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
                    'Αποστολή SMS για \n' + widget.viewModel.reasonText,
                    textAlign: TextAlign.center,
                    style: new TextStyle(fontSize: 18.0, color: Colors.white)),
                //onPressed: () => Scaffold.of(context).showSnackBar(snackBar)),
                onPressed: _sendSms)));
    return sb;
  }

  void _sendSms() async {
//   SmsSender sender = new SmsSender();
//   String address = "13033";
    var profileService = new ProfileService();
    var profile = profileService.getProfile();

    String message = widget.viewModel.movingCode.toString() +
        ' ' +
        profile.name +
        ' ' +
        profile.street +
        ' ' +
        profile.area;

//   sender.sendSms(new SmsMessage(address, message));

    var recipients = new List<String>();
    recipients.add('13033');

    try {
      String _result = await sendSMS(message: message, recipients: recipients);
      setState(() => message = _result);
    } catch (error) {
      setState(() => message = error.toString());
    }

    _showSnackBar();
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

}
