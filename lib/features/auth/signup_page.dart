import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nextbid_demo/app/state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _crewCode = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _crewCode.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _emailV(String? v) {
    if (v == null || v.isEmpty) return 'Enter your email';
    if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
    return null;
  }

  String? _crewV(String? v) =>
      (v == null || v.isEmpty)
          ? 'Enter your crew code'
          : (v.length < 4 ? 'Crew code too short' : null);
  String? _pwdV(String? v) =>
      (v == null || v.isEmpty)
          ? 'Enter a password'
          : (v.length < 6 ? 'Use at least 6 characters' : null);
  String? _confV(String? v) =>
      (v == null || v.isEmpty)
          ? 'Confirm your password'
          : (v != _password.text ? 'Passwords do not match' : null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: _emailV,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _crewCode,
                      decoration: const InputDecoration(labelText: 'Crew code'),
                      textCapitalization: TextCapitalization.characters,
                      validator: _crewV,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                      ),
                      obscureText: _obscure,
                      validator: _pwdV,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confirm,
                      decoration: const InputDecoration(
                        labelText: 'Confirm password',
                      ),
                      obscureText: _obscure,
                      validator: _confV,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // later: real signup
                            AppState.instance.login();
                            context.go('/dashboard');
                          }
                        },
                        child: const Text('Create account'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Already have an account? Log in'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
