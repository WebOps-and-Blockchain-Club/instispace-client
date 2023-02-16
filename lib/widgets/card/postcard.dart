import 'package:client/models/actions.dart';
import 'package:client/models/postModel.dart';
import 'package:client/screens/home/feed/comments.dart';
import 'package:client/utils/custom_icons.dart';
import 'package:client/widgets/card/action_buttons.dart';
import 'package:flutter/material.dart';
import 'image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/category.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final PostActions actions;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const PostCard(
      {Key? key,
      required this.post,
      required this.actions,
      required this.scaffoldKey})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  @override
  bool _showContent = false;
  List<String> imageUrls = [];
  GlobalKey key = GlobalKey();
  late final AnimationController _likeController = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);
  bool _isLiked = false;
  double minHeight = 0;

  PostCategoryModel? typeOfPost(PostModel post) {
    for (var cat in feedCategories) {
      if (cat.name.toLowerCase() == post.category.toLowerCase()) return cat;
    }
    for (var cat in forumCategories) {
      if (cat.name.toLowerCase() == post.category.toLowerCase()) return cat;
    }
    return null;
  }

  void getMinHeight(List<String> imageUrls) {
    for (var imageUrl in imageUrls) {
      Image image = Image.network(imageUrl);
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo image, bool synchronousCall) {
            var myImage = image.image;

            double c = myImage.width.toDouble() /
                (MediaQuery.of(context).size.width - 80.toDouble());
            //print(myImage.height.toDouble() / c);
            if (myImage.height.toDouble() / c >= minHeight) {
              setState(() {
                minHeight = myImage.height.toDouble() / c;
              });
            }
          },
        ),
      );
      print("Min height : $minHeight");
    }
  }

  @override
  void initState() {
    //print(widget.post.photo!.length);

    if (widget.post.photo != null && widget.post.photo!.isNotEmpty) {
      for (var url in widget.post.photo!) {
        print(url);
        imageUrls.add(url.trim());
      }
      getMinHeight(imageUrls);
    }
    print(imageUrls);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = widget.scaffoldKey;
    PostModel post = widget.post;
    final PostActions actions = widget.actions;
    print(imageUrls);
    //print("${post.title}   ${post.photo}");
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
      child: Column(
        children: [
          // Row(
          //   children: [
          //     new Spacer(),
          //     Container(
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(15),
          //             topRight: Radius.circular(15),
          //             //bottomLeft: Radius.circular(35),

          //             //topLeft: Radius.circular(35),
          //           ),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.grey.withOpacity(0.2),
          //               blurRadius: 7,
          //               spreadRadius: 7,
          //               offset: Offset(0, 2),
          //             ),
          //           ]),
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Icon(CustomIcons.help),
          //       ),
          //     )
          //   ],
          // ),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                  //topLeft: Radius.circular(35),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 7,
                      spreadRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ]),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (feedCategories.contains(typeOfPost(post)))
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    )
                                  ]),
                              margin: EdgeInsets.only(right: 12),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://ci3.googleusercontent.com/mail-sig/AIorK4x0g-dl34oRt-cteWni1rnDf4ol6Ry7ni7EBqTDD6_KQNKm7K0A5SftAJZCK6k1JVqbd1065Wo",
                                placeholder: (_, __) => const Icon(
                                    Icons.account_circle_rounded,
                                    size: 40),
                                errorWidget: (_, __, ___) => const Icon(
                                    Icons.account_circle_rounded,
                                    size: 40),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  //margin: EdgeInsets.only(top: 24),
                                  child: Text(
                                    post.title!,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                // Text(
                                //   "${post.createdBy.name}, ",
                                //   style: TextStyle(fontSize: 15),
                                // )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: Icon(
                                typeOfPost(post) != null
                                    ? typeOfPost(post)!.icon
                                    : CustomIcons.help,
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Text(post.photo![0]),
                      post.photo != null && post.photo!.isNotEmpty
                          ? Column(
                              children: [
                                SizedBox(height: 25),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(29)),
                                  child: ImageCard(
                                    minHeight: minHeight,
                                    imageUrls: imageUrls,
                                  ),
                                ),
                                SizedBox(height: 24),
                                AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 200),
                                  secondChild: Container(),
                                  crossFadeState: _showContent
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  firstCurve: Curves.easeIn,
                                  secondCurve: Curves.easeOut,
                                  firstChild: Column(
                                    children: [
                                      if (post.location != null ||
                                          post.location == '') ...[
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'DATE - 7th Feb 9:00 PM ',
                                          style: TextStyle(
                                              fontSize: 19,
                                              color: Colors.lightBlue,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'VENUE - Near CRC',
                                          style: TextStyle(
                                              fontSize: 19,
                                              color: Colors.lightBlue,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                      SizedBox(height: 15),
                                      Text(
                                        post.content!,
                                        style: TextStyle(height: 1.2),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          post.createdBy
                                              .name, // should change it such that when clicked it opens profile page.
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "#Popnight #Saarang",
                                          style: TextStyle(
                                              color: Color(0xFF006096)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                if (post.location != null &&
                                    post.location != '')
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'DATE - 7th Feb 9:00 PM ',
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: Colors.lightBlue,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        'VENUE - ${post.location}',
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: Colors.lightBlue,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                SizedBox(height: 15),
                                AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 200),
                                  secondChild: Column(
                                    children: [
                                      Text(
                                        post.content!,
                                        style: TextStyle(height: 1.2),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          post.createdBy
                                              .name, // should change it such that when clicked it opens profile page.
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "#Popnight #Saarang",
                                          style: TextStyle(
                                              color: Color(0xFF006096)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                  crossFadeState: _showContent
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  firstCurve: Curves.easeIn,
                                  secondCurve: Curves.easeOut,
                                  firstChild: Column(
                                    children: [
                                      Text(
                                        post.content!,
                                        style: TextStyle(height: 1.2),
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          post.createdBy
                                              .name, // should change it such that when clicked it opens profile page.
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "#Popnight #Saarang",
                                          style: TextStyle(
                                              color: Color(0xFF006096)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),

                      //Action Buttons
                      Row(
                        children: [
                          if (post.category == 'Queries') ...[
                            Icon(Icons.arrow_upward),
                            Text('40'),
                            Icon(Icons.arrow_downward)
                          ] else ...[
                            if (feedCategories.contains(typeOfPost(post)) ||
                                post.category == 'Opportunities' ||
                                post.category == 'Reviews' ||
                                post.category == 'Random Thoughts')
                              /*ScaleTransition(
                                scale: Tween(begin: 0.7, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: _likeController,
                                        curve: Curves.easeOut)),
                                child: IconButton(
                                  icon: _isLiked
                                      ? const Icon(
                                          CustomIcons.likefilled,
                                          color: Colors.red,
                                          size: 25,
                                        )
                                      : const Icon(
                                          CustomIcons.like,
                                          size: 25,
                                        ),
                                  onPressed: () {
                                    setState(() {
                                      _isLiked = !_isLiked;
                                    });
                                    _likeController.reverse().then(
                                        (value) => _likeController.forward());
                                  },
                                ),
                              ),*/
                              LikePostButton(
                                  like: post.like!, likeAction: actions.like),
                            //Text('25'),
                          ],
                          //if(post.comments!=null)
                          CommentPostButton(
                              comment: post.comments!,
                              commentPage: actions.comment),
                          /*IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () {
                              //print(comment)
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Comments(
                                        post: post,
                                        scaffoldKey: _scaffoldKey,
                                      )));
                            },
                          ),*/
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: SharePostButton(post: post),
                          ),
                          if (feedCategories.contains(typeOfPost(post)) ||
                              post.category == 'Opportunities')
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: SetReminderButton(post: post),
                            ),
                          if (feedCategories.contains(typeOfPost(post)) ||
                              post.category == 'Opportunities' ||
                              post.category == 'Connect')
                            StarPostButton(
                                star: StarPostModel(
                                    isStarredByUser: post.isSaved!),
                                starAction: actions.star),
                          new Spacer(),
                          if (!(post.photo == null || post.photo!.isEmpty) &&
                              (post.content!.length <= 500))
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _showContent = !_showContent;
                                });
                              },
                              icon: Icon(
                                _showContent
                                    ? CustomIcons.dropdown_close
                                    : CustomIcons.dropdown,
                                size: 8,
                                color: Color(0xFF383838),
                              ),
                            )
                        ],
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }
}
