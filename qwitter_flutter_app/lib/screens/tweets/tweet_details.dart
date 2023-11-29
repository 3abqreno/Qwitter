import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/Components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_avatar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_body.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_header.dart';
import 'package:qwitter_flutter_app/components/tweet_card.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweet_media_viewer_screen.dart';
import 'package:qwitter_flutter_app/services/tweets_services.dart';
import 'package:qwitter_flutter_app/utils/date_humanizer.dart';

class TweetDetailsScreen extends ConsumerStatefulWidget {
  final Tweet tweet;
  final pushMediaViewerFunc;

  const TweetDetailsScreen(
      {super.key, required this.tweet, this.pushMediaViewerFunc});

  @override
  ConsumerState<TweetDetailsScreen> createState() => _TweetDetailsScreenState();
}

class _TweetDetailsScreenState extends ConsumerState<TweetDetailsScreen> {
  TextEditingController textEditingController = TextEditingController();
  final focusNode = FocusNode();

  bool isImage(String filePath) {
    final imageExtensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp'
    ]; // Add more image formats if needed
    final fileExtension = filePath.split('.').last.toLowerCase();
    return imageExtensions.contains(fileExtension);
  }

  bool isVideo(String filePath) {
    final videoExtensions = [
      'mp4',
      'mov',
      'avi',
      'mkv',
      'wmv'
    ]; // Add more video formats if needed
    final fileExtension = filePath.split('.').last.toLowerCase();
    return videoExtensions.contains(fileExtension);
  }

  void pushMediaViewer(BuildContext context, tweetImg, uniqueid, Tweet tweet) {
    Navigator.push(
      context,
      isImage(tweetImg)
          ? MaterialPageRoute(builder: (context) {
              return TweetMediaViewerScreen(
                imageUrl: tweetImg,
                tag: uniqueid,
                isImage: isImage(tweetImg),
                tweet: tweet,
              );
            })
          : PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  TweetMediaViewerScreen(
                imageUrl: tweetImg,
                tag: uniqueid,
                isImage: isImage(tweetImg),
                tweet: tweet,
              ),
              transitionDuration:
                  Duration(milliseconds: 500), // Set the duration here
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                var curvedAnimation =
                    CurvedAnimation(parent: animation, curve: curve);
                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
    ).then((t) {
      setState(() {
        ref.read(tweet.provider.notifier).setTweet(t as Tweet);
      });
    });
  }

  @override
  void _openRepostModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20), bottom: Radius.zero)),
          height: 180, // Set the height of the bottom sheet
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          TweetsServices.makeRepost(ref, widget.tweet);
                        });
                      },
                      icon: Icon(
                        Icons.repeat,
                        size: 25,
                        color: Colors.white,
                      ),
                      label: Text(
                        widget.tweet.isRetweeted! ? "Undo Repost" : "Repost",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          TweetsServices.makeRepost(ref, widget.tweet);
                        });
                      },
                      icon: Icon(
                        Icons.mode_edit_outlined,
                        size: 25,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Quote",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )
                    // Add more menu items as needed
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    final tweetProvider = ref.watch(widget.tweet.provider);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, tweetProvider);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            "Post",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: Theme.of(context).iconTheme,
          elevation: 1,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: Stack(
            children: [
              ListView.builder(
                itemBuilder: (ctx, index) {
                  return index == 0
                      ? Column(
                          children: [
                            Container(
                              // alignment: Alignment.topLeft,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      TweetAvatar(
                                          avatar: widget.tweet.user!
                                              .profilePicture!.path),
                                      Expanded(
                                        child: TweetHeader.stretched(
                                          tweetUserHandle: "@" +
                                              widget.tweet.user!.username!,
                                          tweetUserName:
                                              widget.tweet.user!.fullName!,
                                          tweetUserVerified: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TweetBody(
                                    tweet: widget.tweet,
                                    pushMediaViewerFunc: pushMediaViewer,
                                    stretched: true,
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                                    child: Row(
                                      children: [
                                        Text(
                                          DateHelper.extractTime(
                                              tweetProvider.createdAt!),
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          width: 3,
                                          height: 3,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          DateHelper.extractFullDate(
                                              tweetProvider.createdAt!),
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          width: 3,
                                          height: 3,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "45K",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Views",
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[900]!, width: 1),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey[900]!,
                                                  width: 1),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 10 +
                                                    10 *
                                                        (tweetProvider
                                                                .retweetsCount
                                                                .toString()
                                                                .length)
                                                            .toDouble(),
                                                child: TextButton(
                                                  onPressed: () {},
                                                  child: Text(
                                                    tweetProvider.retweetsCount
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .secondaryHeaderColor),
                                                  ),
                                                  style: ButtonStyle(
                                                    alignment: Alignment.center,
                                                    // overlayColor: MaterialStateProperty.all(Colors.transparent),
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(EdgeInsets
                                                                .zero),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Reposts",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: 10 +
                                                    10 *
                                                        ("41".length)
                                                            .toDouble(),
                                                child: TextButton(
                                                  onPressed: () {},
                                                  child: Text(
                                                    "41",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .secondaryHeaderColor),
                                                  ),
                                                  style: ButtonStyle(
                                                    alignment: Alignment.center,
                                                    // overlayColor: MaterialStateProperty.all(Colors.transparent),
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(EdgeInsets
                                                                .zero),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Quotes",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: 10 +
                                                    10 *
                                                        (tweetProvider
                                                                .likesCount
                                                                .toString()
                                                                .length)
                                                            .toDouble(),
                                                child: TextButton(
                                                  onPressed: () {},
                                                  child: Text(
                                                    tweetProvider.likesCount
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .secondaryHeaderColor),
                                                  ),
                                                  style: ButtonStyle(
                                                    alignment: Alignment.center,
                                                    // overlayColor: MaterialStateProperty.all(Colors.transparent),
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(EdgeInsets
                                                                .zero),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Likes",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey[900]!,
                                                  width: 1),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 10 +
                                                    10 *
                                                        ("41".length)
                                                            .toDouble(),
                                                child: TextButton(
                                                  onPressed: () {},
                                                  child: Text(
                                                    "41",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .secondaryHeaderColor),
                                                  ),
                                                  style: ButtonStyle(
                                                    alignment: Alignment.center,
                                                    // overlayColor: MaterialStateProperty.all(Colors.transparent),
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(EdgeInsets
                                                                .zero),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Bookmarks",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    color: Colors.grey[900]!,
                                                    width: 1)),
                                          ),
                                          child: Row(children: [
                                            Expanded(
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.chat_bubble_outline,
                                                  color: Colors.grey[600],
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  FocusScope.of(context)
                                                      .requestFocus(focusNode);
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.repeat_outlined,
                                                  color:
                                                      tweetProvider.isRetweeted!
                                                          ? Colors.green
                                                          : Colors.grey[600],
                                                  size: 22,
                                                ),
                                                onPressed: _openRepostModal,
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                icon: Icon(
                                                  tweetProvider.isLiked!
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: tweetProvider.isLiked!
                                                      ? Colors.pink
                                                      : Colors.grey[600],
                                                  size: 22,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    TweetsServices.makeLike(
                                                        ref, widget.tweet);
                                                  });
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.bookmark_outline,
                                                  color: Colors.grey[600],
                                                  size: 22,
                                                ),
                                                onPressed: () {},
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.share_outlined,
                                                  color: Colors.grey[600],
                                                  size: 22,
                                                ),
                                                onPressed: () {},
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : TweetCard(
                          tweet: Tweet(
                              createdAt: '2021-09-01T00:00:00.000Z',
                              id: "1 + ${index.toString()}",
                              hashtags: ["a", "b"],
                              isBookmarked: true,
                              isLiked: true,
                              isQuoted: false,
                              isRetweeted: true,
                              likesCount: 15,
                              media: [
                                Media(
                                    "https://miro.medium.com/v2/resize:fit:1200/1*P_H_UpQahH0juwQpXWXnpQ.jpeg",
                                    "Image")
                              ],
                              mentions: [],
                              quoteToId: null,
                              quotesCount: 12,
                              repliesCount: 133,
                              replyToId: widget.tweet.id.toString(),
                              repostToId: null,
                              retweetUserName: "Abdallah",
                              retweetsCount: 12,
                              text: "Text for a retweet ${index.toString()}",
                              urls: [],
                              user: User(
                                  birthDate: "07",
                                  email: "abdallah@gmail.com",
                                  fullName: "Abdallah Ahmed",
                                  id: "1",
                                  isFollowed: true,
                                  password: "abdallah123",
                                  profilePicture: File(
                                      "https://pbs.twimg.com/profile_images/1723702722476613632/bzpNL81G_400x400.jpg"),
                                  username: "abdallah_aali",
                                  usernameSuggestions: [])),
                        );
                },
                itemCount: 10,
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[800]!,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      focusNode.hasFocus
                          ? Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    "Replying to ",
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                  Text(
                                    "@" + widget.tweet.user!.username!,
                                    style: TextStyle(color: Colors.blue),
                                  )
                                ],
                              ),
                            )
                          : Container(),
                      Container(
                        padding:const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          focusNode: focusNode,
                          controller: textEditingController,
                          style: const TextStyle(color: Colors.white), // Text color
                          decoration:const  InputDecoration(
                            hintText: "Post your reply",
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14), // Text color// Placeholder text
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0), // Placeholder color
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey), // Bottom border color
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .blue), // Bottom border color when focused
                            ),
                          ),
                        ),
                      ),
                      focusNode.hasFocus
                          ? Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.camera_alt_outlined,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.image_outlined,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: FilledButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.blue)),
                                        child: Text("Reply"),
                                        onPressed: () {},
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}