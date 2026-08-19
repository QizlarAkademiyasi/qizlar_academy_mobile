import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_course_card.dart';

class AiChatCourseCard extends StatelessWidget {
  const AiChatCourseCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  final AiChatCourseModel course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HomeCourseCard(
      course: CourseModel(
        id: course.id,
        title: course.title,
        author: course.mentorName,
        imageUrl: course.imageUrl,
        durationSeconds: (course.durationMinutes ?? 0) * 60,
        studentCount: course.studentCount ?? 0,
      ),
      rating: course.rating,
      reviewsCount: course.totalRatings,
      margin: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}
