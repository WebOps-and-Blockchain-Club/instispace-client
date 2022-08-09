class ImageGQL {
  static const upload = """
    mutation(\$image: [Upload!]) {
      imageUpload(Image: \$image) {
        imageUrls
      }
    }
  """;
}
