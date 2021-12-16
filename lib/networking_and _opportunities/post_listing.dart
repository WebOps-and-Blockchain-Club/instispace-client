import 'package:client/networking_and%20_opportunities/commentclass.dart';
import 'package:flutter/material.dart';
import 'post.dart';
import 'post_card.dart';
import 'tag.dart';

class Post_Listing extends StatefulWidget {
  const Post_Listing({Key? key}) : super(key: key);

  @override
  _Post_ListingState createState() => _Post_ListingState();
}

class _Post_ListingState extends State<Post_Listing> {
  List<Post> posts =[
    Post(title: 'title1', description: 'A week ago a friend invited a couple of other couples over for dinner. Eventually, the food (but not the wine) was cleared off the table for what turned out to be some fierce Scrabbling. Heeding the strategy of going for the shorter, more valuable word over the longer cheaper word, our final play was “Bon,” which–as luck would have it!–happens to be a Japanese Buddhist festival, and not, as I had originally asserted while laying the tiles on the board, one half of a chocolate-covered cherry treat. Anyway, the strategy worked. My team only lost by 53 points instead of 58.Just the day before, our host had written of the challenges of writing short. In journalism–my friend’s chosen trade, and mostly my own, too–Mark Twain’s observation undoubtedly applies: “I didn’t have time to write a short letter, so I wrote a long one instead.” The principle holds across genres, in letters, reporting, and other writing. It’s harder to be concise than to blather. (Full disclosure, this blog post will clock in at a blather-esque 803 words.) Good writing is boiled down, not baked full of air like a souffl??. No matter how yummy souffl??s may be. Which they are. Yummy like a Grisham novel.',imgUrl: 'https://images.unsplash.com/photo-1553603227-2358aabe821e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80',like_counter: 10,tags:[Tag(Tag_name: 'Tag1'),Tag(Tag_name: 'Tag2'),Tag(Tag_name: 'Tag3')],comments: [Comment(message: 'good post', Name: 'Name', profile_pic_url:'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),Comment(message: 'good post', Name: 'Name', profile_pic_url:'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),Comment(message: 'good post', Name: 'Name', profile_pic_url:'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80')],linktoaction: 'link1' ),
    Post(title: 'title2', description: 'A week ago a friend invited a couple of other couples over for dinner. Eventually, the food (but not the wine) was cleared off the table for what turned out to be some fierce Scrabbling. Heeding the strategy of going for the shorter, more valuable word over the longer cheaper word, our final play was “Bon,” which–as luck would have it!–happens to be a Japanese Buddhist festival, and not, as I had originally asserted while laying the tiles on the board, one half of a chocolate-covered cherry treat. Anyway, the strategy worked. My team only lost by 53 points instead of 58.Just the day before, our host had written of the challenges of writing short. In journalism–my friend’s chosen trade, and mostly my own, too–Mark Twain’s observation undoubtedly applies: “I didn’t have time to write a short letter, so I wrote a long one instead.” The principle holds across genres, in letters, reporting, and other writing. It’s harder to be concise than to blather. (Full disclosure, this blog post will clock in at a blather-esque 803 words.) Good writing is boiled down, not baked full of air like a souffl??. No matter how yummy souffl??s may be. Which they are. Yummy like a Grisham novel.11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111122222222222222222222222222222222222222222222222222222222222222222222222222222222223333333333333333333333333333333333333333333344444444444444444444444444444444444',imgUrl: '',like_counter: 10, tags:[Tag(Tag_name: 'Tag1'),Tag(Tag_name: 'Tag2'),Tag(Tag_name: 'Tag3')],comments: [Comment(message: 'good post', Name: 'Name', profile_pic_url:'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),Comment(message: 'good post', Name: 'Name', profile_pic_url:'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),Comment(message: 'good post', Name: 'Name', profile_pic_url:'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80')],linktoaction: 'link1' ),
    Post(title: 'title1', description: 'description1',imgUrl: 'https://images.unsplash.com/photo-1553603227-2358aabe821e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80',like_counter: 10, tags:[Tag(Tag_name: 'Tag1'),Tag(Tag_name: 'Tag2'),Tag(Tag_name: 'Tag3')],comments:[Comment(message: 'good post', Name: 'Name', profile_pic_url:'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),Comment(message: 'good post', Name: 'Name', profile_pic_url:'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),Comment(message: 'good post', Name: 'Name', profile_pic_url:'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80')],linktoaction: 'link1' ),
    Post(title: 'title1', description: 'description1',imgUrl: 'https://images.unsplash.com/photo-1553603227-2358aabe821e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80',like_counter: 10, tags:[Tag(Tag_name: 'Tag1'),Tag(Tag_name: 'Tag2'),Tag(Tag_name: 'Tag3')],comments:[Comment(message: 'good post', Name: 'Name', profile_pic_url:'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),Comment(message: 'good post', Name: 'Name', profile_pic_url:'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),Comment(message: 'good post', Name: 'Name', profile_pic_url:'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80')],linktoaction: 'link1' ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('All Posts'),
        backgroundColor:Color(0xFFE6CCA9),
        actions: [
          IconButton(onPressed: ()=>{}, icon: Icon(Icons.filter_alt_outlined)),
          IconButton(onPressed: ()=>{
            Navigator.pushNamed(context, '/addpost_networking'),
          },
              iconSize: 35.0,
              icon:Icon(Icons.add_box)
          ),
        ],
      ),
      body: ListView(
                 children: [
                  Column(
                    children: posts.map((post) => PostCard(
                      post: post,
                    )).toList(),
                  )
                 ],
                ),



    );
  }
}
