import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/services/setttings.dart';

class ChatbotPreference extends StatelessWidget {
  const ChatbotPreference({super.key});

  Future<void> _showCustomDialog(BuildContext rootContext) async {
    return showDialog<void>(
      context: rootContext,
      builder: (dialogContext) {
        bool isDeleting = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> handleDeleteAllConversation() async {
              setDialogState(() => isDeleting = true);
              try {
                await deleteAllConversation();
                if (rootContext.mounted) {
                  Navigator.pop(rootContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "All conversations deleted successfully!",
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
              } catch (e) {
                if (rootContext.mounted) {
                  Navigator.pop(rootContext);
                  ScaffoldMessenger.of(rootContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to delete all conversations.',
                        style: styleText(
                          context: rootContext,
                          fontSizeOption: 12.0,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              } finally {
                if (rootContext.mounted) {
                  setDialogState(() => isDeleting = false);
                }
              }
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Clear Chat History',
                      style: styleText(
                        context: rootContext,
                        fontSizeOption: 15.0,
                        fontWeight: CustomFontWeight.weight700,
                      ),
                    ),
                    Divider(color: const Color(0xFF323232).withOpacity(0.15)),
                    const SizedBox(height: 10),
                    Flexible(
                      child: Text(
                        'Are you sure you want to clear your chat history?',
                        style: styleText(
                            context: rootContext, fontSizeOption: 12.0),
                      ),
                    ),
                    const SizedBox(height: 15),
                    isDeleting
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                textStyle: const TextStyle(fontSize: 13.5),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  textStyle: const TextStyle(fontSize: 13.5),
                                ),
                                child: const Text('Close'),
                              ),
                              const Gap(10),
                              ElevatedButton(
                                onPressed: () async {
                                  await handleDeleteAllConversation();
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  textStyle: const TextStyle(fontSize: 13.5),
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
          onPressed: () async {
            context.go("/settings");
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        title: Text(
          "Chatbot Preferences",
          style: styleText(
              context: context,
              fontSizeOption: 17.0,
              fontWeight: CustomFontWeight.weight500),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: OutlinedButton(
          onPressed: () => _showCustomDialog(context),
          style: OutlinedButton.styleFrom(
              overlayColor: const Color.fromRGBO(239, 68, 68, 1),
              backgroundColor: const Color.fromRGBO(239, 68, 68, 0.1),
              side: const BorderSide(
                color: Color.fromRGBO(239, 68, 68, 1),
                width: 1,
              )),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, color: Color.fromRGBO(239, 68, 68, 1), size: 20),
              SizedBox(width: 10),
              Text(
                "Clear Chat History",
                style: TextStyle(
                  color: Color.fromRGBO(239, 68, 68, 1),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
