class LnFQuery{
  String createItem="""
  mutation(\$itemInput: ItemInput!, \$images: [Upload!]){
    createItem(ItemInput: \$itemInput, Images: \$images)
  }
  """;
  String getItems="""
   query(\$itemsFilter: [Category!]!,\$skip: Float!, \$take: Float!){
    getItems(ItemsFilter: \$itemsFilter,skip: \$skip, take: \$take){
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
    total
  }
    getMe {
    id
  }
  }
  """;
  String editItem="""
  mutation(\$editItemsEditItemInput: EditItemInput!, \$editItemsItemId: String!, \$editItemsImages: [Upload!]){
  editItems(EditItemInput: \$editItemsEditItemInput, ItemId: \$editItemsItemId, Images:\$editItemsImages)
}
  """;
  String resolveItem="""
  mutation(\$resolveItemItemId: String!){
  resolveItem(ItemId: \$resolveItemItemId)
}
  """;
}