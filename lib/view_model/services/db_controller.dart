// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:future_green_world/models/question.dart';
import 'package:get/get.dart';

import '../../models/user.dart';
import '../../res/components/custom_snackbar.dart';
import '../../res/components/loading.dart';
import '../../res/controller/controller_instances.dart';

class DatabaseController extends GetxController {
  static DatabaseController instance = Get.find();

// *    POST CALLS

  /// Add User
  Future addUser(UserModel user, BuildContext context) async {
    try {
      var ref =
          firestore.collection("users").doc(authController.getCurrentUser());
      await ref.set(user.toMap());
    } on FirebaseException catch (e) {
      Get.back();
      showErrorSnackbar(
        e.message ?? "Something went wrong, please try again",
        context,
      );
    }
  }

  /// Update User
  Future updateUser(String name, BuildContext context) async {
    try {
      loadingDialog("Updating User...");
      var ref =
          firestore.collection("users").doc(authController.getCurrentUser());
      await ref.update({
        "name": name,
      }).then((value) => {
            Get.close(1),
            showMessageSnackbar(
              "Profile updated Successfully",
              context,
            )
          });
    } on FirebaseException catch (e) {
      Get.back();
      showErrorSnackbar(
        e.message ?? "Something went wrong, please try again",
        context,
      );
    }
  }

  /// Update Trial
  Future updateTrial(String id) async {
    try {
      var ref = firestore.collection("exams").doc(id);
      await ref.update({
        "trialEnd": FieldValue.arrayUnion([authController.getCurrentUser()]),
      });
    } on FirebaseException {
      //Get.back();
    }
  }

  /// questions Attempted
  Future questionAttempted(String id, int index, bool isCorrect,
      String chapterId, BuildContext context) async {
    loadingDialog("Validating...");
    try {
      var ref = firestore.collection("questions").doc(id);
      await ref.update({
        "attempted": FieldValue.arrayUnion([
          AttemptedModel(
                  uid: authController.getCurrentUser(), selectedIndex: index)
              .toMap()
        ]),
      }).then((_) {
        firestore
            .collection("chapters")
            .doc(chapterId)
            .collection("participants")
            .doc(authController.getCurrentUser())
            .get()
            .then((value) {
          if (value.exists) {
            firestore
                .collection("chapters")
                .doc(chapterId)
                .collection("participants")
                .doc(authController.getCurrentUser())
                .update({
              "attempted": FieldValue.increment(1),
              "correct": FieldValue.increment(isCorrect ? 1 : 0),
            });
          } else {
            firestore.collection("chapters").doc(chapterId).update({
              "participants":
                  FieldValue.arrayUnion([authController.getCurrentUser()])
            });
            firestore
                .collection("chapters")
                .doc(chapterId)
                .collection("participants")
                .doc(authController.getCurrentUser())
                .set({
              "attempted": 1,
              "correct": isCorrect ? 1 : 0,
              "uid": authController.getCurrentUser()
            });
          }
        }).then((_) => Get.close(1));
      });
    } on FirebaseException catch (e) {
      Get.back();
      showErrorSnackbar(
        e.message ?? "Something went wrong, please try again",
        context,
      );
    }
  }

//   /// Upload Image to firebase
  // Future uploadImageToFirebase(BuildContext context) async {
  //   File? img;
  //   try {
  //     ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
  //       if (value != null) {
  //         img = File(value.path);
  //         String fileName = authController.getCurrentUser();
  //         Reference firebaseStorageRef =
  //             FirebaseStorage.instance.ref().child("profileImages/$fileName");
  //         UploadTask uploadTask = firebaseStorageRef.putFile(img!);
  //         try {
  //           loadingDialog("Uploading...");
  //           uploadTask.whenComplete(() async {
  //             var ref = firestore.collection("users").doc(fileName);
  //             await ref.update({
  //               "image": await firebaseStorageRef.getDownloadURL()
  //             }).then((value) => {
  //                   Get.back(),
  //                   showMessageSnackbar(
  //                       context, "Profile picture updated Successfully")
  //                 });
  //           });
  //         } on FirebaseException catch (e) {
  //           Get.back();
  //           showErrorSnackbar(
  //               context, e.message ?? "Something went wrong, please try again");
  //         }
  //       }
  //     });
  //   } on PlatformException catch (e) {
  //     log(e.message.toString());
  //     Get.back();
  //   }
  // }

