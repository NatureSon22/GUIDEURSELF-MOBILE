import 'package:flutter/material.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/services/messagechats.dart';
import 'package:go_router/go_router.dart';

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
            return Center(
                child: CircularProgressIndicator(
              color: const Color(0xFF12A5BC),
              backgroundColor: const Color(0xFF323232).withOpacity(0.1),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No messages found.'));
          }

          final messagesHead = snapshot.data!;
          return ListView.builder(
            itemCount: messagesHead.length,
            itemBuilder: (context, index) {
              final receiver = messagesHead[index]['receiver'];
              final role =
                  'University ${receiver['role_type'].substring(0, 1).toUpperCase()}${receiver['role_type'].substring(1)}';
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text(receiver?['name'] ?? 'Unknown'),
                subtitle: Text(role),
                leading: CircleAvatar(
                  backgroundImage: receiver?['user_profile'] != null
                      ? NetworkImage(receiver!['user_profile'])
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
