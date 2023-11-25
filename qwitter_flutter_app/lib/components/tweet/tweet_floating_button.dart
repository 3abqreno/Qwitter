import 'package:flutter/material.dart';

class TweetFloatingButton extends StatelessWidget {
  final bool isVisible;
  final Function closeFloatingButton;
  final Function toggleVisibility;
  const TweetFloatingButton({Key? key, required this.isVisible, required this.closeFloatingButton, required this.toggleVisibility})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
            children: [
              isVisible
                  ? GestureDetector(
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.8),
                      ),
                      onTap: () => closeFloatingButton(),
                    )
                  : Container(),
              Positioned(
                bottom: 210,
                right: 30,
                child: Row(
                  children: [
                    AnimatedScale(
                      scale: isVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 200),
                      child: Text("Spaces",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 18)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    AnimatedScale(
                      scale: isVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 200),
                      child: FilledButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(5)),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              CircleBorder()), // Set the shape to CircleBorder()
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                        ),
                        child: Icon(
                          Icons.mic,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          print("Floating button pressed");
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 155,
                right: 30,
                child: Row(
                  children: [
                    AnimatedScale(
                      scale: isVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 200),
                      child: Text("GIF",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 18)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    AnimatedScale(
                      scale: isVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 200),
                      child: FilledButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(5)),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              CircleBorder()), // Set the shape to CircleBorder()
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                        ),
                        child: Icon(
                          Icons.gif_box_outlined,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          print("Floating button pressed");
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 100,
                right: 30,
                child: Row(
                  children: [
                    AnimatedScale(
                      scale: isVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 200),
                      child: Text("Photos",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 18)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    AnimatedScale(
                      scale: isVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 200),
                      child: FilledButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(5)),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              CircleBorder()), // Set the shape to CircleBorder()
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                        ),
                        child: Icon(
                          Icons.image_outlined,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          print("Floating button pressed");
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 30,
                right: 30,
                child: Row(
                  children: [
                    AnimatedScale(
                      scale: isVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 200),
                      child: Text("Post",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 18)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FilledButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(20),
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            CircleBorder()), // Set the shape to CircleBorder()
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blue),
                      ),
                      child: AnimatedRotation(
                        duration: Duration(milliseconds: 300),
                        turns: isVisible ? 1 : 0,
                        child: isVisible
                            ? Icon(
                                Icons.post_add) // Icon when button is visible
                            : Icon(Icons.add),
                      ),
                      onPressed: () {
                        if (isVisible) {
                          // Make post
                        } else {
                          // open buttons list
                          toggleVisibility();
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          );
  }
}