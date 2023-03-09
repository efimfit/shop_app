class Product {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavourite;

  Product({
    this.id = '',
    this.title = '',
    this.description = '',
    this.price = 0.0,
    this.imageUrl = '',
    this.isFavourite = false,
  });

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    bool? isFavourite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