  // /// Add Project
  // Future addProject(
  //     String name,
  //     String city,
  //     String shortDetail,
  //     String detail,
  //     File img,
  //     String serving,
  //     String budgetDetails,
  //     String groundFacts,
  //     BuildContext context) async {
  //   loadingDialog("Adding Project...");
  //   String fileName = const Uuid().v4();
  //   Reference firebaseStorageRef =
  //       FirebaseStorage.instance.ref().child("projects/$fileName");
  //   UploadTask uploadTask = firebaseStorageRef.putFile(img);
  //   try {
  //     uploadTask.whenComplete(() async {
  //       var ref = firestore.collection("projects").doc(fileName);
  //       await ref.set({
  //         'id': fileName,
  //         "name": name,
  //         "details": detail,
  //         'voters': [],
  //         'cons': 0,
  //         'serving': serving,
  //         'budgetDetails': budgetDetails,
  //         'groundFacts': groundFacts,
  //         'wishList': [],
  //         'myVote': [],
  //         "shortDetail": shortDetail,
  //         "city": city,
  //         'pros': 0,
  //         "email": authController.getUserEmail(),
  //         "uid": authController.getCurrentUser(),
  //         "image": await firebaseStorageRef.getDownloadURL(),
  //         "timestamp": DateTime.now()
  //       }).then((value) => {
  //             firestore
  //                 .collection("users")
  //                 .doc(authController.getCurrentUser())
  //                 .update({
  //               "projects": FieldValue.increment(1),
  //             }),
  //             Get.close(2),
  //             showMessageSnackbar(context, "Project Added Successfully")
  //           });
  //     });
  //   } on FirebaseException catch (e) {
  //     Get.back();
  //     showErrorSnackbar(
  //         context, e.message ?? "Something went wrong, please try again");
  //   }
  // }

  // /// Add Statement
  // Future addStatement(String statement, BuildContext context) async {
  //   loadingDialog("Adding Statement...");
  //   String fileName = const Uuid().v4();
  //   try {
  //     var ref = firestore.collection("statements").doc(fileName);
  //     await ref.set({
  //       'id': fileName,
  //       "statement": statement,
  //       'voters': [],
  //       'cons': 0,
  //       'wishList': [],
  //       'myVote': [],
  //       'pros': 0,
  //       "email": authController.getUserEmail(),
  //       "uid": authController.getCurrentUser(),
  //       "timestamp": DateTime.now()
  //     }).then((value) => {
  //           Get.close(2),
  //           showMessageSnackbar(context, "Project Added Successfully")
  //         });
  //   } on FirebaseException catch (e) {
  //     Get.back();
  //     showErrorSnackbar(
  //         context, e.message ?? "Something went wrong, please try again");
  //   }
  // }

