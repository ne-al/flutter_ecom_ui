import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/app/screens/product_view.dart';
import 'package:ecom/core/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class ProductTile extends StatelessWidget {
  final String categoryName;
  final List productList;
  const ProductTile({
    super.key,
    required this.categoryName,
    required this.productList,
  });

  Future<void> likeProduct(int productId) async {
    await ProductService().toggleFavorite(productId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(16),
        Row(
          children: [
            Text(
              categoryName,
              style: GoogleFonts.lato(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              "See more",
              style: GoogleFonts.lato(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
        const Gap(12),
        MasonryGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemCount: productList.length,
          itemBuilder: (context, index) {
            Map product = productList[index];
            return GestureDetector(
              onTap: () {
                pushScreen(
                  context,
                  screen: ProductView(productId: product["id"]),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.slideUp,
                );
              },
              onDoubleTap: () async {
                await likeProduct(product["id"]);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: CachedNetworkImage(
                              imageUrl: product["thumbnail"],
                              fit: BoxFit.cover,
                              height: index.isEven ? 200 : 160,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 0.5,
                            right: 0.5,
                            child: IconButton.filled(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                ),
                              ),
                              constraints: BoxConstraints(
                                maxHeight: index.isEven ? 34 : 28,
                                maxWidth: index.isEven ? 34 : 28,
                              ),
                              iconSize: index.isEven ? 19 : 13.2,
                              onPressed: () {
                                likeProduct(product["id"]);
                              },
                              icon: ValueListenableBuilder(
                                  valueListenable:
                                      Hive.box("FAVORITES").listenable(),
                                  builder: (context, box, child) {
                                    List likedProduct =
                                        box.get("products", defaultValue: []);

                                    bool isLiked =
                                        likedProduct.contains(product["id"]);

                                    return isLiked
                                        ? Icon(
                                            Iconsax.heart5,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          )
                                        : Icon(
                                            Iconsax.heart,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          );
                                  }),
                            ),
                          ),
                        ],
                      ),
                      const Gap(12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product["title"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const Gap(4),
                          Row(
                            children: [
                              Text(
                                "\u20B9 ${product["price"]}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Iconsax.star1,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const Gap(2),
                              Text(
                                "${product["rating"]} (${product["reviews"].length * (index + 1) + (index + 1 % 5) * 10})",
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Widget productTile(
//   List productList,
//   String categoryName,
//   BuildContext context,
// ) {
//   return 
// }
