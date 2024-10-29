import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/core/payment/order_service.dart';
import 'package:ecom/core/payment/payment_handler.dart';
import 'package:ecom/core/service/product_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CartPage extends StatefulWidget {
  final bool fromProducts;
  const CartPage({
    super.key,
    this.fromProducts = false,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isAllSelected = false;
  late Box cartBox;
  late final ValueListenable _valueListenable;

  @override
  void initState() {
    super.initState();
    cartBox = Hive.box("CART");
    _valueListenable = ValueNotifier<Box>(cartBox);
    _valueListenable.addListener(_getItemInCart);
  }

  Future<void> _getItemInCart() async {
    var products = _valueListenable.value.get("products", defaultValue: []);

    print(products);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              bottom: widget.fromProducts ? 0 : 52,
            ),
            child: ValueListenableBuilder(
              valueListenable: cartBox.listenable(),
              builder: (context, box, _) {
                List data = box.get("products", defaultValue: []);

                final reversedData = data.reversed;

                List products = reversedData.toList();

                return Stack(
                  children: [
                    SafeArea(
                      child: NestedScrollView(
                        headerSliverBuilder: (context, innerBoxIsScrolled) => [
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            elevation: 4,

                            // expandedHeight: constraints.maxHeight * 0.16,
                            title: Text(
                              "Cart",
                              style: GoogleFonts.lato(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                            actions: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                  ),
                                ),
                                child: Icon(
                                  Icons.more_horiz,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                              const Gap(12),
                            ],
                            // flexibleSpace: FlexibleSpaceBar(
                            //   background: Padding(
                            //     padding: const EdgeInsets.only(
                            //       left: 12,
                            //       right: 12,
                            //       bottom: 24,
                            //     ),
                            //     child: Column(
                            //       mainAxisSize: MainAxisSize.max,
                            //       mainAxisAlignment: MainAxisAlignment.end,
                            //       children: [
                            //         Container(
                            //           padding: const EdgeInsets.symmetric(
                            //             horizontal: 18,
                            //           ),
                            //           width: double.infinity,
                            //           height: 60,
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(14),
                            //             color: Theme.of(context)
                            //                 .colorScheme
                            //                 .surfaceContainerHigh,
                            //             border: Border.all(
                            //               color: Theme.of(context)
                            //                   .colorScheme
                            //                   .surfaceContainerHighest,
                            //             ),
                            //           ),
                            //           child: Row(
                            //             children: [
                            //               Icon(
                            //                 Iconsax.location,
                            //                 size: 22,
                            //                 color: Theme.of(context)
                            //                     .colorScheme
                            //                     .onSurfaceVariant,
                            //               ),
                            //               const Gap(8),
                            //               Text(
                            //                 "92 High Street, Patna",
                            //                 style: GoogleFonts.lato(
                            //                   fontSize: 18,
                            //                   fontWeight: FontWeight.bold,
                            //                   color: Theme.of(context)
                            //                       .colorScheme
                            //                       .onSurfaceVariant,
                            //                 ),
                            //               ),
                            //               const Spacer(),
                            //               Icon(
                            //                 Iconsax.arrow_right_3,
                            //                 color: Theme.of(context)
                            //                     .colorScheme
                            //                     .onSurfaceVariant,
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ),
                        ],
                        body: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                products.isNotEmpty
                                    ? ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: products.length,
                                        separatorBuilder: (context, index) =>
                                            Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Divider(
                                            thickness: 0.8,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerHighest,
                                          ),
                                        ),
                                        itemBuilder: (context, index) =>
                                            _cartItemTile(
                                          context,
                                          index,
                                          products,
                                        ),
                                      )
                                    : const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("NO ITEMS IN CART"),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (products.isNotEmpty)
                      SlidingUpPanel(
                        minHeight: 56,
                        maxHeight: constraints.maxHeight * 0.45,
                        renderPanelSheet: false,
                        backdropEnabled: true,
                        isDraggable: true,
                        panelSnapping: true,
                        parallaxEnabled: true,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        panel: _expandedContent(
                          context,
                          products.length,
                          products,
                        ),
                        collapsed: _collapsedContent(),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

Widget _removeItem(List products, int productId) {
  return InkWell(
    onTap: () {
      ProductService().toggleCart(products[productId]);
    },
    child: const Icon(
      Iconsax.trash,
      color: Colors.red,
      size: 18,
    ),
  );
}

Widget _cartItemTile(BuildContext context, int index, List productIds) {
  return ListTile(
    title: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            height: 130,
            width: 130,
            imageUrl:
                "https://placehold.co/720.png?text=PRODUCT+${index + 1}+IMAGE&font=lato",
            fit: BoxFit.cover,
          ),
        ),
        const Gap(18),
        Expanded(
          child: SizedBox(
            height: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "PRODUCT NAME ${index + 1}",
                      maxLines: 2,
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    _removeItem(productIds, index)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\u20B910.00",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHigh,
                            ),
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                          ),
                          child: Icon(
                            Iconsax.minus,
                            size: 24,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                          ),
                        ),
                        const Gap(12),
                        Text(
                          "1",
                          style: GoogleFonts.lato(
                            fontSize: 24,
                          ),
                        ),
                        const Gap(12),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green.shade700,
                            ),
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                          ),
                          child: Icon(
                            Iconsax.add,
                            size: 24,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// Widget to show when the sheet is minimized
Widget _collapsedContent() {
  return Container(
    margin: const EdgeInsets.only(left: 12, right: 12),
    decoration: const BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    padding: const EdgeInsets.all(16),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Checkout',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Lottie.asset(
            "assets/lottie/swipe_up.json",
            fit: BoxFit.cover,
          ),
        ],
      ),
    ),
  );
}

