import 'package:flutter/material.dart';

import '../models/recommendations.model.dart';

class RecommendationsBlock extends StatefulWidget {
  final List<Recommendations> recommendations;

  const RecommendationsBlock(this.recommendations, {super.key});

  @override
  State<RecommendationsBlock> createState() => _RecommendationsBlockState();
}

class _RecommendationsBlockState extends State<RecommendationsBlock> {
  void _showDetailsBottomSheet(
      BuildContext context, Recommendations recommendation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final double bottomSheetHeight = screenHeight * 0.5;

        return SizedBox(
          height: bottomSheetHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(recommendation.imageURL,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 200),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recommendation.productName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                    Text(recommendation.description,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("Назначение: ${recommendation.purpose}"),
                    Text("Бренд: ${recommendation.brand}"),
                    if (recommendation.hairType != null)
                      Text("Тип волос: ${recommendation.hairType}"),
                    if (recommendation.skinType != null)
                      Text("Тип кожи: ${recommendation.skinType}"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.recommendations.isNotEmpty
            ? [
                const Text(
                  'Рекомендации',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.recommendations?.length ?? 1,
                  itemBuilder: (context, index) {
                    final recommendation = widget.recommendations?[index];

                    return GestureDetector(
                      onTap: () =>
                          _showDetailsBottomSheet(context, recommendation!),
                      child: SizedBox(
                        height: 400,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          child: Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                  child: Image.network(
                                    recommendation?.imageURL ??
                                        'https://www.abeautyedit.com/wp-content/uploads/2021/06/heimish-all-clean-white-clay-foam-all-clean-balm-green-clay-foam.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recommendation?.productName ??
                                            "Product name",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Назначение: ${recommendation?.purpose}',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        'Бренд: ${recommendation?.brand}',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                      if (recommendation?.hairType != null)
                                        Text(
                                          'Тип волос: ${recommendation?.hairType}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                          textAlign: TextAlign.left,
                                        ),
                                      if (recommendation?.skinType != null)
                                        Text(
                                          'Тип кожи: ${recommendation?.skinType}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                          textAlign: TextAlign.left,
                                        )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ]
            : [],
      ),
    );
  }
}
