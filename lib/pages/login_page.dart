import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  final storage = FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: "secure_storage",
    ),
  );

  List<String> loginHistory = [];

  @override
  void initState() {
    super.initState();
    loadLoginHistory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final emailArg = ModalRoute.of(context)?.settings.arguments;
    if (emailArg is String) {
      emailCtrl.text = emailArg;
    }
  }

  Future<void> loadLoginHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('login_history') ?? [];
    setState(() => loginHistory = history.reversed.toList());
  }

  Future<void> saveLoginHistory(String email) async {
    final prefs = await SharedPreferences.getInstance();

    // await storage.write(
    //   key: email,
    //   value: passCtrl.text.trim(),
    // );

    // Cập nhật history
    List<String> history = prefs.getStringList('login_history') ?? [];
    history.remove(email);
    history.add(email);

    await prefs.setStringList('login_history', history);

    // Cập nhật lại UI
    await loadLoginHistory();
  }


  Future<void> _login() async {
    setState(() => loading = true);

    try {
      final authResponse =
      await Supabase.instance.client.auth.signInWithPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      if (authResponse.session != null) {
        await saveLoginHistory(emailCtrl.text.trim());

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError("Có lỗi xảy ra: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Đăng nhập",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                _inputField(
                    controller: emailCtrl,
                    label: "Email",
                    icon: Icons.email),
                const SizedBox(height: 20),

                _inputField(
                    controller: passCtrl,
                    label: "Mật khẩu",
                    icon: Icons.lock,
                    obscure: true),
                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Đăng nhập",
                        style:
                        TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/register'),
                  child: const Text(
                    "Chưa có tài khoản? Đăng ký ngay",
                    style: TextStyle(color: primaryColor),
                  ),
                ),

                const SizedBox(height: 30),

                if (loginHistory.isNotEmpty) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Tài khoản đã đăng nhập:",
                        style: TextStyle(color: Colors.white70)),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: loginHistory.length,
                    itemBuilder: (_, i) => _accountItem(loginHistory[i]),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(
      {required TextEditingController controller,
        required String label,
        required IconData icon,
        bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white54),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _accountItem(String email) {
    return ListTile(
      leading: const Icon(Icons.account_circle, color: Colors.white70, size: 28),
      title: Text(email, style: const TextStyle(color: Colors.white)),
      onTap: () async {
        emailCtrl.text = email;
        String? savedPass = await storage.read(key: email);
        if (savedPass != null) {
          passCtrl.text = savedPass;
          _login();
        } else {
          passCtrl.clear();
          _showError("Vui lòng nhập mật khẩu!");
        }
      },
    );
  }
}