  // /// Add Event
  // Future addEvent(CalenderEventModel event, BuildContext context) async {
  //   loadingDialog("Adding Event...");
  //   try {
  //     var ref = firestore.collection("events").doc(event.id);
  //     await ref.set(event.toMap()).then((value) => {
  //           Get.close(2),
  //           showMessageSnackbar(context, "Event Added Successfully")
  //         });
  //   } on FirebaseException catch (e) {
  //     Get.back();
  //     showErrorSnackbar(
  //         context, e.message ?? "Something went wrong, please try again");
  //   }
  // }

//   /// Like / Unlike Product
//   Future likeProduct(String productId, bool liked, BuildContext context) async {
//     try {
//       var ref = firestore.collection("products").doc(productId);
//       await ref.update({
//         "favourites": liked
//             ? FieldValue.arrayRemove([authController.getCurrentUser()])
//             : FieldValue.arrayUnion([authController.getCurrentUser()])
//       });
//     } on FirebaseException catch (e) {
//       Get.back();
//       showErrorSnackbar(
//           context, e.message ?? "Something went wrong, please try again");
//     }
//   }

//   /// Add to cart
//   Future addToCart(CartItemModel item, BuildContext context) async {
//     try {
//       var ref = firestore
//           .collection("users")
//           .doc(authController.getCurrentUser())
//           .collection("myCart")
//           .doc(item.id);
//       await ref.set(item.toMap()).then((value) =>
//           {Get.close(1), showMessageSnackbar(context, "Item Added to Cart")});
//     } on FirebaseException catch (e) {
//       Get.back();
//       showErrorSnackbar(
//           context, e.message ?? "Something went wrong, please try again");
//     }
//   }

//   /// Remove From Cart
//   Future removeFromCart(String id, BuildContext context) async {
//     try {
//       var ref = firestore
//           .collection("users")
//           .doc(authController.getCurrentUser())
//           .collection("myCart")
//           .doc(id);
//       await ref.delete().then((value) =>
//           {Get.close(2), showErrorSnackbar(context, "Item removed from cart")});
//     } on FirebaseException catch (e) {
//       Get.back();
//       showErrorSnackbar(
//           context, e.message ?? "Something went wrong, please try again");
//     }
//   }

//   /// update Quantity
//   Future updateQuantity(
//       CartItemModel cartItem, bool increment, BuildContext context) async {
//     try {
//       var ref = firestore
//           .collection("users")
//           .doc(authController.getCurrentUser())
//           .collection("myCart")
//           .doc(cartItem.id);
//       await ref.update({
//         "total": increment
//             ? cartItem.total + cartItem.price
//             : cartItem.total - cartItem.price,
//         "quantity": increment ? cartItem.quantity + 1 : cartItem.quantity - 1
//       }).then((value) => Get.close(1));
//     } on FirebaseException catch (e) {
//       Get.back();
//       showErrorSnackbar(
//           context, e.message ?? "Something went wrong, please try again");
//     }
//   }

//   /// Add Address
//   Future addNewAddress(
//       AddressModel address, bool setAsDefault, BuildContext context) async {
//     try {
//       var ref =
//           firestore.collection("users").doc(authController.getCurrentUser());
//       await ref.update({
//         "address": FieldValue.arrayUnion([address.toMap()])
//       }).then((value) {
//         if (setAsDefault) {
//           ref.update({"defaultAddress": address.id}).then(
//               (value) => Get.close(2));
//         } else {
//           Get.close(2);
//         }
//       });
//     } on FirebaseException catch (e) {
//       Get.back();
//       showErrorSnackbar(
//           context, e.message ?? "Something went wrong, please try again");
//     }
//   }

//   /// Add Address
//   Future deleteAddress(
//       AddressModel address, bool isDefault, BuildContext context) async {
//     try {
//       loadingDialog("Deleting...");
//       var ref =
//           firestore.collection("users").doc(authController.getCurrentUser());
//       await ref.update({
//         "address": FieldValue.arrayRemove([address.toMap()])
//       }).then((value) {
//         if (isDefault) {
//           ref.update({"defaultAddress": ''}).then((value) => Get.close(2));
//         } else {
//           Get.close(2);
//         }
//       });
//     } on FirebaseException catch (e) {
//       Get.back();
//       showErrorSnackbar(
//           context, e.message ?? "Something went wrong, please try again");
//     }
//   }

//   /// Set Default Address
//   Future setDefaultAddress(
//       AddressModel address, bool isCheckout, BuildContext context) async {
//     loadingDialog("Updating...");
//     try {
//       var ref =
//           firestore.collection("users").doc(authController.getCurrentUser());
//       await ref.update({"defaultAddress": address.id}).then((value) => {
//             Get.close(isCheckout ? 2 : 1),
//             showMessageSnackbar(context, "Address selected as default")
//           });
//     } on FirebaseException catch (e) {
//       Get.back();
//       showErrorSnackbar(
//           context, e.message ?? "Something went wrong, please try again");
//     }
//   }

//   /// update coupon after order placed
//   Future updateCouponData(String id, BuildContext context) async {
//     try {
//       var ref = firestore.collection("coupons").doc(id);
//       await ref.update({
//         "usedBy": FieldValue.arrayUnion(
//           [authController.getCurrentUser()],
//         )
//       });
//     } on FirebaseException catch (e) {
//       Get.back();
//       showErrorSnackbar(
//           context, e.message ?? "Something went wrong, please try again");
//     }
//   }

//   /// Set add Review
//   Future addReview(
//       Reviews review, List<String> productId, BuildContext context) async {
//     loadingDialog("Submitting Review...");
//     try {
//       var ref = firestore.collection("orders").doc(review.orderId);
//       await ref.update({
//         "reviewed": true,
//         "review": review.reviewDetail,
//         "rating": review.rating
//       }).then((value) async {
//         for (String id in productId) {
//           await firestore
//               .collection("products")
//               .doc(id)
//               .get()
//               .then((product) async {
//             await firestore.collection("products").doc(id).update({
//               "totalReviews": product["totalReviews"] + 1,
//               "rating": ((product["rating"] * product["totalReviews"]) +
//                       review.rating) /
//                   (product["totalReviews"] + 1)
//             });
//           });
//           await firestore
//               .collection("products")
//               .doc(id)
//               .collection("reviews")
//               .doc(review.orderId)
//               .set(review.toMap());
//         }
//         Get.close(2);
//         // ignore: use_build_context_synchronously
//         showMessageSnackbar(context, "Review Submitted!");
//       });
//     } on FirebaseException catch (e) {
//       Get.back();
//       showErrorSnackbar(
//           context, e.message ?? "Something went wrong, please try again");
//     }
//   }

//   /// Place Order
//   Future placeOrder(
//       String orderId,
//       List<CartItemModel> cartItems,
//       double subtotal,
//       double shipping,
//       double discount,
//       double total,
//       AddressModel address,
//       String promo,
//       bool paymentDone,
//       String paymentOption,
//       BuildContext context) async {
//     try {
//       var orders =
//           firestore.collection("orders").orderBy("orderNo", descending: true);
//       var ref = firestore.collection("orders").doc(orderId);
//       await orders.get().then((value) async {
//         await ref.set({
//           "orderId": orderId,
//           "orderNo": value.docs.isEmpty ? 1001 : value.docs[0]["orderNo"] + 1,
//           "uid": authController.getCurrentUser(),
//           "subtotal": subtotal,
//           "shipping": shipping,
//           "discount": discount,
//           "total": total,
//           "paymentOption": paymentOption,
//           "paymentDone": paymentDone,
//           "status": "Pending",
//           "reviewed": false,
//           'review': '',
//           "rating": 0,
//           "address": address.toMap(),
//           "timestamp": DateTime.now(),
//           "acceptedDate": DateTime.now(),
//           "shippedDate": DateTime.now(),
//           "deliveredDate": DateTime.now(),
//         }).then((_) async {
//           for (CartItemModel item in cartItems) {
//             await ref.collection("items").doc(item.id).set(item.toMap());
//           }

//           var cartRef = firestore
//               .collection("users")
//               .doc(authController.getCurrentUser())
//               .collection("myCart");

//           await cartRef.get().then((cart) async {
//             for (DocumentSnapshot ds in cart.docs) {
//               await ds.reference.delete();
//             }
//           });
//           Get.to(() => OrderConfirm(
//                 orderNo:
//                     value.docs.isEmpty ? 1001 : value.docs[0]["orderNo"] + 1,
//               ));
//         });
//       });
//     } on FirebaseException catch (e) {
//       Get.back();
//       showErrorSnackbar(
//           context, e.message ?? "Something went wrong, please try again");
//     }
//   }

// ////////////////////////////    GET CALLS    ////////////////////////////

//   /// get Single Product
//   Stream<ProductModel> getSingleProduct(String productId) {
//     var ref = firestore.collection('products').doc(productId);
//     try {
//       return ref.snapshots().map((e) => ProductModel.fromMap(e));
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref.snapshots().map((e) => ProductModel.fromMap(e));
//     }
//   }

//   /// get Categories
//   Stream<List<CategoryModel>> getCategories() {
//     var ref = firestore.collection('categories').orderBy("priority");
//     try {
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => CategoryModel.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => CategoryModel.fromMap(e)).toList());
//     }
//   }

