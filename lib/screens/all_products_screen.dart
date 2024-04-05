import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping_admin_panel/models/product_model.dart';
import 'package:easy_shopping_admin_panel/screens/add_products_screen.dart';
import 'package:easy_shopping_admin_panel/screens/product_detail_screen.dart';
import 'package:easy_shopping_admin_panel/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Products"),
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => AddProductScreen()),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.add),
            ),
          )
        ],
        backgroundColor: AppConstant.appMainColor,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdAt', descending: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text('Error occurred while fetching products!'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Container(
              child: Center(
                child: Text('No products found!'),
              ),
            );
          }

          if (snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                final productData = snapshot.data!.docs[index];

                List<String> productImages = [];
                if (productData['productImages'] != null && productData['productImages'] is List<dynamic>) {
                  productImages = List<String>.from(productData['productImages'].map((image) => image.toString()));
                } else {
                  productImages = ['']; // Provide default image if productImages is null or not a list
                }

                ProductModel productModel = ProductModel(
                  productId: data['productId'],
                  categoryId: data['categoryId'],
                  productName: data['productName'],
                  categoryName: data['categoryName'],
                  salePrice: data['salePrice'],
                  fullPrice: data['fullPrice'],
                  productImages: productImages,
                  deliveryTime: data['deliveryTime'],
                  isSale: data['isSale'] == null ? false : data['isSale'] == 'true',
                  createdAt: data['createdAt'],
                  updatedAt: data['updatedAt'],
                );

                return Card(
                  elevation: 5,
                  child: ListTile(
                    onTap: () {
                      Get.to(() => SingleProductDetailScreen(
                          productModel: productModel));
                    },
                    leading: CircleAvatar(
                      backgroundColor: AppConstant.appScendoryColor,
                      backgroundImage: CachedNetworkImageProvider(
                        productModel.productImages.isNotEmpty ? productModel.productImages[0] : '',
                        errorListener: (err) {
                          // Handle the error here
                          print('Error loading image');
                          Icon(Icons.error);
                        },
                      ),
                    ),
                    title: Text(productModel.productName),
                    subtitle: Text(productModel.productId),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            );
          } else {
            return Container(
              child: Center(
                child: Text('No products found!'),
              ),
            );
          }
        },
      ),
    );
  }
}
