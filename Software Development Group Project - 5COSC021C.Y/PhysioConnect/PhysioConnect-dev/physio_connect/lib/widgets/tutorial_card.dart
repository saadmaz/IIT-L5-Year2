import 'package:flutter/material.dart';
import '../models/tutorial_model.dart';

class TutorialCard extends StatelessWidget {
  final TutorialModel tutorial;
  final VoidCallback onTap;

  const TutorialCard({
    super.key,
    required this.tutorial,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasMuscle = tutorial.muscle != null && tutorial.muscle!.isNotEmpty;
    final thumbnailUrl = "https://img.youtube.com/vi/${tutorial.videoId}/0.jpg";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        splashColor: Colors.teal.withOpacity(0.2),
        highlightColor: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(2, 4),
              )
            ],
          ),
          child: Row(
            children: [
              // 🎞 Thumbnail
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(18),
                ),
                child: Image.network(
                  thumbnailUrl,
                  width: 110,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    width: 110,
                    height: 90,
                    child: const Icon(Icons.image_not_supported_rounded,
                        color: Colors.grey),
                  ),
                ),
              ),

              // 📝 Info
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🎯 Title
                      Text(
                        tutorial.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xFF1F6662),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // 🏷 Category
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.teal.shade100),
                        ),
                        child: Text(
                          tutorial.category,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      if (hasMuscle) ...[
                        const SizedBox(height: 6),
                        Text(
                          "Muscle: ${tutorial.muscle}",
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.teal,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
