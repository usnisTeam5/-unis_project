import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home:LoginPage(),
    ),
  );
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                // Image.asset('assets/diamond.png'),
                Image.network(
                    'https://img.icons8.com/plasticine/2x/diamond.png'),
                SizedBox(height: 16.0),
                Text('SHRINE'),
              ],
            ),
            SizedBox(height: 120.0),

            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'UserName',
              ),
            ),

            SizedBox(
              height: 18,
            ),

            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'PassWord',
              ),
              obscureText: true,
            ),
            SizedBox(
              height: 10,
            ),
            ButtonBar(
              children: [
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                RaisedButton(
                  child: Text('Next'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )


          ],
        ),
      ),
    );
  }
}