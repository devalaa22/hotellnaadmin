import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edarhalfnadig/cubit/cubit.dart';
import 'package:edarhalfnadig/cubit/states.dart';
import 'package:edarhalfnadig/screens/login_screen.dart';
import 'package:edarhalfnadig/screens/screens.dart';
import 'package:edarhalfnadig/shared/cache_helper.dart';
import 'package:edarhalfnadig/shared/colors.dart';
import 'package:edarhalfnadig/shared/components.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<List<String>> headline = [
    [
      'أهلا بك في فندقك',
      'تواصل مع الدعم الفني',
      'مشاهد جميلة',
    ],
    [
      'قارن أسعار الفنادق من مئات مواقع السفر واحصل على صفقات رائعة.',
      'نمنح الضيوف خدمة لا تشوبها شائبة من خلال دعم الفندق',
      'أروع مناظر غرف الفنادق التي ستجدها في أي مكان',
    ],
  ];

  bool isLast = false;

  PageController onBoardingController = PageController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return state is OnBoardingLoadingState
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : cubit.onBoardingList.isEmpty
                  ? Scaffold(
                      extendBodyBehindAppBar: true,
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      body: SizedBox(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        child: Positioned(
                            bottom: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  defaultButton(
                                      context: context,
                                      width: size.width - 20,
                                      function: () {
                                        CacheHelper.saveData(
                                                key: 'ShowOnBoard',
                                                value: false)
                                            .then((value) {
                                          if (value) {
                                            navigateAndReplacement(
                                                context, LoginScreen());
                                          }
                                        });
                                      },
                                      text: 'تسجيل الدخول'),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    )
                  : PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (value) {
                        if (value == cubit.onBoardingList.length - 1) {
                          setState(() {
                            isLast = true;
                          });
                        } else if (cubit.onBoardingList.length == 1) {
                          setState(() {
                            isLast = true;
                          });
                        } else {
                          setState(() {
                            isLast = false;
                          });
                        }
                      },
                      controller: onBoardingController,
                      itemCount: cubit.onBoardingList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (_, index) {
                        return Scaffold(
                          extendBodyBehindAppBar: true,
                          appBar: AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            actions: [
                              if (!isLast)
                                TextButton(
                                  onPressed: () {
                                    onBoardingController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                  child: const Text(
                                    'التالي',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ),
                            ],
                          ),
                          body: SizedBox(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            child: Stack(
                              children: [
                                cacheImage(
                                  url: cubit.onBoardingList[index].imageUrl!,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                Container(
                                  color: Colors.black.withOpacity(0.3),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 8.0,
                                      left: 8,
                                      top: 120,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    cubit.onBoardingList[index]
                                                            .title ??
                                                        headline[0][index],
                                                    style: const TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    maxLines: 2,
                                                    textDirection:
                                                        TextDirection.rtl,
                                                  ),
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  Text(
                                                    cubit.onBoardingList[index]
                                                            .subTitle ??
                                                        headline[1][index],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                    textDirection:
                                                        TextDirection.rtl,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 80,
                                        ),
                                        Column(
                                          children: List.generate(
                                              cubit.onBoardingList.length,
                                              (indexDots) => Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 2),
                                                    width: 8,
                                                    height: index == indexDots
                                                        ? 25
                                                        : 12,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: index == indexDots
                                                          ? mainColor
                                                          : mainColor.shade100,
                                                    ),
                                                  )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isLast)
                                  Positioned(
                                      bottom: 100,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            defaultButton(
                                                context: context,
                                                width: size.width - 20,
                                                function: () {
                                                  CacheHelper.saveData(
                                                          key: 'ShowOnBoard',
                                                          value: false)
                                                      .then((value) {
                                                    if (value) {
                                                      navigateAndReplacement(
                                                          context,
                                                          LoginScreen());
                                                    }
                                                  });
                                                },
                                                text: 'تسجيل الدخول'),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      )),
                              ],
                            ),
                          ),
                        );
                      },
                    );
        });
  }
}