//   /// get All Products
//   Stream<List<ProductModel>> getAllProducts() {
//     var ref = firestore.collection('products');
//     try {
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => ProductModel.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => ProductModel.fromMap(e)).toList());
//     }
//   }

//   /// get Popular Products
//   Stream<List<ProductModel>> getPopularProducts() {
//     var ref =
//         firestore.collection('products').where("isPopular", isEqualTo: true);
//     try {
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => ProductModel.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => ProductModel.fromMap(e)).toList());
//     }
//   }

//   /// get DOTD Products
//   Stream<List<ProductModel>> getDOTDProducts() {
//     var ref =
//         firestore.collection('products').where("dealOfTheDay", isEqualTo: true);
//     try {
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => ProductModel.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => ProductModel.fromMap(e)).toList());
//     }
//   }

//   /// get Hot Selling Products
//   Stream<List<ProductModel>> getHotSellingProducts() {
//     var ref =
//         firestore.collection('products').where("hotSelling", isEqualTo: true);
//     try {
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => ProductModel.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => ProductModel.fromMap(e)).toList());
//     }
//   }

//   /// get all subcategories
//   Stream<List<SubCategoryModel>> getAllSubCategories(String category) {
//     var ref = firestore
//         .collection('subcategories')
//         .where("category", isEqualTo: category)
//         .orderBy("filterTag");
//     try {
//       return ref.snapshots().map((event) =>
//           event.docs.map((e) => SubCategoryModel.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref.snapshots().map((event) =>
//           event.docs.map((e) => SubCategoryModel.fromMap(e)).toList());
//     }
//   }

