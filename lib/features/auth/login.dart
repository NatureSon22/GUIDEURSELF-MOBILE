import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/features/auth/loginbuttons.dart';
import 'package:guideurself/features/auth/logindescription.dart';
import 'package:guideurself/features/auth/loginfields.dart';
import 'package:guideurself/services/auth.dart';
import 'package:guideurself/services/general_settings_service.dart'; // <-- Import your service
import 'package:guideurself/models/general_settings.dart'; // <-- Import your model

class Login extends HookWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useRef(GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final rememberMe = useState(false);

    final settingsService = useMemoized(() => GeneralSettingsService());
    final settingsFuture = useFuture(useMemoized(() {
      return settingsService.fetchGeneralSettings();
    }));

    final loginMutation = useMutation<Map<String, dynamic>, Exception,
        Map<String, dynamic>, void>(
      (data) => login(
        email: data['email'],
        password: data['password'],
        rememberMe: data['rememberMe'],
      ),
      onSuccess: (data, variables, build) {
        Navigator.pop(context);
        context.go("/");
        emailController.clear();
        passwordController.clear();
      },
      onError: (error, variables, build) {
        Navigator.pop(context);
      },
    );

    void handleLogin() {
      if (formKey.value.currentState!.validate()) {
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
                      'lib/assets/webp/head_idle2.gif',
                      width: 150,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 6,
                  child: Text(
                    "Logging in...",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );

        loginMutation.mutate({
          'email': emailController.text,
          'password': passwordController.text,
          'rememberMe': rememberMe.value,
        });
      }
    }

    return Scaffold(
      body: settingsFuture.connectionState == ConnectionState.waiting
          ? const SizedBox(width: 5)
          : settingsFuture.hasError
              ? const Center(child: Text("Failed to load settings."))
              : SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Center(
                            child: Image.network(
                              settingsFuture.data?.generalLogoUrl ??
                                  '', // fallback to empty string if null
                              width: 150,
                              height: 150,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, size: 100);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Form(
                              key: formKey.value,
                              child: Column(
                                children: [
                                  loginMutation.isError
                                      ? Container(
                                          padding: const EdgeInsets.all(25),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                239, 68, 68, 0.1),
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  239, 68, 68, 1),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text(
                                            "Invalid credentials",
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  239, 68, 68, 1),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      : const LoginDescription(),
                                  SizedBox(
                                      height: loginMutation.isError ? 50 : 40),
                                  LoginFields(
                                    emailController: emailController,
                                    passwordController: passwordController,
                                    handleRememberMe: () =>
                                        rememberMe.value = !rememberMe.value,
                                  ),
                                  const SizedBox(height: 40),
                                  LoginButtons(
                                    handleLogin: handleLogin,
                                    isLoading: loginMutation.isPending,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  context.push("/privacy-legal-II");
                                },
                                child: const Text("Terms of Service"),
                              ),
                              const SizedBox(width: 5),
                              TextButton(
                                onPressed: () {
                                  context.push("/privacy-legal-II");
                                },
                                child: const Text("Privacy Policy"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
