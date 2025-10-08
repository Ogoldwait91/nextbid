import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../../shared/services/auth_state.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _busy = false;

  // BA-ish palette
  static const Color _baBlue = Color(0xFF0E1A2B);
  static const Color _baBlueLight = Color(0xFF1A3E6A);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);

    // note: replace with real auth
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    // Mark user as logged in -> router redirect will now allow /dashboard
    authState.value = true;
    context.go("/dashboard");
  }

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      "assets/images/logo.png",
      height: 64,
      errorBuilder: (_, __, ___) => const FlutterLogo(size: 64),
    );

    return Scaffold(
      backgroundColor: Colors.transparent, // ensure gradient shows
      body: Stack(
        children: [
          // Full-screen gradient behind everything
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_baBlue, _baBlueLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Brand header
                      logo,
                      const SizedBox(height: 12),
                      Text(
                        "NextBid",
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Smarter bidding, better rosters",
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Blue frame around the white auth card
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(
                            28,
                          ), // subtle glow (no deprecation)
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 24,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Form(
                              key: _form,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: _emailCtrl,
                                    decoration: const InputDecoration(
                                      labelText: "Email",
                                      prefixIcon: Icon(Icons.email_outlined),
                                      filled: true,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator:
                                        (v) =>
                                            (v == null || !v.contains("@"))
                                                ? "Enter a valid email"
                                                : null,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _passwordCtrl,
                                    decoration: const InputDecoration(
                                      labelText: "Password",
                                      prefixIcon: Icon(Icons.lock_outline),
                                      filled: true,
                                    ),
                                    obscureText: true,
                                    validator:
                                        (v) =>
                                            (v == null || v.length < 6)
                                                ? "Min 6 characters"
                                                : null,
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: FilledButton(
                                      onPressed: _busy ? null : _submit,
                                      child:
                                          _busy
                                              ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                              : const Text("Sign in"),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Text("Forgot password?"),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("New here?"),
                                      TextButton(
                                        onPressed: () => context.go("/signup"),
                                        child: const Text("Create an account"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Opacity(
                        opacity: 0.75,
                        child: Text(
                          "Unofficial tool for BA pilots",
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
