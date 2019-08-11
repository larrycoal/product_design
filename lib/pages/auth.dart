import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped-model/main.dart';

enum AuthMode { Signup, Login }

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPagestate();
  }
}

class _AuthPagestate extends State<AuthPage> {
  final Map<String, dynamic> _formdata = {
    'email': null,
    'password': null,
    'acceptterms': false
  };

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _passwordtext = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  Widget _buildemailtextfield() {
    return Center(
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Email', filled: true, fillColor: Colors.white),
        keyboardType: TextInputType.emailAddress,
        validator: (String value) {
          if (value.isEmpty || !RegExp(r'test@test.com').hasMatch(value)) {
            
            return 'enter a valid email';
          }
        },
        onSaved: (String value) {
          _formdata['email'] = value;
        },
      ),
    );
  }

  BoxDecoration _buildbackgroundimage() {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop)));
  }

  Widget _buildpasswordtextfield() {
    return TextFormField(
      controller: _passwordtext,
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (value.length < 5 || value.isEmpty) {
          return 'enter a valid password';
        }
      },
      onSaved: (String value) {
        _formdata['password'] = value;
      },
    );
  }

  Widget _buildconfirmpasswordtextfield() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (_passwordtext.text != value) {
          return 'password does not match';
        }
      },
    );
  }

  Widget _buildswitchlisttile() {
    return SwitchListTile(
      value: _formdata['acceptterms'],
      onChanged: (bool value) {
        setState(() {
          _formdata['acceptterms'] = value;
        });
      },
      title: Text('Accept terms'),
    );
  }

  void _submitform(Function authenticate) async {
    Map<String, dynamic> succesinformation;
    _formkey.currentState.save();

    succesinformation = await authenticate(
        _formdata['email'], _formdata['password'], _authMode);
    if (!_formkey.currentState.validate() || !_formdata['acceptterms']) {
      return;
    }

    if (succesinformation['success']) {
      Navigator.pushReplacementNamed(context, '/Ppage');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(succesinformation['message']),
              title: Text('An Error Occured'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OKAY'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double devicewidth = MediaQuery.of(context).size.width;
    final double targetwidth = devicewidth > 550.0 ? 500.0 : devicewidth * 0.95;
    return Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Container(
          decoration: _buildbackgroundimage(),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: targetwidth,
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      _buildemailtextfield(),
                      SizedBox(height: 10.0),
                      _buildpasswordtextfield(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _authMode == AuthMode.Signup
                          ? _buildconfirmpasswordtextfield()
                          : Container(),
                      _buildswitchlisttile(),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                        child: Text(
                            'switch to ${_authMode == AuthMode.Login ? 'signup' : 'Login'}'),
                        onPressed: () {
                          setState(() {
                            _authMode = _authMode == AuthMode.Login
                                ? AuthMode.Signup
                                : AuthMode.Login;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ScopedModelDescendant<MainModel>(
                        builder: (BuildContext context, Widget child,
                            MainModel model) {
                          return model.isloading
                              ? CircularProgressIndicator()
                              : RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  child: _authMode == AuthMode.Login
                                      ? Text('Login')
                                      : Text('Signup'),
                                  onPressed: () =>
                                      _submitform(model.authenticate));
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
