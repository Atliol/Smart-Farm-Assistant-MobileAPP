import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart'; // RegisterScreen ကို ခေါ်သုံးရန် import ထည့်ထားပါသည်

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        if (mounted) {
          setState(() => _isLoading = false);
          widget.onLoginSuccess();
          Navigator.pop(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String errorMessage = 'အမှားတစ်ခု ရှိနေပါသည်၊၊';

      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        errorMessage = 'အီးမေးလ် သို့မဟုတ် လျှို့ဝှက်နံပါတ် မှားယွင်းနေပါသည်၊၊';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'လျှို့ဝှက်နံပါတ် (Password) မှားယွင်းနေပါသည်၊၊';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'အီးမေးလ် ပုံစံမမှန်ကန်ပါ။';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "ကြိုဆိုပါတယ် ✨",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  "သင့်ရဲ့ အီးမေးလ်နဲ့ လျှို့ဝှက်နံပါတ်ကို ရိုက်ထည့်ပြီး လော့ဂ်အင်ဝင်ပါ။",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 36),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "အီးမေးလ် (Email)",
                    hintText: "example@gmail.com",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'ကျေးဇူးပြု၍ အီးမေးလ် ထည့်ပေးပါ';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                      return 'အီးမေးလ် ပုံစံမမှန်ကန်ပါ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "လျှို့ဝှက်နံပါတ် (Password)",
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'ကျေးဇူးပြု၍ လျှို့ဝှက်နံပါတ် ထည့်ပေးပါ';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // လော့ဂ်အင်ဝင်ရန် ခလုတ်
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1877F2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      ),
                    )
                        : const Text(
                      "လော့ဂ်အင် ဝင်မည်",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 💡 ဖြည့်စွက်လိုက်သည့်နေရာ: အကောင့်မရှိသေးသူများအတွက် Register Screen သို့ သွားရန်လင့်ခ်
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("အကောင့်မရှိသေးဘူးလား? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(
                              onRegisterSuccess: widget.onLoginSuccess, // အကောင့်ဖွင့်ပြီးရင် တန်းဝင်သွားစေရန်
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "အကောင့်အသစ်ဖွင့်ရန်",
                        style: TextStyle(color: Color(0xFF1877F2), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}