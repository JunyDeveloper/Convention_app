import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cosplay_app/widgets/notification/NotificationDot.dart';

class ProfileStartPage extends StatefulWidget {
  @override
  _ProfileStartPageState createState() => _ProfileStartPageState();
}

class _ProfileStartPageState extends State<ProfileStartPage> {
  int _current;
  bool profileCollapsed =
      false; // This collapses when the down arrow is clicked

  final List<Widget> userImages = [
    ImageContainer(
      image: NetworkImage(
          "https://c.pxhere.com/photos/0c/ea/china_girls_game_anime_cute_girl_japanese_costume-187567.jpg!d"),
      height: double.infinity,
      width: double.infinity,
    ),
    ImageContainer(
        image: NetworkImage(
            "https://c.pxhere.com/photos/eb/33/china_girls_game_anime_cute_girl_japanese_costume-187564.jpg!d"),
        height: double.infinity,
        width: double.infinity),
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
        // Carousel
        Swiper(
          itemBuilder: (BuildContext context, int index) {
            return userImages[index];
          },
          itemCount: userImages.length,
          pagination: SwiperPagination(
              alignment: Alignment.topCenter, builder: SwiperPagination.dots),
          control: SwiperControl(
            color: Colors.white,
          ),
        ),
        // User information bottom left
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
                    "Shikano Mel",
                    style: kProfileOverlayNameStyle,
                  ),
                ),
                SizedBox(height: 10.0),
                IconText(
                  icon: Icons.sentiment_very_satisfied,
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
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 20.0),
            child: NotificationDot(innerColor: Colors.pinkAccent),
          ),
        ),
      ],
    );
  }
}

final Color kTextStrokeColor = Colors.black12;
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
              child: Icon(icon, color: Colors.black12, size: iconSize + 2.0),
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
