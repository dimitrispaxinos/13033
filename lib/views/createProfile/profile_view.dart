import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metakinisi/helper.dart';

import 'package:metakinisi/viewModels/profileViewModel.dart';
import 'package:metakinisi/views/main/bloc/bloc/main_bloc.dart';

import 'bloc/bloc/create_profile_bloc.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key key, this.title, this.profile}) : super(key: key);

  final String title;
  final ProfileViewModel profile;

  @override
  State<StatefulWidget> createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  Bloc<EditProfileEvent, EditProfileState> _bloc;
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _areaController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _streetFocus = FocusNode();
  final FocusNode _areaFocus = FocusNode();

  GlobalKey textFocus = GlobalKey();
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();

  @override
  void initState() {
    super.initState();

    _bloc = new EditProfileBloc();

    // Add listener for events
    _bloc.state.listen((state) => _actUponEvents(state, context));

    // Dispatch initial event for loading alert
    _bloc.dispatch(new LoadProfileEvent());
  }

  void _actUponEvents(EditProfileState state, BuildContext context) {
    if (state is ProfileSaved) {
      BlocProvider.of<MainBloc>(context).dispatch(ProfileCreated());
      //Navigator.pop(context);
    }

    if (state is ProfileViewLoaded) {
      _nameController.text = state.profile?.name;
      _streetController.text = state.profile?.street;
      _areaController.text = state.profile?.area;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Προσωπικά Στοιχεία')),
      body: new Container(
        child: BlocBuilder<EditProfileEvent, EditProfileState>(
          bloc: _bloc,
          builder: (BuildContext context, EditProfileState state) {
            return Form(
              child: Column(
                children: [
                  _createForm(),
                  Container(
                    child: state is ProfileViewLoading
                        ? CircularProgressIndicator()
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
        padding: new EdgeInsets.all(20.0),
      ),
    );
  }

  Widget _createForm() {
    var form = Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            new Text(
              "Εισάγετε και αποθηκεύστε τα στοιχεία σας",
            ),
            _createTextFormField(
                'name',
                'Ονοματεπώνυμο',
                _nameController,
                TextInputType.text,
                true,
                null,
                _nameFocus,
                _streetFocus,
                null,
                _one),

            _createTextFormField(
                'street',
                'Οδός & Αριθμός',
                _streetController,
                TextInputType.text,
                false,
                null,
                _streetFocus,
                _areaFocus,
                null,
                _two),
            _createTextFormField(
                'area',
                'Περιοχή',
                _areaController,
                TextInputType.text,
                false,
                null,
                _areaFocus,
                null,
                _saveForm,
                _three),
            _createSaveButton()
            //tagging(),
          ],
        ));
    return form;
  }

  Widget _createSaveButton() {
    var sb = new Container(
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
        child: SizedBox(
            width: double.infinity,
            height: 40.0,
            child: new RaisedButton(
                elevation: 5.0,
                // shape: new RoundedRectangleBorder(
                //     borderRadius: new BorderRadius.circular(30.0)),
                color: Helper.getStandardThemeColor(),
                child: new Text('Αποθήκευση',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                onPressed: _saveForm)));
    return sb;
  }

  void _saveForm() {
    if (_formKey.currentState.validate()) {
      widget.profile.name = _nameController.text;
      widget.profile.street = _streetController.text;
      widget.profile.area = _areaController.text;

      _bloc.dispatch(new SaveProfileEvent(widget.profile));
    }
  }

  Widget _createTextFormField(
      String fieldName,
      String labelText,
      //String hintText == null,
      TextEditingController textController,
      TextInputType textInputType,
      bool autoFocus,
      Function(String) isValid,
      FocusNode currentFocusNode,
      FocusNode nextfocusNode,
      Function() onFieldSubmitted,
      GlobalKey key) {
    if (textInputType == null) {
      textInputType = TextInputType.text;
    }

    // String labelText = _translate('editAlert.textFields.$fieldName.labelText');
    String hintText =
        null; // _translate('editAlert.textFields.$fieldName.hintText');
    String validationMessage =
        null; // _translate('editAlert.textFields.$fieldName.validationMessage');

    var formField = new Padding(
        padding: EdgeInsets.fromLTRB(15.0, 7.0, 15.0, 2.0),
        child: TextFormField(
          controller: textController,
          keyboardType: textInputType,
          //autofocus: autoFocus,
          // onTap: _onTap,
          textInputAction: nextfocusNode == null
              ? TextInputAction.done
              : TextInputAction.next,
          focusNode: currentFocusNode,
          onFieldSubmitted: (term) {
            if (onFieldSubmitted == null)
              _fieldFocusChange(context, currentFocusNode, nextfocusNode);
            else
              onFieldSubmitted();
          },
          decoration: new InputDecoration(
              labelText: labelText,
              //hintText: hintText,
              fillColor: Colors.white,
              // suffixIcon: new IconButton(
              //   icon: Icon(Icons.help, color: Helper.getStandardThemeColor()),
              //   onPressed: () {
              //     ShowCaseWidget.of(_showCaseContext).startShowCase([
              //       key,
              //     ]);
              //   },
              // ),
              border: new OutlineInputBorder(
                // borderRadius: new BorderRadius.circular(30.0),
                borderSide: new BorderSide(),
              ),
              helperText: hintText //"os aoen eruidds"
              ),

          validator: (value) {
            if (isValid != null) {
              if (isValid(value) == false) {
                return validationMessage;
              }
            } else {
              if (value.isEmpty) {
                return validationMessage;
              }
            }
          },
        ));
    return formField;
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
