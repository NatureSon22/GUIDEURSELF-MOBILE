import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/features/auth/forgotpasswordfields.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  String? accountType;

  void handleResendPassword() {
    // if (formKey.currentState!.validate()) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 100,
              child: Center(
                child: Image.asset(
                  'lib/assets/webp/head_send.gif',
                  width: 150,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Positioned(
              bottom: 6,
              child: Text(
                "Sending Password...",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
    //}
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
          onPressed: () => context.go("/login"),
          icon: const Icon(
            Icons.arrow_back_ios_sharp,
            color: Color(0xFF12A5BC),
          ),
        ),
      ),
      // i want to like
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 85),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot Password?',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "No worries! Enter your email address, and we'll send you a link to reset your password and get you back on track.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                ForgotPasswordFields(
                  formKey: formKey,
                  emailController: emailController,
                  accountType: accountType,
                  onAccountTypeChanged: (value) {
                    setState(() {
                      accountType = value;
                    });
                  },
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: handleResendPassword,
                    child: const Text("Resend Password"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
