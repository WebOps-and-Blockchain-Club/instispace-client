class LostAndFoundGQL {
  static const getAll = """
    query(
      \$take: Float!
      \$lastId: String!
      \$itemsFilter: [Category!]!
      \$filters: FilteringConditions
    ) {
      getItems(
        take: \$take
        LastItemId: \$lastId
        ItemsFilter: \$itemsFilter
        Filters: \$filters
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
            role
          }
        }
      }
    }
  """;

  static const create = """
    mutation(\$itemInput: ItemInput!) {
      createItem(ItemInput: \$itemInput) {
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
          role
        }
      }
    }
  """;

  static const edit = """
    mutation(\$editItemInput: EditItemInput!, \$id: String!) {
      editItems(EditItemInput: \$editItemInput, ItemId: \$id) {
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
          role
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
        role
      }
    }
  """;
}
