import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/features/chat/headerdrawer.dart';
import 'package:guideurself/features/chat/messagetile.dart';
import 'package:guideurself/services/conversation.dart';
import 'package:shimmer/shimmer.dart';

class MessageDrawer extends StatefulWidget {
  final Function handleCloseDrawer;
  const MessageDrawer({super.key, required this.handleCloseDrawer});

  @override
  State<MessageDrawer> createState() => _MessageDrawerState();
}

class _MessageDrawerState extends State<MessageDrawer> {
  late Future<List<Map<String, dynamic>>> _futureMessages;
  int _messageLimit = 6;
  final int _increment = 6;

  @override
  void initState() {
    super.initState();
    _futureMessages = getAllConversations();
  }

  String _getDateCategory(DateTime date) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final yesterday = startOfToday.subtract(const Duration(days: 1));
    final startOfWeek = startOfToday.subtract(Duration(days: now.weekday - 1));
    final startOfLastWeek = startOfWeek.subtract(const Duration(days: 7));
    final startOfLastMonth = DateTime(
      now.year,
      now.month == 1 ? 12 : now.month - 1,
      1,
    );

    if (date.isAfter(startOfToday)) return 'Today';
    if (date.isAfter(yesterday)) return 'Yesterday';
    if (date.isAfter(startOfWeek)) return 'This Week';
    if (date.isAfter(startOfLastWeek)) return 'Last Week';
    if (date.isAfter(startOfLastMonth)) return 'Last Month';
    return 'Last Year';
  }

  Map<String, List<Map<String, dynamic>>> _groupMessagesByDate(
      List<Map<String, dynamic>> messages) {
    Map<String, List<Map<String, dynamic>>> groupedMessages = {};

    messages.sort((a, b) =>
        DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));

    for (var message in messages) {
      DateTime dateTime = DateTime.parse(message['date']);
      String dateCategory = _getDateCategory(dateTime);

      if (!groupedMessages.containsKey(dateCategory)) {
        groupedMessages[dateCategory] = [];
      }
      groupedMessages[dateCategory]!.add(message);
    }

    Map<String, List<Map<String, dynamic>>> sortedMessages = {};
    const categories = [
      'Today',
      'Yesterday',
      'This Week',
      'Last Week',
      'Last Month',
      'Last Year'
    ];

    for (var category in categories) {
      if (groupedMessages.containsKey(category)) {
        sortedMessages[category] = groupedMessages[category]!;
      }
    }

    return sortedMessages;
  }

  List<Widget> _buildMessageList(
      Map<String, List<Map<String, dynamic>>> groupedMessages) {
    List<Map<String, dynamic>> allMessages = [];

    groupedMessages.forEach((category, messages) {
      for (var message in messages) {
        allMessages.add({...message, 'category': category});
      }
    });

    final displayedMessages = allMessages.take(_messageLimit).toList();

    Map<String, List<Map<String, dynamic>>> displayedGroupedMessages = {};
    for (var message in displayedMessages) {
      String category = message['category'];
      displayedGroupedMessages.putIfAbsent(category, () => []).add(message);
    }

    List<Widget> messageWidgets = [];
    displayedGroupedMessages.forEach((category, messages) {
      messageWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Text(
            category,
            style: styleText(
              context: context,
              fontSizeOption: 12.0,
              lineHeightOption: LineHeightOption.height200,
              color: const Color(0xFF323232).withOpacity(0.5),
            ),
          ),
        ),
      );

      for (var message in messages) {
        final title = message['conversation_name'].length > 15
            ? '${message['conversation_name'].substring(0, 15)}...'
            : message['conversation_name'];
        messageWidgets.add(MessageTile(
          message: message,
          title: title,
          handleCloseDrawer: widget.handleCloseDrawer,
        ));
      }
    });

    return messageWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        children: [
          HeaderDrawer(context: context),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureMessages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: _messageLimit,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[200]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Failed to fetch messages',
                          textAlign: TextAlign.center,
                        ),
                        const Gap(10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _futureMessages = getAllConversations();
                            });
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final messages = snapshot.data ?? [];
                final groupedMessages = _groupMessagesByDate(messages);

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      "Your chat is empty",
                      style: styleText(context: context, fontSizeOption: 12.0),
                    ),
                  );
                }

                return ListView(
                  children: _buildMessageList(groupedMessages),
                );
              },
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _futureMessages,
            builder: (context, snapshot) {
              final totalMessages = snapshot.data?.length ?? 0;

              if (_messageLimit < totalMessages) {
                return Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5.5),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _messageLimit += _increment;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                    child: const Text(
                      'See More',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
