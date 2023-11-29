import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';

class SingleTweetProvider extends StateNotifier<Tweet> {
  SingleTweetProvider(Tweet tweetInstance) : super(tweetInstance);

  void setTweet(Tweet tweet) {
    state = tweet;
  }

  void toggleLike() {
    Tweet tweet = state;
    tweet.likesCount = tweet.likesCount! + (tweet.isLiked! == false ? 1 : -1);
    tweet.isLiked = !tweet.isLiked!;
    state = tweet;
  }

  void toggleRetweet() {
    Tweet tweet = state;
    tweet.retweetsCount = tweet.retweetsCount! + (tweet.isRetweeted! == false ? 1 : -1);
    tweet.isRetweeted = !tweet.isRetweeted!;
    state = tweet;
  }

  void toggleFollow() {
    Tweet tweet = state;
    tweet.user!.isFollowed = !tweet.user!.isFollowed!;
    state = tweet;
  }


  

  
}