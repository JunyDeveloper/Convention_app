import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cosplay_app/animations/AnimationWrapper.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';
import 'package:cosplay_app/widgets/SuperButton.dart';

class QuestionWidget extends StatefulWidget {
  final AnimationController animationController;
  final AnimationDirection animationDirection;
  final bool animationIsOut;
  final bool showPicker;
  final bool shouldRenderSuccessButton;
  final int currentYearPicker;
  final int currentMonthPicker;
  final List<TextSpan> questionText;
  final Function onCheckTap;
  final Function onYearChange;
  final Function onMonthChange;

  QuestionWidget(
      {@required this.animationController,
      @required this.questionText,
      @required this.onCheckTap,
      @required this.onYearChange,
      @required this.onMonthChange,
      this.shouldRenderSuccessButton = false,
      this.animationDirection = AnimationDirection.RIGHT,
      this.animationIsOut = false,
      this.showPicker = false,
      this.currentMonthPicker = 1,
      this.currentYearPicker = 1});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  AnimationDirection animationDirection;
  int currentYearPicker;
  int currentMonthPicker;
  bool animationIsOut;
  bool canTap; // Buttons will only register events ONCE (no multiple clicks)

  @override
  void initState() {
    super.initState();
    animationIsOut = widget.animationIsOut;
    animationDirection = widget.animationDirection;
    currentYearPicker = widget.currentYearPicker;
    currentMonthPicker = widget.currentMonthPicker;
    canTap = true;
  }

  Widget createQuestionWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AnimationWrapper(
          start: 0.0,
          controller: widget.animationController,
          direction: animationDirection,
          isOut: animationIsOut,
          child: Padding(
            padding: const EdgeInsets.only(left: 22.0, right: 22.0),
            child: Container(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                  children: widget.questionText,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: kBoxGap + 50.0),
        renderButtons(),
        SizedBox(height: kBoxGap + 50.0),
        SizedBox(height: 20.0),
        AnimationWrapper(
          start: 0.5,
          controller: widget.animationController,
          direction: animationDirection,
          isOut: animationIsOut,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  _renderPickerText("Select year(s)"),
                  SizedBox(height: kBoxGap),
                  _renderPicker(currentYearPicker, (year) {
                    setState(() {
                      currentYearPicker = year;
                      widget.onYearChange(year);
                    });
                  }),
                ],
              ),
              SizedBox(width: kBoxGap),
              Column(
                children: <Widget>[
                  _renderPickerText("Select month(s)"),
                  SizedBox(height: kBoxGap),
                  _renderPicker(currentMonthPicker, (month) {
                    setState(() {
                      currentMonthPicker = month;
                      widget.onMonthChange(month);
                    });
                  }),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  // TODO: On tap for super button should take us to main screen
  Widget renderButtons() {
    // Success screen will render a different button
    if (widget.shouldRenderSuccessButton) {
      return AnimationWrapper(
        start: 0.3,
        controller: widget.animationController,
        direction: animationDirection,
        isOut: animationIsOut,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: SuperButton(
            text: "Awesome!",
            color: Colors.pinkAccent,
            onPress: () {
              Navigator.pushNamed(context, "/main");
            },
          ),
        ),
      );
    }

    return AnimationWrapper(
      start: 0.3,
      controller: widget.animationController,
      direction: animationDirection,
      isOut: animationIsOut,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RoundButton(
            icon: Icons.clear,
            onTap: () {
              if (canTap) {
                canTap = false;
              }
            },
          ),
          SizedBox(width: kBoxGap + 40.0),
          RoundButton(
            icon: Icons.check,
            onTap: () {
              if (canTap) {
                changeAnimation(); // Animate this question out
                widget.onCheckTap();
                canTap = false;
              }
            },
          ),
        ],
      ),
    );
  }

  // Animation will be animating out
  void changeAnimation() {
    setState(() {
      animationDirection = AnimationDirection.LEFT;
      animationIsOut = true;
      // Since we reset the animation values, we need to restart the animation controller
      widget.animationController.reset();
      widget.animationController.forward();
    });
  }

  Widget _renderPicker(int initialValue, Function callback) {
    // Only render picker on these indexes
    if (widget.showPicker) {
      return NumberPicker.integer(
        listViewWidth: 150.0,
        itemExtent: 60.0,
        initialValue: initialValue,
        minValue: 0,
        maxValue: 100,
        onChanged: (newValue) {
          callback(newValue);
        },
      );
    } else {
      return Container(); // Return an empty container since number picker shouldn't be displayed
    }
  }

  Widget _renderPickerText(String title) {
    if (widget.showPicker) {
      return Text(
        title,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return createQuestionWidget();
  }
}