//   /// get filtered subcategories
//   Stream<List<SubCategoryModel>> getFilteredSubCategories(
//       String category, String filterTag) {
//     var ref = firestore
//         .collection('subcategories')
//         .where("category", isEqualTo: category)
//         .where("filterTag", isEqualTo: filterTag);
//     try {
//       return ref.snapshots().map((event) =>
//           event.docs.map((e) => SubCategoryModel.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref.snapshots().map((event) =>
//           event.docs.map((e) => SubCategoryModel.fromMap(e)).toList());
//     }
//   }

//   /// get Subcategory Products
//   Stream<List<ProductModel>> getSubcategoryProducts(
//       String category, String subcategory) {
//     var ref = firestore
//         .collection('products')
//         .where("category", isEqualTo: category)
//         .where("subCategory", isEqualTo: subcategory);
//     try {
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => ProductModel.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => ProductModel.fromMap(e)).toList());
//     }
//   }

//   /// get my CART
//   Stream<List<CartItemModel>> getMyCart() {
//     var ref = firestore
//         .collection('users')
//         .doc(authController.getCurrentUser())
//         .collection("myCart");
//     try {
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => CartItemModel.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => CartItemModel.fromMap(e)).toList());
//     }
//   }

//   /// get Wish list products
//   Stream<List<ProductModel>> getWishlistProducts() {
//     var ref = firestore
//         .collection('products')
//         .where("favourites", arrayContains: authController.getCurrentUser());
//     try {
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => ProductModel.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => ProductModel.fromMap(e)).toList());
//     }
//   }

