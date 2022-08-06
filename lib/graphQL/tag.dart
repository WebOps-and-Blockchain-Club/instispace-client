class TagGQL {
  String getAll = """
    query{
      getTags {
        id
        title
        category
      }
    }
  """;

  static const get = """
    query GetTag(\$tag: String!) {
      getTag(Tag: \$tag) {
        id
        title
        category
        netops {
          id
          content
          commentCount
          comments {
            content
            id
            images
            createdBy {
              name
              id
              roll
            }
            createdAt
          }
          createdBy {
            id
            name
            roll
          }
          linkName
          linkToAction
          title
          isLiked
          isStared
          isHidden
          endTime
          createdAt
          permissions
          tags {
            category
            title
            id
          }
          likeCount
          photo
          attachments
        }
        events {
          id
          createdAt
          title
          content
          photo
          location
          time
          likeCount
          isStared
          linkName
          linkToAction
          permissions
          tags {
            title
            id
            category
          }
          isLiked
          createdAt
          createdBy {
            id
            name
          }
        }
      }
    }
  """;
}
