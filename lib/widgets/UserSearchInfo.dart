import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:cosplay_app/widgets/native_shapes/CircularBox.dart';

// COSPLAYER
class UserSearchInfo extends StatelessWidget {
  final ImageProvider backgroundImage;
  final String name;
  final String cosplayName;
  final String seriesName;
  final String cost;
  final int friendliness;

  UserSearchInfo(
      {this.backgroundImage,
      this.name,
      this.seriesName,
      this.cosplayName,
      this.friendliness,
      this.cost});

  Text renderTextIfNoImage() {
    if (backgroundImage == null) {
      return Text("?");
    } else {
      return Text("");
    }
  }

  ImageProvider renderImage() {
    if (backgroundImage == null) return AssetImage("assets/noImage.png");
    return backgroundImage;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey[100],
      onTap: () {
        print("Tapped search item");
      },
      child: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 0.0, bottom: 8.0, top: 8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: ImageContainer(
                  borderWidth: 2.5,
                  rarityBorderColor: kRarityBorders[0],
                  borderRadius: 500.0,
                  image: renderImage(),
                  width: 60.0,
                  height: 60.0),
            ),
//            CircleAvatar(
//              minRadius: 30.0,
//              backgroundColor: Colors.blueAccent,
//              child: renderTextIfNoImage(),
//              backgroundImage: backgroundImage,
//            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircularBox(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6.5),
                    hasShadow: false,
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    cosplayName,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[50]),
                  ),
                  SizedBox(height: 1.5),
                  Text(
                    seriesName,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[50]),
                  ),
                ],
              ),
            ),
            SizedBox(width: 25.0),
            Container(
              width: 85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.sentiment_very_satisfied,
                          color: Colors.grey[50]),
                      SizedBox(width: 5.0),
                      Text(friendliness.toString()),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    "\$42/hr",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Photographer
class PhotographerSearchInfo extends StatelessWidget {
  final ImageProvider backgroundImage;
  final String name;
  final int yearsExperience;
  final int monthsExperience;
  final String cost;
  final int friendliness;

  PhotographerSearchInfo(
      {this.backgroundImage,
      this.name,
      this.yearsExperience = 0,
      this.monthsExperience = 0,
      this.cost = "Free",
      this.friendliness});

  Text renderTextIfNoImage() {
    if (backgroundImage == null) {
      return Text("?");
    } else {
      return Text("");
    }
  }

  NetworkImage renderImage() {
    if (backgroundImage == null)
      return NetworkImage(
          "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Icon-round-Question_mark.svg/1024px-Icon-round-Question_mark.svg.png");
    return backgroundImage;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey[100],
      onTap: () {
        print("Tapped search item");
      },
      child: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 0.0, bottom: 8.0, top: 8.0),
        child: Row(
          children: <Widget>[
            // Image container
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: ImageContainer(
                  borderWidth: 2.5,
                  rarityBorderColor: kRarityBorders[0],
                  borderRadius: 500.0,
                  image: renderImage(),
                  width: 60.0,
                  height: 60.0),
            ),
            SizedBox(width: 20.0),
            // Middle information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircularBox(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6.5),
                    hasShadow: false,
                    child: Text(name,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        )),
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    "${yearsExperience.toString()} year(s) and ${monthsExperience.toString()} month(s)",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[50]),
                  ),
                  SizedBox(height: 1.5),
                  Text(
                    cost,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[50]),
                  ),
                ],
              ),
            ),
            SizedBox(width: 25.0),
            // Friendliness
            Container(
              width: 85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.sentiment_very_satisfied,
                          color: Colors.grey[50]),
                      SizedBox(width: 5.0),
                      Text(friendliness.toString()),
                    ],
                  ),
                  SizedBox(height: 6),
                  CircularBox(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    hasShadow: false,
                    child: Text(
                      "\$42/hr",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