// Widget to show when the sheet is fully expanded
Widget _expandedContent(BuildContext context, int totalLength, List products) {
  double amount = (totalLength * 10) * 0.9 + 40;

  return Container(
    margin: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
    ),
    padding: const EdgeInsets.all(8),
    child: SingleChildScrollView(
      child: Column(
        children: [
          ...List.generate(
            totalLength,
            (index) => ListTile(
              leading: CircleAvatar(
                radius: 16,
                child: Text(
                  "${index + 1}",
                  style: GoogleFonts.lato(
                    fontSize: 13,
                  ),
                ),
              ),
              title: Text(
                'Item ${index + 1}',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional information here',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\u20B910.00',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(12),
                  _removeItem(products, index)
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Divider(),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerLow
                    .withAlpha(140),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.location,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const Gap(8),
                Text(
                  "High street, Patna",
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Icon(
                  Iconsax.arrow_right_3,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                )
              ],
            ),
          ),
          const Gap(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Delivery Fee:",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "\u20B940.00",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Discount:",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "10%",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subtotal:",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "\u20B9${(totalLength * 10) + 40}",
                          style: GoogleFonts.lato(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          "\u20B9$amount",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Container(
          //   margin: const EdgeInsets.symmetric(horizontal: 4),
          //   width: double.infinity,
          //   height: 50,
          //   padding: const EdgeInsets.symmetric(horizontal: 12),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(12),
          //     color: Theme.of(context).colorScheme.surfaceContainerHighest,
          //     border: Border.all(
          //       color: Theme.of(context)
          //           .colorScheme
          //           .surfaceContainerLow
          //           .withAlpha(140),
          //     ),
          //   ),
          //   child: Row(
          //     children: [
          //       Icon(
          //         Iconsax.ticket_discount,
          //         color: Theme.of(context).colorScheme.onSurfaceVariant,
          //       ),
          //       const Gap(8),
          //       Text(
          //         "Apply Coupon Code",
          //         style: GoogleFonts.lato(
          //           fontSize: 16,
          //           fontWeight: FontWeight.w600,
          //           color: Theme.of(context).colorScheme.onSurfaceVariant,
          //         ),
          //       ),
          //       const Spacer(),
          //       Icon(
          //         Iconsax.arrow_right_3,
          //         color: Theme.of(context).colorScheme.onSurfaceVariant,
          //       )
          //     ],
          //   ),
          // ),

          const Gap(20),
          InkWell(
            onTap: () async {
              /**
               * THIS IS NOT SAFE TO EXPOSE THIS THING IN APPLICATION
               * DO IT ON SERVER TO GENERATE THE ORDER ID
               */

              var order = await createOrder(
                amount * 100,
                products.join(","),
                false,
                0,
                {"test": "test"},
              );

              Logger().e(order);

              if (context.mounted && order.isNotEmpty) {
                pushScreenWithoutNavBar(
                  context,
                  PaymentHandler(
                    orderData: order,
                    amount: amount * 100,
                  ),
                );
              }
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "Checkout",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Made with ♥ by Neal",
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Gap(20),
        ],
      ),
    ),
  );
}
