import 'package:flutter/material.dart';
import 'package:edarhalfnadig/models/model.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key, required this.reviews});
  final List<ReviewModel> reviews;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('التقييمات'),
        ),
        body: reviews.isEmpty
            ? const Center(
                child: Text('لا توجد تقييمات حتى الآن'),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${reviews.length}  مقيم من',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(fontSize: 16),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reviews.length,
                        itemBuilder: (BuildContext context, int index) {
                          ReviewModel ratingModel = reviews[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    SmoothStarRating(
                                      size: 40,
                                      rating: double.parse(ratingModel.rating!),
                                      color: Colors.yellow[700],
                                      borderColor: Colors.grey,
                                      filledIconData: Icons.star,
                                      halfFilledIconData: Icons.star_half,
                                      defaultIconData: Icons.star_border,
                                      starCount: 5,
                                      allowHalfRating: false,
                                      spacing: 2.0,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  ratingModel.comment!,
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      ratingModel.name!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                    const Spacer(),
                                    Text(
                                      ratingModel.dateTime ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ));
  }
}
