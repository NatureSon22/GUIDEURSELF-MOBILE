import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/screens/featuredots.dart';
import 'package:guideurself/screens/featureimages.dart';
import 'package:guideurself/screens/featuretexts.dart';

class FeatureOverview extends StatefulWidget {
  const FeatureOverview({super.key});

  @override
  State<FeatureOverview> createState() => _FeatureOverviewState();
}

class _FeatureOverviewState extends State<FeatureOverview> {
  int index = 0;

  void handleSetIndex() {
    if (index > 2) {
      context.go("/login");
      return;
    }

    setState(() {
      index += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            child: Image(
              image: AssetImage('lib/assets/images/LOGO-md.png'),
            ),
          ),
          const Gap(20),
          SizedBox(
            height: 300,
            width: 300,
            child: FeatureImages(index: index),
          ),
          const Gap(10),
          FeatureDots(index: index),
          const Gap(40),
          SizedBox(
            height: 120,
            child: FeatureTexts(index: index),
          ),
          const Gap(20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: handleSetIndex,
              child: const Text("Get Started"),
            ),
          )
        ],
      ),
    ));
  }
}
