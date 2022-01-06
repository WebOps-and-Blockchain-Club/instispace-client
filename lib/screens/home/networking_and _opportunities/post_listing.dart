import 'package:client/models/commentclass.dart';
import 'package:client/screens/home/networking_and%20_opportunities/addpost.dart';
import 'package:flutter/material.dart';
import '../../../models/post.dart';
import 'post_card.dart';
import '../../../models/tag.dart';

class Post_Listing extends StatefulWidget {
  const Post_Listing({Key? key}) : super(key: key);

  @override
  _Post_ListingState createState() => _Post_ListingState();
}

class _Post_ListingState extends State<Post_Listing> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Post> posts = [
    Post(
        title: 'title1',
        description:
            'A week ago a friend invited a couple of other couples over for dinner. Eventually, the food (but not the wine) was cleared off the table for what turned out to be some fierce Scrabbling. Heeding the strategy of going for the shorter, more valuable word over the longer cheaper word, our final play was “Bon,” which–as luck would have it!–happens to be a Japanese Buddhist festival, and not, as I had originally asserted while laying the tiles on the board, one half of a chocolate-covered cherry treat. Anyway, the strategy worked. My team only lost by 53 points instead of 58.Just the day before, our host had written of the challenges of writing short. In journalism–my friend’s chosen trade, and mostly my own, too–Mark Twain’s observation undoubtedly applies: “I didn’t have time to write a short letter, so I wrote a long one instead.” The principle holds across genres, in letters, reporting, and other writing. It’s harder to be concise than to blather. (Full disclosure, this blog post will clock in at a blather-esque 803 words.) Good writing is boiled down, not baked full of air like a souffl??. No matter how yummy souffl??s may be. Which they are. Yummy like a Grisham novel.',
        imgUrl:
            'https://web.whatsapp.com/c77fc087-cdb2-4625-9b71-ed2b1db61c66',
        like_counter: 10,
        tags: [
          Tag(Tag_name: 'Tag1'),
          Tag(Tag_name: 'Tag2'),
          Tag(Tag_name: 'Tag3')
        ],
        comments: [
          Comment(
              message: 'good post',
              Name: 'Name',
              profile_pic_url:
                  'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),
          Comment(
              message: 'good post',
              Name: 'Name',
              profile_pic_url:
                  'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),
          Comment(
              message: 'good post',
              Name: 'Name',
              profile_pic_url:
                  'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80')
        ],
        linktoaction: 'link1'),
    Post(
        title: 'title2',
        description:
            'A week ago a friend invited a couple of other couples over for dinner. Eventually, the food (but not the wine) was cleared off the table for what turned out to be some fierce Scrabbling. Heeding the strategy of going for the shorter, more valuable word over the longer cheaper word, our final play was “Bon,” which–as luck would have it!–happens to be a Japanese Buddhist festival, and not, as I had originally asserted while laying the tiles on the board, one half of a chocolate-covered cherry treat. Anyway, the strategy worked. My team only lost by 53 points instead of 58.Just the day before, our host had written of the challenges of writing short. In journalism–my friend’s chosen trade, and mostly my own, too–Mark Twain’s observation undoubtedly applies: “I didn’t have time to write a short letter, so I wrote a long one instead.” The principle holds across genres, in letters, reporting, and other writing. It’s harder to be concise than to blather. (Full disclosure, this blog post will clock in at a blather-esque 803 words.) Good writing is boiled down, not baked full of air like a souffl??. No matter how yummy souffl??s may be. Which they are. Yummy like a Grisham novel.11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111122222222222222222222222222222222222222222222222222222222222222222222222222222222223333333333333333333333333333333333333333333344444444444444444444444444444444444',
        imgUrl: '',
        like_counter: 10,
        tags: [
          Tag(Tag_name: 'Tag1'),
          Tag(Tag_name: 'Tag2'),
          Tag(Tag_name: 'Tag3')
        ],
        comments: [
          Comment(
              message: 'good post',
              Name: 'Name',
              profile_pic_url:
                  'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),
          Comment(
              message: 'good post',
              Name: 'Name',
              profile_pic_url:
                  'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),
          Comment(
              message: 'good post',
              Name: 'Name',
              profile_pic_url:
                  'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80')
        ],
        linktoaction: 'link1'),
    Post(
        title: 'title1',
        description: 'description1',
        imgUrl:
            'https://images.unsplash.com/photo-1553603227-2358aabe821e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80',
        like_counter: 10,
        tags: [
          Tag(Tag_name: 'Tag1'),
          Tag(Tag_name: 'Tag2'),
          Tag(Tag_name: 'Tag3')
        ],
        comments: [
          Comment(
              message: 'good post',
              Name: 'Name',
              profile_pic_url:
                  'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),
          Comment(
              message: 'good post',
              Name: 'Name',
              profile_pic_url:
                  'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),
          Comment(
              message: 'good post',
              Name: 'Name',
              profile_pic_url:
                  'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80')
        ],
        linktoaction: 'link1'),
    Post(
        title: 'title1',
        description: 'description1',
        imgUrl:
            'https://images.unsplash.com/photo-1553603227-2358aabe821e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80',
        like_counter: 10,
        tags: [
          Tag(Tag_name: 'Tag1'),
          Tag(Tag_name: 'Tag2'),
          Tag(Tag_name: 'Tag3')
        ],
        comments: [
          Comment(
              message: 'good post',
              Name: 'Name',
              profile_pic_url:
                  'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),
          Comment(
              message: 'good post',
              Name: 'Name',
              profile_pic_url:
                  'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),
          Comment(
              message: 'good post',
              Name: 'Name',
              profile_pic_url:
                  'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80')
        ],
        linktoaction: 'link1'),
  ];
  var A2Zvalue = false;
  var Z2Avalue =false;
  var Earliestvalue = false;
  var latervalue =false;
  var mostlikesvalue =false;
  Map<String, bool> values = {
    'workshop': false,
    'por': false,
    'startup':false,
    'internship' :false,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      endDrawer: new Drawer(
        child: SafeArea(
          child: ListView(
            primary: false,
            children: [
              Column(
              children: [
                Text('Filter'),
                SizedBox(
                  height: 400.0,
                  child: ListView(
                    children: values.keys.map((String key) {
                      return new CheckboxListTile(
                        title: new Text(key),
                        activeColor: Colors.blue,
                        value: values[key],
                        onChanged: (bool? value) {
                          setState(() {
                            values[key] = value!;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                Text('Sort'),
                CheckboxListTile(
                    title: Text('Earliest to later'),
                    value: Earliestvalue,
                    onChanged:(bool? value){
                      setState(() {
                        Earliestvalue=value!;
                      });
                    }
                ),
                CheckboxListTile(
                    title: Text('Later to Earliest'),
                    value: latervalue,
                    onChanged:(bool? value){
                      setState(() {
                        latervalue=value!;
                      });
                    }
                ),
                CheckboxListTile(
                    title: Text('most liked'),
                    value: mostlikesvalue,
                    onChanged:(bool? value){
                      setState(() {
                        mostlikesvalue=value!;
                      });
                    }
                ),
                CheckboxListTile(
                  title: Text('A to Z'),
                    value: A2Zvalue,
                    onChanged:(bool? value){
                  setState(() {
                    A2Zvalue=value!;
                  });
                    }
                ),
                CheckboxListTile(
                    title: Text('Z to A'),
                    value: Z2Avalue,
                    onChanged:(bool? value){
                      setState(() {
                        Z2Avalue=value!;
                      });
                    }
                ),
              ],
            ),
        ]
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('All Posts'),
        backgroundColor: Color(0xFFE6CCA9),
        actions: [
          IconButton(
              onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
              icon: Icon(Icons.filter_alt_outlined)),
          IconButton(
              onPressed: () => {
            Navigator.of(context).push(
            MaterialPageRoute(
           builder: (BuildContext context)=> AddPost())),
            },
              iconSize: 35.0,
              icon: Icon(Icons.add_box)),
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: posts
                .map((post) => PostCard(
                      post: post,
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
