import 'package:flutter/material.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_cubit.dart';
import 'package:edarhalfnadig/models/model.dart';
import 'package:edarhalfnadig/screens/image_view_screen.dart';
import 'package:edarhalfnadig/screens/room_detail_screen.dart';
import 'package:edarhalfnadig/shared/shared.dart';
import 'package:edarhalfnadig/widgets/widgets.dart';

class CategoreiGridView extends StatelessWidget {
  const CategoreiGridView({
    super.key,
    required this.isOffer,
    required this.isHotel,
    required this.roomsList,
    required this.imageList,
    required this.isFloor,
    required this.categoryModel,
    required this.roomsOffersList,
    required this.categoriesOffersList,
  });

  final bool isHotel;
  final bool isOffer;
  final List<RoomModel> roomsList;
  final List<DepModel> imageList;
  final bool isFloor;
  final CategoryModel categoryModel;
  final List<RoomModel> roomsOffersList;
  final List<CategoryModel> categoriesOffersList;
  @override
  Widget build(BuildContext context) {
    var cubit = AdminCubit.get(context);
    if (!isOffer) {
      type != 'hotels'
          ? cubit.categoryImages = imageList[0].img!.cast<String>()
          : null;
    }
    return GridView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 0, right: 0, left: 0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: isOffer && isHotel
          ? roomsOffersList.length
          : isOffer && !isHotel
              ? categoriesOffersList.length
              : isHotel
                  ? roomsList.length
                  : imageList[0].img!.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 260.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        // print();
        return GestureDetector(
          onTap: () {
            if (isOffer) {
              if (isHotel) {
                navigateTo(
                    context,
                    RoomDetailScreen(
                      room: roomsOffersList[index],
                    ));
              }
            } else {
              if (!isHotel) {
                navigateTo(
                  context,
                  ImageViewScreen(
                    image: isFloor && imageList.isNotEmpty
                        ? imageList[0].img![index]
                        : !isFloor && !isHotel
                            ? imageList[0].img![index]
                            : 'assets/room.jpeg',
                  ),
                );
              }

              if (isHotel) {
                navigateTo(
                    context,
                    RoomDetailScreen(
                      room: roomsList[index],
                    ));
              }
            }
          },
          child: Card(
            child: !isHotel && !isOffer
                ? Stack(
                    children: [
                      cacheImage(
                        url: isFloor && imageList.isNotEmpty
                            ? imageList[0].img![index]
                            : imageList[0].img![index],
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      if (!isOffer)
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BaseAlertDialog(
                                  title: "حذف",
                                  content: "هل تريد الحذف",
                                  yesOnPressed: () {
                                    cubit.categoryImages!.removeAt(index);
                                    Future.delayed(const Duration(seconds: 1))
                                        .whenComplete(() =>
                                            cubit.updateCategoryImages(
                                                categoryImages:
                                                    cubit.categoryImages))
                                        .whenComplete(
                                            () => Navigator.pop(context));

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'تم الحذف بنجاح',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                                  },
                                  noOnPressed: () {
                                    Navigator.pop(context);
                                  },
                                  yes: "نعم",
                                  no: "لا",
                                  yesColor: Colors.red,
                                  noColor: Colors.grey,
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      cacheImage(
                        url: isOffer && categoriesOffersList.isNotEmpty
                            ? categoriesOffersList[index].imgAssetPath!
                            : isOffer &&
                                    roomsOffersList[index].roomImage!.isNotEmpty
                                ? roomsOffersList[index].roomImage![0]
                                : isHotel &&
                                        roomsList[index].roomImage!.isNotEmpty
                                    ? roomsList[index].roomImage![0]
                                    : isFloor
                                        ? imageList[0].img![index]
                                        : imageList[0].img![index],
                        width: double.infinity,
                        height: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 4.0),
                        child: Text(
                          isOffer && !isHotel
                              ? categoriesOffersList[index].name!
                              : isOffer && isHotel
                                  ? roomsOffersList[index].name!
                                  : roomsList[index].name!,
                          textDirection: TextDirection.rtl,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
          ),
        );
      },
    );
  }
}
