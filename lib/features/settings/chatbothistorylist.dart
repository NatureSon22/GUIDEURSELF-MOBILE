import 'package:flutter/material.dart';
import 'package:guideurself/services/conversation.dart';
import 'package:shimmer/shimmer.dart';

class Chatbothistorylist extends StatefulWidget {
  final bool hasDeleted;
  const Chatbothistorylist({super.key, required this.hasDeleted});

  @override
  State<Chatbothistorylist> createState() => _ChatbothistorylistState();
}

class _ChatbothistorylistState extends State<Chatbothistorylist> {
  late Future<List<Map<String, dynamic>>> _futureMessages;

  @override
  void initState() {
    super.initState();
    _futureMessages = getAllConversations();
  }

  @override
  void didUpdateWidget(covariant Chatbothistorylist oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasDeleted != oldWidget.hasDeleted && widget.hasDeleted) {
      _fetchConversations();
    }
  }

  void _fetchConversations() {
    setState(() {
      _futureMessages = getAllConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureMessages,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        }

        if (snapshot.hasError) {
          return _buildErrorWidget();
        }

        final messages = snapshot.data ?? [];

        if (messages.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF323232).withOpacity(0.02),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "Your chat is empty",
                style: TextStyle(
                  fontSize: 12.0,
                  color: const Color(0xFF323232).withOpacity(0.5),
                ),
              ),
            ),
          );
        }

        return _buildMessageList(messages);
      },
    );
  }

  Widget _buildLoadingWidget() {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            direction: ShimmerDirection.ltr,
            period: const Duration(milliseconds: 1500),
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

  Widget _buildErrorWidget() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Failed to fetch messages',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF323232).withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _futureMessages = getAllConversations(limit: 5);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageList(List<Map<String, dynamic>> messages) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final title = message['conversation_name'].length > 25
            ? '${message['conversation_name'].substring(0, 25)}...'
            : message['conversation_name'];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFF323232).withOpacity(0.1),
            ),
          ),
          child: ListTile(
            leading: Icon(
              Icons.chat_bubble,
              color: const Color(0xFF323232).withOpacity(0.5),
              size: 18,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 11.5,
                color: const Color(0xFF323232).withOpacity(0.5),
              ),
            ),
          ),
        );
      },
    );
  }
}
