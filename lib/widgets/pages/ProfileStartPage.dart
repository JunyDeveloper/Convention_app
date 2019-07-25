import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';

class ProfileStartPage extends StatefulWidget {
  @override
  _ProfileStartPageState createState() => _ProfileStartPageState();
}

class _ProfileStartPageState extends State<ProfileStartPage> {
  int _current;
  bool profileCollapsed =
      false; // This collapses when the down arrow is clicked

  final List<Widget> userImages = [
    ImageContainer(path: "assets/1.jpg", size: double.infinity),
    ImageContainer(path: "assets/2.jpg", size: double.infinity),
    ImageContainer(path: "assets/3.jpg", size: double.infinity),
  ];

  double calculateCarouselSliderHeight(double screenHeight) {
    if (profileCollapsed) {
      return screenHeight / 2;
    } else {
      return screenHeight - kBottomNavigationBarHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        CarouselSlider(
          height: calculateCarouselSliderHeight(screenHeight),
          viewportFraction: 1.0,
          items: userImages,
          autoPlay: false,
          //aspectRatio: 1.0,
          onPageChanged: (index) {
            setState(() {
              _current = index;
            });
          },
        ),
        // Should'nt use icons need to draw circles, checkout how that carousel guy did it when site comes back online
        Opacity(
          opacity: profileCollapsed ? 0 : 1,
          child: Row(
            children: <Widget>[
              Icon(FontAwesomeIcons.circle),
              Icon(
                FontAwesomeIcons.solidCircle,
                color: Colors.white,
              ),
              Icon(FontAwesomeIcons.circle),
              Icon(FontAwesomeIcons.circle),
            ],
          ),
        ),
        Opacity(
          opacity: profileCollapsed ? 0 : 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconText(
                  icon: Icons.face,
                  text: Text(
                    "Jenny Smith",
                    style: kProfileOverlayNameStyle,
                  ),
                ),
                SizedBox(height: 10.0),
                IconText(
                  icon: Icons.favorite,
                  text: Text(
                    "1352",
                    style: kProfileOverlayTextStyle,
                  ),
                ),
                SizedBox(height: 10.0),
                IconText(
                  icon: Icons.star,
                  text: Text(
                    "5242",
                    style: kProfileOverlayTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

final Color kTextStrokeColor = Colors.black;
final double kTextStrokeBlur = 1.0;
final List<Shadow> kTextStrokeOutlines = [
  Shadow(
// bottomLeft
      blurRadius: kTextStrokeBlur,
      offset: Offset(-1.5, -1.5),
      color: kTextStrokeColor),
  Shadow(
// bottomRight
      blurRadius: kTextStrokeBlur,
      offset: Offset(1.5, -1.5),
      color: kTextStrokeColor),
  Shadow(
// topRight
      blurRadius: kTextStrokeBlur,
      offset: Offset(1.5, 1.5),
      color: kTextStrokeColor),
  Shadow(
// topLeftblur
      blurRadius: kTextStrokeBlur,
      offset: Offset(-1.5, 1.5),
      color: kTextStrokeColor),
];

final TextStyle kProfileOverlayNameStyle = TextStyle(
  fontSize: 30.0,
  color: Colors.white,
  fontWeight: FontWeight.w700,
  shadows: kTextStrokeOutlines,
);

final TextStyle kProfileOverlayTextStyle = TextStyle(
    fontSize: 25.0,
    color: Colors.white,
    fontWeight: FontWeight.w400,
    shadows: kTextStrokeOutlines);

class IconText extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Text text;

  IconText(
      {@required this.icon,
      this.iconSize = 30.0,
      @required this.text,
      this.iconColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned(
              left: 0.2,
              top: 0.2,
              child: Icon(icon, color: Colors.black87, size: iconSize + 2.0),
            ),
            Icon(icon, color: iconColor, size: iconSize),
          ],
        ),
        SizedBox(width: 10.0),
        text
      ],
    );
  }
}