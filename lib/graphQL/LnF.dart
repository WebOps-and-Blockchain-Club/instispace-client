class LnFQuery {
  String createItem = """
  mutation(\$itemInput: ItemInput!, \$images: [Upload!]){
    createItem(ItemInput: \$itemInput, Images: \$images)
  }
  """;
  String getItems = """
   query(\$take: Float!, \$lastItemId: String!, \$itemsFilter: [Category!]!, \$search: String){
  getItems(take: \$take, LastItemId: \$lastItemId, ItemsFilter: \$itemsFilter, search: \$search) {
    total
    itemsList{
      id
      category
      name
      location
      time
      images
      contact
      user{
        id
        roll
        name
        mobile
      }
    }
  }
}
  """;
  String editItem = """
  mutation EditItems(\$editItemInput: EditItemInput!, \$itemId: String!, \$images: [Upload!]) {
  editItems(EditItemInput: \$editItemInput, ItemId: \$itemId, Images: \$images)
}
  """;
  String resolveItem = """
  mutation(\$resolveItemItemId: String!){
  resolveItem(ItemId: \$resolveItemItemId)
}
  """;
}
