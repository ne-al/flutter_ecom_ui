import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class ProductService {
  Box cartBox = Hive.box("CART");
  Box likedProductsBox = Hive.box("FAVORITES");
  Logger logger = Logger();

  // like / unlike product
  Future<void> toggleFavorite(int productId) async {
    var allLikedProducts =
        await likedProductsBox.get("products", defaultValue: []);

    if (allLikedProducts.contains(productId)) {
      await allLikedProducts.remove(productId);
      await likedProductsBox.put("products", allLikedProducts);
      logger.e("Product id: $productId has been removed from favorites");
    } else {
      await allLikedProducts.add(productId);
      await likedProductsBox.put("products", allLikedProducts);
      logger.d("Product id: $productId has been added to favorites");
    }
  }

  // add / remove product to / from cart
  Future<void> toggleCart(int productId) async {
    var allCartProducts = await cartBox.get("products", defaultValue: []);

    if (allCartProducts.contains(productId)) {
      await allCartProducts.remove(productId);
      await cartBox.put("products", allCartProducts);
      logger.e("Product id: $productId has been removed from cart");
    } else {
      await allCartProducts.add(productId);
      await cartBox.put("products", allCartProducts);
      logger.d("Product id: $productId has been added to cart");
    }
  }
}
