import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nextbid_demo/common/widgets/nb_logo.dart';
import 'package:nextbid_demo/app/state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2342),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: 4),
                  const NBLogo(size: 96),
                  const SizedBox(height: 10),
                  Text(
                    "smarter bidding, better rosters.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF33415C),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Container(width: 64, height: 3,
                    decoration: BoxDecoration(color: const Color(0xFFE4002B), borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => (v==null||v.isEmpty) ? "Enter your email" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (v) => (v==null||v.isEmpty) ? "Enter your password" : null,
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          AppState.instance.login();
                          context.go("/dashboard");
                        }
                      },
                      child: const Text("Log in"),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () { context.go('/signup'); },
                      child: const Text("Sign up"),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextButton(onPressed: () {}, child: const Text("Forgot password?")),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
