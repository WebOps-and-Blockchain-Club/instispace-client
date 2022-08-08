class LostAndFoundGQL {
  static const getAll = """
    query(
      \$take: Float!
      \$lastId: String!
      \$itemsFilter: [Category!]!
      \$search: String
    ) {
      getItems(
        take: \$take
        LastItemId: \$lastId
        ItemsFilter: \$itemsFilter
        search: \$search
      ) {
        total
        itemsList {
          id
          category
          name
          location
          time
          images
          contact
          createdAt
          permissions
          user {
            id
            roll
            name
          }
        }
      }
    }
  """;

  static const create = """
    mutation(\$itemInput: ItemInput!, \$images: [Upload!]) {
      createItem(ItemInput: \$itemInput, Images: \$images) {
        id
        category
        name
        location
        time
        images
        contact
        createdAt
        permissions
        user {
          id
          roll
          name
        }
      }
    }
  """;

  static const edit = """
    mutation(\$editItemInput: EditItemInput!, \$id: String!, \$images: [Upload!]) {
      editItems(EditItemInput: \$editItemInput, ItemId: \$id, Images: \$images) {
        id
        category
        name
        location
        time
        images
        contact
        createdAt
        permissions
        user {
          id
          roll
          name
        }
      }
    }
  """;

  static const resolve = """
    mutation(\$id: String!) {
      resolveItem(ItemId: \$id)
    }
  """;

  static const editFragment = """
    fragment itemUpdateField on Item {
      id
      category
      name
      location
      time
      images
      contact
      createdAt
      permissions
      user {
        id
        roll
        name
      }
    }
  """;
}
