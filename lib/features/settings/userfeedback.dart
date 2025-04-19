import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/features/settings/stars.dart';
import 'package:guideurself/features/settings/feedbackcomment.dart';
import 'package:guideurself/services/feedback.dart';
import 'package:guideurself/services/storage.dart';

class UserFeedback extends StatefulWidget {
  const UserFeedback({super.key});

  @override
  State<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  final storage = StorageService();
  int rating = 0;
  bool isSubmitting = false;
  bool isFeedbackSubmitted = false;

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate() && rating > 0) {
      setState(() {
        isSubmitting = true;
        isFeedbackSubmitted = false;
      });

      try {
        await addFeedback(feedback: _commentController.text, rating: rating);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Thank you for your feedback!",
                style: styleText(
                  context: context,
                  fontSizeOption: 12.0,
                  color: Colors.white,
                ),
              ),
              backgroundColor: const Color(0xFF323232),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }

        storage.saveData(key: "feedback", value: true);
        _commentController.clear();

        if (mounted) {
          FocusScope.of(context).unfocus();
        }

        setState(() {
          rating = 0;
          isFeedbackSubmitted = true;
        });
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "An error occurred while submitting feedback. Please try again later.",
                style: styleText(
                  context: context,
                  fontSizeOption: 12.0,
                  color: Colors.white,
                ),
              ),
              backgroundColor: const Color.fromRGBO(239, 68, 68, 1),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } finally {
        setState(() {
          isSubmitting = false; // Stop loading state
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: const Color(0xFF323232).withOpacity(0.2),
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => context.go("/settings"),
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        title: Text(
          "Feedback",
          style: styleText(
            context: context,
            fontSizeOption: 17.0,
            fontWeight: CustomFontWeight.weight500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/images/FEEDBACK.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Gap(15),
                Text(
                  "We Value Your Feedback",
                  style: styleText(
                    context: context,
                    fontWeight: CustomFontWeight.weight600,
                    fontSizeOption: 12.0,
                  ),
                ),
                const Gap(10),
                const Text(
                  "Let us know how we're doing to help us improve your GuideURSelf experience",
                  style: TextStyle(height: 1.6, fontSize: 11.5),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(
                    color: const Color(0xFF323232).withOpacity(0.1),
                  ),
                ),
                Stars(
                    isFeedbackSubmitted: isFeedbackSubmitted,
                    onRatingSelected: (selectedRating) {
                      setState(() {
                        rating = selectedRating;
                      });
                    }),
                const Gap(10),
                FeedbackComment(controller: _commentController),
                const Gap(10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSubmitting ? Colors.grey : const Color(0xFF12A5BC),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : Text(
                            storage.getData(key: "feedback") == true
                                ? "Submit another Feedback"
                                : "Submit Feedback",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
