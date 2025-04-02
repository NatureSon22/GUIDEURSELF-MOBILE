import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/providers/messagechat.dart';
import 'package:guideurself/services/messagechats.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

class Messageschat extends StatefulWidget {
  const Messageschat({super.key});

  @override
  State<Messageschat> createState() => _MessageschatState();
}

class _MessageschatState extends State<Messageschat> {
  late Future<List<Map<String, dynamic>>> _futureChatHeads;

  @override
  void initState() {
    super.initState();
    _futureChatHeads =
        chatHeads(); // Fetch data once when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    final messageChatProvider = context.read<MessageChatProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: const Color(0xFF323232).withOpacity(0.2),
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () async {
            context.go("/chatbot");
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        title: Text(
          "Chats",
          style: styleText(
            context: context,
            fontSizeOption: 17.0,
            fontWeight: CustomFontWeight.weight500,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureChatHeads,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 12,
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Failed to fetch messages"),
                  const Gap(10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureChatHeads = chatHeads();
                      });
                    },
                    child: const Text("Retry"),
                  )
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No messages found.'),
            );
          }

          final messagesHead = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: ListView.builder(
              itemCount: messagesHead.length,
              itemBuilder: (context, index) {
                final receiver = messagesHead[index]['receiver'];
                final role =
                    'University ${receiver['role_type'].substring(0, 1).toUpperCase()}${receiver['role_type'].substring(1)}';
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      messageChatProvider.setMessage(message: receiver);
                      context.push("/messages-chatlist");
                    },
                    splashColor: const Color(0xFF323232).withOpacity(0.04),
                    highlightColor: const Color(0xFF323232).withOpacity(0.03),
                    borderRadius:
                        BorderRadius.circular(8), // Rounded tap effect
                    child: ListTile(
                      title: Text(
                        receiver?['name'] ?? 'Unknown',
                        style:
                            styleText(context: context, fontSizeOption: 14.0),
                      ),
                      subtitle: Text(
                        role,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: const Color(0xFF323232).withOpacity(0.6),
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: receiver?['user_profile'] != null
                            ? NetworkImage(receiver!['user_profile'])
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
