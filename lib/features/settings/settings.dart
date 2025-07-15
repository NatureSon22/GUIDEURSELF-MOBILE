import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/providers/account.dart';
import 'package:guideurself/providers/apperance.dart';
import 'package:guideurself/providers/bottomnav.dart';
import 'package:guideurself/providers/conversation.dart';
import 'package:guideurself/providers/loading.dart';
import 'package:guideurself/providers/messagechat.dart';
import 'package:guideurself/providers/textscale.dart';
import 'package:guideurself/providers/transcribing.dart';
import 'package:guideurself/services/auth.dart';
import 'package:provider/provider.dart';

final allSettingsFeatures = [
  {
    "icon": Icons.chat_bubble,
    "label": "Chatbot Preferences",
    "goto": "/chatbot-preference",
    "requiresAuth": true
  },
  {
    "icon": Icons.key,
    "label": "Change Password",
    "goto": "/change-password",
    "requiresAuth": true
  },
  {
    "icon": Icons.thumb_up_alt_rounded,
    "label": "Feedback",
    "goto": "/feedback",
    "requiresAuth": true
  },
  {
    "icon": Icons.privacy_tip,
    "label": "Privacy and Legal",
    "goto": "/privacy-legal",
    "requiresAuth": false
  },
  {
    "icon": Icons.info,
    "label": "About",
    "goto": "/about",
    "requiresAuth": false
  },
  {
    "icon": Icons.color_lens,
    "label": "Apperance",
    "goto": "/appearance",
    "requiresAuth": false
  },
  {
    "icon": Icons.logout,
    "label": "Logout",
    "goto": "/logout",
    "requiresAuth": false
  }
];

class Settings extends StatelessWidget {
  const Settings({super.key});

  Future<void> handleLogout() async {
    await logout();
  }

  void clearAllProviders(BuildContext context) {
    Provider.of<AccountProvider>(context, listen: false).resetAccount();
    Provider.of<LoadingProvider>(context, listen: false)
        .resetIsGeneratingResponse();
    Provider.of<BottomNavProvider>(context, listen: false).resetIndex();
    Provider.of<ConversationProvider>(context, listen: false)
        .resetConversation();
    Provider.of<MessageChatProvider>(context, listen: false).resetMessage();
    Provider.of<Transcribing>(context, listen: false).resetIsTranscribing();
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final isDarkMode = context.watch<AppearanceProvider>().isDarkMode;
    final textScaleFactor = context.watch<TextScaleProvider>().scaleFactor;
    final account = accountProvider.account;
    final isGuest = account.isEmpty;
    final bottomNavProvider = context.watch<BottomNavProvider>();
    final extras =
        GoRouterState.of(context).extra as Map<String, dynamic>? ?? {};

    final settingsFeatures = allSettingsFeatures
        .where((feature) => isGuest ? !(feature['requiresAuth'] as bool) : true)
        .toList();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          bottomNavProvider.setIndex(index: extras['prev'] ?? 0);
          debugPrint(extras['prev'].toString());
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isGuest)
                  Card(
                    color: isDarkMode ? const Color(0xFF12A5BC) : Colors.white,
                    shadowColor:
                        const Color.fromARGB(255, 50, 50, 50).withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: const Color(0xFF323232).withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 20),
                      child: Row(
                        children: [
                          Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: isGuest
                                    ? const AssetImage(
                                        "lib/assets/images/avatar_placeholder.png")
                                    : NetworkImage(
                                        account["user_photo_url"] ?? ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const Gap(15),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  account["username"]?.toUpperCase() ??
                                      'GUEST'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 13 * textScaleFactor,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF323232),
                                    height: 1.0,
                                  ),
                                ),
                                const Gap(1.5),
                                Text(
                                  'ID No: ${account["user_number"] ?? "-- --"}',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 11 * textScaleFactor,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF323232)
                                        .withOpacity(0.7),
                                  ),
                                ),
                                const Gap(4),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.push('/edit-profile');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF12A5BC),
                                      padding: const EdgeInsets.all(0),
                                      textStyle: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    child: Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? const Color(0xFF12A5BC)
                                            : Colors.white,
                                        fontWeight: isDarkMode
                                            ? FontWeight.w700
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.separated(
                    itemCount: settingsFeatures.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 0,
                      color: const Color(0xFF323232).withOpacity(0.08),
                    ),
                    itemBuilder: (context, index) {
                      final feature = settingsFeatures[index];
                      return ListTile(
                        minTileHeight: 25,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        splashColor: const Color(0xFF323232).withOpacity(0.08),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 8),
                        leading: Icon(
                          feature['icon'] as IconData,
                          size: 18,
                          color: feature["label"] == "Logout"
                              ? const Color.fromRGBO(239, 68, 68, 1)
                              : isDarkMode
                                  ? Colors.white.withOpacity(0.5)
                                  : const Color(0xFF323232),
                        ),
                        title: Text(
                          feature['label'] as String,
                          style: styleText(
                            context: context,
                            fontSizeOption: 12.0 * textScaleFactor,
                            fontWeight: CustomFontWeight.weight500,
                            color: feature["label"] == "Logout"
                                ? const Color.fromRGBO(239, 68, 68, 1)
                                : isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF323232),
                          ),
                        ),
                        onTap: () async {
                          if (feature['label'] == "Logout") {
                            if (!isGuest) {
                              await handleLogout();
                              accountProvider.resetAccount();
                            }

                            if (context.mounted) {
                              clearAllProviders(context);
                              context.push("/auth-layer");
                            }
                          } else {
                            context.push(feature['goto'] as String);
                          }
                        },
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: feature["label"] == "Logout"
                              ? const Color.fromRGBO(239, 68, 68, 1)
                              : isDarkMode
                                  ? Colors.white.withOpacity(0.3)
                                  : const Color(0xFF323232),
                        ),
                      );
                    },
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
