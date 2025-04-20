import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/themes/style.dart';

enum DislikeReason {
  notFactuallyCorrect,
  didntFollowInstructions,
  offensiveOrUnsafe,
  other
}

final Map<DislikeReason, String?> reasonValue = {
  DislikeReason.notFactuallyCorrect:
      'The response is not based on verifiable facts or evidence.',
  DislikeReason.didntFollowInstructions:
      'The response does not follow the instructions or answer the question being asked.',
  DislikeReason.offensiveOrUnsafe:
      'The response contains offensive or harmful content.',
  DislikeReason.other: null,
};

class DislikeReasonSheet extends StatefulWidget {
  const DislikeReasonSheet({super.key});

  @override
  State<DislikeReasonSheet> createState() => _DislikeReasonSheetState();
}

class _DislikeReasonSheetState extends State<DislikeReasonSheet> {
  DislikeReason? _selectedReason;
  final TextEditingController _otherReasonController = TextEditingController();

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'What went wrong?',
            style: styleText(
                context: context,
                fontSizeOption: 16.0,
                fontWeight: CustomFontWeight.weight600),
          ),
          const Gap(6),
          Text(
            'Your feedback helps us improve. Please let us know what went wrong.',
            style: styleText(
                context: context,
                fontSizeOption: 12.5,
                fontWeight: CustomFontWeight.weight400),
          ),

          const Gap(22),

          // Choices
          _buildReasonOption(
              DislikeReason.notFactuallyCorrect, 'Not factually correct'),
          _buildReasonOption(DislikeReason.didntFollowInstructions,
              'Didn\'t follow instructions'),
          _buildReasonOption(
              DislikeReason.offensiveOrUnsafe, 'Offensive or unsafe'),
          _buildReasonOption(DislikeReason.other, 'Other'),

          // Show text field if "Other" is selected
          if (_selectedReason == DislikeReason.other)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: _otherReasonController,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: "Decribe the issue",
                  contentPadding:
                      const EdgeInsets.only(top: 15, left: 10, right: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: const Color(0xFF323232).withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: const Color(0xFF323232).withOpacity(0.45),
                      width: 1.5,
                    ),
                  ),
                ),
                maxLines: 3,
              ),
            ),

          const Gap(24),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_selectedReason != null) {
                  String? customReason;
                  if (_selectedReason == DislikeReason.other) {
                    customReason = _otherReasonController.text.trim();
                  }

                  Navigator.of(context).pop({
                    'reason': reasonValue[_selectedReason],
                    'customReason': customReason,
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Submit',
                style: styleText(
                  context: context,
                  fontSizeOption: 14.0,
                  fontWeight: CustomFontWeight.weight600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonOption(DislikeReason reason, String label) {
    return Theme(
      data: ThemeData(
        unselectedWidgetColor: const Color(0xFF323232).withOpacity(0.7),
      ),
      child: RadioListTile<DislikeReason>(
        activeColor: const Color(0xFF12A5BC),
        title: Text(
          label,
          style: styleText(
            context: context,
            fontSizeOption: 12.0,
            fontWeight: CustomFontWeight.weight400,
          ),
        ),
        value: reason,
        groupValue: _selectedReason,
        onChanged: (DislikeReason? value) {
          setState(() {
            _selectedReason = value;
          });
        },
        contentPadding: EdgeInsets.zero,
        dense: true,
      ),
    );
  }
}

// Helper function to show the bottom sheet and return the result
Future<Map<String, dynamic>?> showDislikeReasonSheet(BuildContext context) {
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const DislikeReasonSheet(),
      );
    },
  );
}
