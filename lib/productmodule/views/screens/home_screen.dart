import 'package:ecom2/productmodule/controller/product_controller.dart';
import 'package:ecom2/cartmodule/views/screens/cart_page.dart';
import 'package:ecom2/productmodule/views/screens/product_details_page.dart';
import 'package:ecom2/authmodule/views/screens/profile_page.dart';
import 'package:ecom2/wishlistmodule/views/screens/wishlist_page.dart';
import 'package:ecom2/productmodule/views/widgets/carausal_slider.dart';
import 'package:ecom2/productmodule/views/widgets/discount_banner.dart';
import 'package:ecom2/productmodule/views/widgets/productcard.dart';
import 'package:ecom2/productmodule/views/widgets/searchfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:badges/badges.dart' as badges;
import '../../../cartmodule/controllers/cart_controller.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen({super.key});
  final productController = Get.put(ProductController());
  final cartController = Get.put(CartController());
  final searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const ListTile(
          leading: CircleAvatar(
            radius: 15.0,
            backgroundImage: NetworkImage(
                "https://static.vecteezy.com/system/resources/thumbnails/024/326/967/small_2x/woman-hands-in-indian-greeting-pose-namaste-vector.jpg"),
          ),
          title: Text(
            "Hello",
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Let's shop",
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(WishlistPage());
              },
              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
              )),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(),
                ),
              );
            },
            icon: badges.Badge(
              badgeContent: Obx(() => Text(
                    cartController.cartItems.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  )),
              child: const Icon(Icons.shopping_cart, color: Colors.purple),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.person_2_outlined,
                  size: 30,
                  color: Colors.purple,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              Searchfield(
                onSearchTap: () {},
              ),
              const SizedBox(height: 10),
              const DiscountBanner(),
              const SizedBox(height: 10),
              CustomSlider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Category",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(() => DropdownButton<String>(
                        value: productController.selectedCategory.value.isEmpty
                            ? 'All'
                            : productController.selectedCategory.value,
                        items: ['All', ...productController.categories]
                            .map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          productController.selectedCategory.value = value!;
                          productController.filterByCategory(value);
                        },
                      )),
                ],
              ),
              GetX<ProductController>(builder: (controller) {
                return controller.isLoading.value == true
                    ? LoadingAnimationWidget.newtonCradle(
                        color: Colors.purple,
                        size: 100,
                      )
                    : controller.filteredProducts.isEmpty
                        ? const Center(child: Text("No Products Found"))
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.filteredProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 0.7,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            itemBuilder: (context, index) {
                              return ProductCard(
                                rating:
                                    controller.filteredProducts[index].rating!,
                                product: controller.filteredProducts[index],
                                price: controller.filteredProducts[index].price
                                    .toString(),
                                title: controller.filteredProducts[index].title
                                    .toString(),
                                productImageUrl: controller
                                    .filteredProducts[index].thumbnail
                                    .toString(),
                                onPress: () {
                                  Get.to(
                                    ProductDetailsPage(
                                      products:
                                          controller.filteredProducts[index],
                                      productName: controller
                                          .filteredProducts[index].title
                                          .toString(),
                                      productDescription: controller
                                          .filteredProducts[index].description
                                          .toString(),
                                      productPrice: controller
                                          .filteredProducts[index].price
                                          .toString(),
                                      productImage: controller
                                          .filteredProducts[index].thumbnail
                                          .toString(),
                                      images: controller
                                          .filteredProducts[index].images!,
                                      isLoading: controller.isLoading.value,
                                    ),
                                  );
                                },
                              );
                            },
                          );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
