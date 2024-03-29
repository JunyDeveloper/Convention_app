import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/NavButton.dart';

class TopNavBarWithLines extends StatefulWidget {
  final BuildContext context;
  final Function onCosplayersTap;
  final Function onPhotographersTap;
  final int index;

  TopNavBarWithLines(
      {@required this.context,
      @required this.onCosplayersTap,
      @required this.onPhotographersTap,
      this.index});

  @override
  _TopNavBarWithLinesState createState() => _TopNavBarWithLinesState();
}

class _TopNavBarWithLinesState extends State<TopNavBarWithLines>
    with SingleTickerProviderStateMixin {
  double navBarHeight = 80.0;
  double gap = 10.0;
  double lineWidth = 100.0;
  double lineThickness = 1.5;
  double nextLinePositionX = 500.0;
  double currentLinePositionX = 500.0;
  int index = 0;
  int numberOfNavButtons = 2;
  Animation lineAnim;
  AnimationController lineAnimController;

  @override
  void initState() {
    super.initState();
    index = 0;
    nextLinePositionX = calculateNextLinePosition(widget.context);
    lineAnimController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    lineAnim = getLineAnimation(currentLinePositionX, nextLinePositionX);
    lineAnimController.forward();
  }

  getLineAnimation(double start, double end) {
    return Tween(begin: start, end: end).animate(CurvedAnimation(
      parent: lineAnimController,
      curve: Interval(0.0, 1.0, curve: ElasticOutCurve(0.7)),
    ));
  }

  double calculateNextLinePosition(BuildContext context) {
    // Get the width of nav items
    double calculateWidthOfEachNavButton() {
      return (MediaQuery.of(context).size.width / numberOfNavButtons);
    }

    // Get the center of the nav items
    double calculateCenterOfEachNavButton() {
      return calculateWidthOfEachNavButton() / 2;
    }

    // Return the next position of the line
    return calculateCenterOfEachNavButton() +
        (index * calculateWidthOfEachNavButton());
  }

  @override
  void didUpdateWidget(TopNavBarWithLines oldWidget) {
    super.didUpdateWidget(oldWidget);
    // user didnt click on button to nav, they used page swipe
    if (oldWidget.index != widget.index) {
      setState(() {
        index = widget.index;
      });
      currentLinePositionX = nextLinePositionX;
      nextLinePositionX = calculateNextLinePosition(context);
      lineAnim = getLineAnimation(currentLinePositionX, nextLinePositionX);
      lineAnimController.reset();
      lineAnimController.forward();
    }
  }

  @override
  void dispose() {
    lineAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: navBarHeight,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  spreadRadius: 5.0,
                  blurRadius: 5.0,
                  color: Colors.black12,
                  offset: Offset(0.0, -5.0),
                ),
              ],
            ),
            child: Container(
              color: Colors.cyan[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  NavButton(
                      title: "Cosplayers",
                      onTap: () {
                        print("Cosplayers");
                        widget.onCosplayersTap();
                        setState(() {
                          index = 0;
                          currentLinePositionX = nextLinePositionX;
                          nextLinePositionX =
                              calculateNextLinePosition(context);
                          lineAnim = getLineAnimation(
                              currentLinePositionX, nextLinePositionX);
                          lineAnimController.reset();
                          lineAnimController.forward();
                        });
                      }),
                  NavButton(
                      title: "Photographers",
                      onTap: () {
                        print("Photographers");
                        widget.onPhotographersTap();
                        setState(() {
                          index = 1;
                          currentLinePositionX = nextLinePositionX;
                          nextLinePositionX =
                              calculateNextLinePosition(context);
                          lineAnim = getLineAnimation(
                              currentLinePositionX, nextLinePositionX);
                          lineAnimController.reset();
                          lineAnimController.forward();
                        });
                      }),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
              animation: lineAnim,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.translationValues(
                      lineAnim.value - (lineWidth / numberOfNavButtons),
                      0.0,
                      0.0),
                  child: Container(
                    width: lineWidth,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: lineThickness, color: Colors.pink),
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
