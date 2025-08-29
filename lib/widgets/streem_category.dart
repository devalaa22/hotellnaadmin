import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:edarhalfnadig/models/model.dart';
import 'package:edarhalfnadig/shared/shared.dart';
import 'package:edarhalfnadig/widgets/grid_view.dart';
import 'package:edarhalfnadig/widgets/widgets.dart';

// ignore: must_be_immutable
class StreemCategory extends StatelessWidget {
  final CategoryModel? categoryModel;
  final AdminModel? userModel;
  final String collection;
  final bool isOffer;
  List<DepModel> imageList;
  List<RoomModel> roomsList;
  List<RoomModel> roomsOffersList;
  List<CategoryModel> categoriesOffersList;
  StreemCategory({
    super.key,
    this.categoryModel,
    this.userModel,
    required this.isOffer,
    required this.collection,
    this.imageList = const [],
    this.roomsList = const [],
    this.roomsOffersList = const [],
    this.categoriesOffersList = const [],
  });

  @override
  Widget build(BuildContext context) {
    bool isHotel = (type == 'hotels');
    bool isFloor = (type == 'floors');

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(isOffer ? Iconly_Broken.Document : Iconly_Broken.Home),
        title: DefaultText(
          text: isOffer
              ? "العروض"
              : isHotel
                  ? "الغرف"
                  : isFloor
                      ? "صور الشقة"
                      : "صور الصالة",
          isHedline6: true,
          isStart: true,
        ),
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.all(8),
        children: [
          StreamBuilder(
              stream: isOffer && !isHotel
                  ? FirebaseFirestore.instance
                      .collection(type!)
                      .where('adminUid', isEqualTo: adminUid)
                      .where('isOffer', isEqualTo: true)
                      .snapshots()
                  : isOffer && isHotel
                      ? FirebaseFirestore.instance
                          .collection(type!)
                          .doc(thisCategoryUid)
                          .collection(collection)
                          .where('isOffer', isEqualTo: true)
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection(type!)
                          .doc(thisCategoryUid)
                          .collection(collection)
                          .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  imageList = [];
                  roomsList = [];
                  categoriesOffersList = [];
                  roomsOffersList = [];
                  snapshot.data.docs.forEach((element) {
                    if (isOffer && !isHotel) {
                      categoriesOffersList.add(CategoryModel.fromJson(
                          element.data() as Map<String, dynamic>));
                    } else if (isOffer && isHotel) {
                      roomsOffersList.add(RoomModel.fromJson(
                          element.data() as Map<String, dynamic>));
                    } else if (isHotel && !isOffer) {
                      roomsList.add(RoomModel.fromJson(
                          element.data() as Map<String, dynamic>));
                    } else {
                      imageList.add(DepModel.fromJson(
                          element.data() as Map<String, dynamic>));
                    }
                  });
                  return snapshot.hasData == true && imageList.isNotEmpty ||
                          roomsList.isNotEmpty ||
                          categoriesOffersList.isNotEmpty ||
                          roomsOffersList.isNotEmpty
                      ? Column(
                          children: [
                            CategoreiGridView(
                              isOffer: isOffer,
                              isHotel: isHotel,
                              roomsList: roomsList,
                              imageList: imageList,
                              isFloor: isFloor,
                              categoryModel: categoryModel!,
                              categoriesOffersList: categoriesOffersList,
                              roomsOffersList: roomsOffersList,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Center(
                              child: DefaultText(
                                text: 'لا توجد ${isOffer ? 'عروض' : 'بيانات'}',
                                h2size: 20,
                              ),
                            )
                          ],
                        );
                }
              }),
        ],
      ),
    );
  }
}
