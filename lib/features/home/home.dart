import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/features/home/cardbot.dart';
import 'package:guideurself/features/home/header.dart';
import 'package:guideurself/features/home/history.dart';
import 'package:guideurself/features/home/navfeature.dart';
import 'package:guideurself/providers/account.dart';
import 'package:guideurself/services/auth.dart';
import 'package:guideurself/services/storage.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final storage = StorageService();

  @override
  void initState() {
    super.initState();
    //_fetchUserAccount();
  }

  Future<void> _fetchUserAccount() async {
    try {
      final account = await userAccount();
      // if (mounted) {
      //   context.read<AccountProvider>().setAccount(account: account);
      // }
    } catch (e) {
      debugPrint('Failed to fetch user account: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final account = accountProvider.account;

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: BottomCurveClipper(),
                child: Container(
                  height: 280,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/assets/images/GIANT.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 40, left: 30, right: 30, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Header(),
                  const Gap(15),
                  const SizedBox(
                    width: double.infinity,
                    child: CardBot(),
                  ),
                  const Gap(20),
                  const NavFeature(),
                  const Gap(40),
                  Expanded(
                    child: account.isEmpty
                        ? Opacity(
                            opacity: 0.4,
                            child: Image.asset(
                              'lib/assets/webp/asset_chat.gif',
                              fit: BoxFit.contain,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Recent Chats",
                                  style: styleText(
                                      context: context, fontSizeOption: 14.0),
                                ),
                              ),
                              const Gap(10),
                              const Expanded(
                                child: HistoryList(),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
