import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///
/// login stachuf16@gmail.com
/// haslo stachu14d
///

class LoginPage extends StatefulWidget {
  LoginPage({
    Key? key,
  }) : super(key: key);

  final emailcontroler = TextEditingController();
  final passwordcontroler = TextEditingController();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FocusNode myFocusNode = FocusNode(); // umozliwia zmiane koloru labela

  var errorMessage = ''; // error
  var isCreatingAccount = false; // Założenie że użytkownik ma już konto
  var passwordVisible = false; // zmienna żeby pokazywać/ukrywać hasło

  @override
  Widget build(BuildContext context) {
    ///
    ///
    ///
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // LOGO APLIKACJI

          Text(
            'SMART HOME',
            style: GoogleFonts.lobster(fontSize: 40),
          ),

          ///
          /// CONTAINER TEXTFIELD 1 + TEXTFIELD 2
          ///
          Container(
            width: 300,
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // ZALOGUJ SIĘ / ZAREJESTRUJ SIĘ - NAPIS

                Text(isCreatingAccount == true ? 'Rejestracja' : 'Logowanie'),
                const SizedBox(
                  height: 20,
                ),

                ///
                ///
                /// TEXTFIELD DO PODANIA E-MAIL
                ///
                TextFormField(
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(255, 0, 0, 0),
                    focusColor: const Color.fromARGB(255, 0, 0, 0),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    label: const Text('E-mail'),
                    labelStyle: TextStyle(
                        color: myFocusNode.hasFocus
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  controller: widget.emailcontroler,
                  style: GoogleFonts.lobster(
                      fontSize: 15,
                      textStyle:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                ),
                const SizedBox(height: 10),

                ///
                ///
                ///
                /// TEXTFIELD DO PODANIA HASŁA
                ///
                TextFormField(
                  obscureText:
                      !passwordVisible, //This will obscure text dynamically,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: (() {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      }),
                    ),
                    fillColor: const Color.fromARGB(255, 0, 0, 0),
                    focusColor: const Color.fromARGB(255, 0, 0, 0),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    label: const Text('Password'),
                    labelStyle: TextStyle(
                        color: myFocusNode.hasFocus
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  controller: widget.passwordcontroler,
                  style: GoogleFonts.lobster(
                      fontSize: 15,
                      textStyle:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(errorMessage),
              ],
            ),
          ),

          // PRZYCISK ZALOGUJ / ZAREJESTRUJ SIE
          ElevatedButton(
              onPressed: () async {
                if (isCreatingAccount == true) {
                  //REJESTRACJA
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: widget.emailcontroler.text,
                        password: widget.passwordcontroler.text);
                  } catch (error) {
                    setState(() {
                      errorMessage = error.toString();
                    });
                  }
                } else {
                  // LOGOWANIE

                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: widget.emailcontroler.text,
                        password: widget.passwordcontroler.text);
                  } catch (error) {
                    setState(() {
                      errorMessage = error.toString();
                    });
                  }
                }
              },
              child: Text(isCreatingAccount == true
                  ? 'Zarejestruj się'
                  : 'Zaloguj się')),
          const SizedBox(
            height: 10,
          ),

          // PRZYCISK Nie masz jeszcze konta? Zarejestruj się! / Masz już konto? Zaloguj się!

          if (isCreatingAccount == true) ...{
            TextButton(
                onPressed: () {
                  setState(() {
                    isCreatingAccount = false;
                  });
                },
                child: const Text('Masz już konto? Zaloguj się'))
          } else
            TextButton(
                onPressed: () {
                  setState(() {
                    isCreatingAccount = true;
                  });
                },
                child: const Text('Utwórz konto'))
        ],
      ),
    ));
  }
}
