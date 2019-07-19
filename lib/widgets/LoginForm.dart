import 'package:flutter/material.dart';
import 'HyperButton.dart';
import 'IconFormField.dart';
import 'SuperButton.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:flutter/animation.dart';
import "package:cosplay_app/AnimateIn.dart";
import "package:cosplay_app/AnimationBounceIn.dart";

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  Animation animationLeftInEmail;
  Animation animationLeftInPassword;
  Animation animationLeftInRememberMe;
  Animation animationForgotPassword;
  Animation animationRememberMe;
  Animation animationLogIn;
  Animation animationOpacity;
  AnimationController animationController;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _bRememberMe = true;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    animationOpacity = createOpacityAnimationAtStart(0, Curves.linearToEaseOut);
    animationLeftInEmail =
        createTransformAnimationAtStart(0.0, Curves.easeInOutCubic);
    animationLeftInPassword =
        createTransformAnimationAtStart(0.1, Curves.easeInOutCubic);
    animationLeftInRememberMe =
        createTransformAnimationAtStart(0.3, Curves.easeInOutCubic);
    animationForgotPassword =
        createTransformAnimationAtStart(0.3, Curves.easeInOutCubic);
    animationRememberMe =
        createTransformAnimationAtStart(0.4, Curves.easeInOutCubic);
    animationLogIn = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: animationController,
          curve: Interval(0.6, 1.0, curve: Curves.easeInOutCubic)),
    );

    animationController.forward();
  }

  // Create the animation with a given start point in the animation (ex: start = 0.5 is 50%)
  Animation createTransformAnimationAtStart(double start, Curve curve) {
    return Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(start, 1.0, curve: curve),
    ));
  }

  Animation createOpacityAnimationAtStart(double start, Curve curve) {
    return Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(start, 1.0, curve: curve),
    ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: false,
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          AnimateIn(
            animationTransform: animationLeftInEmail,
            animationOpacity: animationOpacity,
            child: IconFormField(
              hintText: "Email",
              invalidText: "Invalid Email",
              icon: Icons.email,
              controller: _emailController,
              textInputType: TextInputType.emailAddress,
              validator: (value) {
                return validateEmail(value);
              },
            ),
          ),
          SizedBox(height: kBoxGap),
          AnimateIn(
            animationTransform: animationLeftInPassword,
            animationOpacity: animationOpacity,
            child: IconFormField(
              hintText: "Password",
              invalidText: "Invalid Password",
              icon: Icons.lock,
              obscureText: true,
              controller: _passwordController,
              textInputType: TextInputType.text,
              validator: (value) {
                validatePassword(value);
              },
            ),
          ),
          SizedBox(height: kBoxGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AnimateIn(
                animationTransform: animationLeftInRememberMe,
                animationOpacity: animationOpacity,
                child: Row(
                  children: <Widget>[
                    Switch(
                      activeColor: Theme.of(context).primaryColor,
                      value: _bRememberMe,
                      onChanged: (value) {
                        setState(() {
                          _bRememberMe = !_bRememberMe;
                        });
                      },
                    ),
                    Text("Remember Me", style: kTextStyleNotImportant()),
                  ],
                ),
              ),
              AnimateIn(
                animationTransform: animationRememberMe,
                animationOpacity: animationOpacity,
                direction: AnimationDirection.FROM_RIGHT,
                child: HyperButton(text: "Forgot Password?"),
              ),
            ],
          ),
          SizedBox(height: kBoxGap),
          AnimationBounceIn(
            durationMilliseconds: 0,
            durationSeconds: 3,
            delayMilliseconds: 500,
            child: SuperButton(
              text: "LOG IN",
              validated: () {
                return _formKey.currentState.validate();
              },
              onPress: () {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Processing Data for ${_emailController.text} of ${_passwordController.text}'),
                  ),
                );
                Navigator.pushNamed(context, '/question');
              },
            ),
          ),
          SizedBox(height: kBoxGap + 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("New user? ", style: kTextStyleNotImportant()),
              HyperButton(text: "Sign Up"),
            ],
          ),
        ],
      ),
    );
  }
}

String validatePassword(String value) {
  if (value.isEmpty) {
    return "Please enter your password";
  } else if (value.length < 6) {
    return "Password must be greater than 5 characters";
  } else {
    return null;
  }
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter a valid email';
  else
    return null;
}
