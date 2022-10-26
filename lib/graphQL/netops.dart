class NetopGQL {
  static const create = """
    mutation(\$newData: CreateNetopsInput!){
      createNetop(NewNetopData: \$newData) {
        id,
        content,
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
        status
        createdAt
        tags {
          category
          title
          id
        }
        likeCount
        photo
        attachments
        permissions
      }
    }
  """;

  static const edit = """
    mutation(\$editData: EditNetopsInput!, \$id: String!){
      editNetop(EditNetopsData: \$editData, NetopId: \$id) {
        id,
        content,
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
        status
        isStared
        isHidden
        endTime
        createdAt
        tags {
          category
          title
          id
        }
        likeCount
        photo
        attachments
        permissions
      }
    }
  """;

  static const delete = """
    mutation(\$id: String!){
      deleteNetop(NetopId: \$id)
    }
  """;

  static const get = """
    query(\$id: String!){
      getNetop(NetopId: \$id) {
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
        status
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
    }
  """;

  static const getAll = """
    query(
      \$take: Float!
      \$lastId: String!
      \$filters: FilteringConditions
      \$sort: OrderInput
    ) {
      getNetops(
        take: \$take
        LastNetopId: \$lastId
        Filters: \$filters
        Sort: \$sort
      ) {
        netopList {
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
          status
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
        total
      }
    }
  """;

  static const like = """
    mutation(\$id: String!){
      toggleLikeNetop(NetopId: \$id)
    }
  """;

  static const star = """
    mutation(\$id: String!){
      toggleStar(NetopId: \$id)
    }
  """;

  static const report = """
    mutation(\$reportPostInput: ReportPostInput!, \$id: String!){
      reportNetop(ReportPostInput: \$reportPostInput, NetopId: \$id)
    }
  """;

  static const createComment = """
    mutation(\$content: String!, \$id: String!, \$images: [Upload!]){
      createCommentNetop(content: \$content, NetopId: \$id, Images: \$images){
        id
        content
        images
        createdAt
        createdBy {
          id
          name
          roll
        }
      }
    }
  """;

  static const editFragment = """
    fragment netopUpdateField on Netop {
      id,
      content,
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
      }
      createdBy {
        id
        name
        roll
      }
      linkName
      linkToAction
      title
      status
      isLiked
      isStared
      isHidden
      endTime
      createdAt
      tags {
        category
        title
        id
      }
      likeCount
      photo
      attachments
      permissions
    }
  """;
}
