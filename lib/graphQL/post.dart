class PostGQl {
  String createPost = """
    mutation(\$postInput: CreatePostInput!) {
      createPost(postInput: \$postInput) {
        id
      }
    }
""";
}
