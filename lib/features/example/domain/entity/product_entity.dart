import 'package:base_bloc_3/data/model/product/product_model.dart';

class ProductEntity {
  int id;
  String thumbnail;
  String name;
  String description;

  ProductEntity({
    required this.id,
    required this.thumbnail,
    required this.name,
    required this.description,
  });

  factory ProductEntity.fromModel(ProductModel model) {
    return ProductEntity(
      id: model.id ?? 0,
      thumbnail: model.thumbnail ?? "",
      name: model.title ?? "",
      description: model.description ?? "",
    );
  }
}
