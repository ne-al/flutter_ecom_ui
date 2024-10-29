import 'package:ecom/app/screens/cart.dart';
import 'package:ecom/core/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class AddToCartButton extends StatefulWidget {
  final int productId;
  const AddToCartButton({
    super.key,
    required this.productId,
  });

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool shouldAnimate = false;
  bool isAddedToCart = false;
  bool showText = false;
  bool isAlreadyInCart = false;
  Box cartBox = Hive.box("CART");
  List allCartProducts = [];
  bool showGoToCart = false;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showText = true;
          delayGoToCart(2000);
        });
      } else if (status == AnimationStatus.forward) {
        setState(() {
          showText = false;
        });
      }
    });

    _init();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    allCartProducts = await cartBox.get("products", defaultValue: []);

    isAlreadyInCart = allCartProducts.contains(widget.productId);

    isAddedToCart = isAlreadyInCart;
    shouldAnimate = !isAddedToCart;

    setState(() {});

    Logger().i(isAlreadyInCart);
    Logger().e(shouldAnimate);
  }

  Future<void> delayGoToCart(int delayedTime) async {
    await Future.delayed(Duration(milliseconds: delayedTime));

    setState(() {
      showGoToCart = true;
      isAlreadyInCart = !isAlreadyInCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (isAddedToCart) {
          pushScreen(
            context,
            screen: const CartPage(
              fromProducts: true,
            ),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        } else {
          setState(
            () {
              isAddedToCart = !isAddedToCart;
              showText = !showText;

              if (isAddedToCart) {
                animationController.reset();
                animationController.forward();
              }
            },
          );

          await ProductService().toggleCart(widget.productId);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(12),
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: !isAddedToCart || isAlreadyInCart
              ? Theme.of(context).colorScheme.secondary
              : Colors.green,
          border: Border.all(
            color: !isAddedToCart || isAlreadyInCart
                ? Theme.of(context).colorScheme.onSecondaryContainer
                : Colors.green.shade600,
          ),
        ),
        child: !isAddedToCart && !isAlreadyInCart
            ? addToCartButton(context)
            : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 500,
                      ),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      child: !isAlreadyInCart
                          ? showText
                              ? showGoToCart
                                  ? goToCartButton(context)
                                  : addedToCartText(context)
                              : addingToCartAnimation(
                                  context,
                                  animationController,
                                )
                          : goToCartButton(context),
                    ),
                    const Gap(12),
                  ],
                ),
              ),
      ),
    );
  }
}

Widget addToCartButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Add to cart",
        style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget addingToCartAnimation(
    BuildContext context, AnimationController animationController) {
  return Transform.scale(
    scale: 2.5,
    child: Lottie.asset(
      "assets/lottie/added_to_cart_1.json",
      key: const ValueKey("lottie"),
      fit: BoxFit.contain,
      controller: animationController,
      onLoaded: (composition) {
        animationController.duration = composition.duration;
        animationController.forward();
      },
      repeat: false,
    ),
  );
}

Widget addedToCartText(BuildContext context) {
  return Row(
    children: [
      Text(
        "Added to cart",
        key: const ValueKey("text"),
        style: GoogleFonts.lato(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const Gap(4),
      Transform.scale(
        scale: 1.2,
        child: Lottie.asset(
          "assets/lottie/green_tick.json",
          repeat: false,
        ),
      ),
    ],
  );
}

Widget goToCartButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Go to cart",
        style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