//   /// get ON Going Orders
//   Stream<List<OrderModel>> getOnGoingOrders() {
//     var ref = firestore
//         .collection('orders')
//         .where(
//           "uid",
//           isEqualTo: authController.getCurrentUser(),
//         )
//         .orderBy("orderNo", descending: true);
//     try {
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => OrderModel.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => OrderModel.fromMap(e)).toList());
//     }
//   }

//   /// get Completed Orders
//   Stream<List<OrderModel>> getCompletedOrders() {
//     var ref = firestore
//         .collection('orders')
//         .where("uid", isEqualTo: authController.getCurrentUser())
//         .where("status", isEqualTo: "Delivered")
//         .orderBy("orderNo", descending: true);
//     try {
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => OrderModel.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => OrderModel.fromMap(e)).toList());
//     }
//   }

//   /// get Order Items
//   Stream<List<CartItemModel>> getOrderItems(String orderId) {
//     var ref = firestore.collection('orders').doc(orderId).collection("items");
//     try {
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => CartItemModel.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => CartItemModel.fromMap(e)).toList());
//     }
//   }

//   /// get Coupons
//   Stream<List<CouponModel>> getCoupons() {
//     var ref = firestore
//         .collection('coupons')
//         .where("status", isEqualTo: "Active")
//         .where("validTill", isGreaterThan: Timestamp.fromDate(DateTime.now()));
//     try {
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => CouponModel.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref.snapshots().map(
//           (event) => event.docs.map((e) => CouponModel.fromMap(e)).toList());
//     }
//   }

//   /// get product Reviews
//   Stream<List<Reviews>> getAllReviews(String productId) {
//     var ref =
//         firestore.collection('products').doc(productId).collection("reviews");
//     try {
//       return ref
//           .snapshots()
//           .map((event) => event.docs.map((e) => Reviews.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref
//           .snapshots()
//           .map((event) => event.docs.map((e) => Reviews.fromMap(e)).toList());
//     }
//   }

//   /// get specific rating Reviews
//   Stream<List<Reviews>> getCustomRatingReviews(String productId, int rating) {
//     var ref = firestore
//         .collection('products')
//         .doc(productId)
//         .collection("reviews")
//         .where("rating", isEqualTo: rating);
//     try {
//       return ref
//           .snapshots()
//           .map((event) => event.docs.map((e) => Reviews.fromMap(e)).toList());
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return ref
//           .snapshots()
//           .map((event) => event.docs.map((e) => Reviews.fromMap(e)).toList());
//     }
//   }

//   /// get User Data
//   Stream<UserModel> getUserById(String id) {
//     var data = firestore
//         .collection('users')
//         .doc(id)
//         .snapshots();
//     try {
//       return data.map((event) => UserModel.fromMap(event));
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return data.map((event) => UserModel.fromMap(event));
//     }
//   }

//   /// get User Data
//   Stream<UserModel> getUser() {
//     var data = firestore
//         .collection('users')
//         .doc(authController.getCurrentUser())
//         .snapshots();
//     try {
//       return data.map((event) => UserModel.fromMap(event));
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return data.map((event) => UserModel.fromMap(event));
//     }
//   }

//   /// get User Data
//   Future<UserModel> getUserFuture() async {
//     var data = await firestore
//         .collection('users')
//         .doc(authController.getCurrentUser())
//         .get();
//     try {
//       return UserModel.fromMap(data);
//     } on FirebaseException catch (e) {
//       log(e.message.toString());
//       return UserModel.fromMap(data);
//     }
//   }
}
