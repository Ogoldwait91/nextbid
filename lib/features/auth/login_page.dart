import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  String _email = '', _password = '';
  bool _busy = false;

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    _form.currentState!.save();
    setState(() => _busy = true);
    await Future.delayed(const Duration(milliseconds: 400)); // TODO: replace with real auth
    // After "login", go to dashboard (root shell)
    if (mounted) context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      'assets/images/logo.png',
      height: 64,
      errorBuilder: (_, __, ___) => const FlutterLogo(size: 64), // fallback if logo missing
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  logo,
                  const SizedBox(height: 16),
                  Text('NextBid', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 0,
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _form,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => (v==null || !v.contains('@')) ? 'Enter a valid email' : null,
                              onSaved: (v) => _email = v!.trim(),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                              obscureText: true,
                              validator: (v) => (v==null || v.length < 6) ? 'Min 6 characters' : null,
                              onSaved: (v) => _password = v!,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: _busy ? null : _submit,
                                child: _busy
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Text('Sign in'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text('Forgot password?'),
                              ),
                            ),
                            const Divider(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("New here?"),
                                TextButton(
                                  onPressed: () => context.go('/signup'),
                                  child: const Text('Create an account'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
