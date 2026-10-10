import 'package:flutter/material.dart';

class FeatureList extends StatelessWidget {
  const FeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> featureIcons = [
      "assets/icons/1.png",
      "assets/icons/2.png",
      "assets/icons/3.png",
      "assets/icons/4.png",
      "assets/icons/5.png",
      "assets/icons/6.png",
      "assets/icons/7.png",
      "assets/icons/8.png",
      "assets/icons/9.png",
      "assets/icons/10.png",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemCount: featureIcons.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // TODO: Implement navigation
            },
            child: Container(
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Color(0xFF33724B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  // ignore: deprecated_member_use
                  color: Color(0xFF33724B).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  featureIcons[index],
                  color: Color(0xFF33724B),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}