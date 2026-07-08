import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegisterSuccess;
  const RegisterScreen({super.key, required this.onRegisterSuccess});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // ၁။ Firebase Auth ကို အသုံးပြုပြီး အီးမေးလ်နှင့် ပတ်စဝေါ့ဖြင့် အကောင့်သစ်ဆောက်ခြင်း
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // User ရဲ့ Display Name (အမည်) ကို Firebase Auth ထဲတွင် သွားသိမ်းခြင်း
      await userCredential.user?.updateDisplayName(_nameController.text.trim());

      // ၂။ အကောင့်ရရှိလာသော User ID (UID) အတိုင်း Firestore ရဲ့ 'users' collection ထဲတွင် ပရိုဖိုင်ဒေတာ သွားသိမ်းခြင်း
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'displayName': _nameController.text.trim(),
        'location': 'မြန်မာနိုင်ငံ', // Default Location
        'bio': 'တောင်သူလယ်သမား အဖွဲ့ဝင် ဖြစ်ပါသည်၊၊', // Default Bio
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() => _isLoading = false);
        widget.onRegisterSuccess(); // အကောင့်ဖွင့်အောင်မြင်ကြောင်း NewsScreen သို့ လှမ်းပြောမည်
        // Auth screen အားလုံးကို ပိတ်ပြီး Home feed သို့ တိုက်ရိုက်ပြန်သွားရန်
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String errorMessage = "အကောင့်ဖွင့်၍မရပါ၊၊";

      // အဖြစ်များသော Firebase Error များကို မြန်မာလို ပြန်ပေးခြင်း
      if (e.code == 'email-already-in-use') {
        errorMessage = "ဤအီးမေးလ်ဖြင့် အကောင့်ဖွင့်ထားပြီးသား ဖြစ်နေပါသည်၊၊";
      } else if (e.code == 'weak-password') {
        errorMessage = "လျှို့ဝှက်နံပါတ်သည် အားနည်းလွန်းပါသည် (အနည်းဆုံး ၆ လုံး ထားပေးပါ)၊၊";
      } else if (e.code == 'invalid-email') {
        errorMessage = "အီးမေးလ်ပုံစံ မမှန်ကန်ပါ၊၊";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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
                const SizedBox(height: 10),
                const Text(
                  "အကောင့်အသစ်ဖွင့်ရန် ✨",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  "လုပ်ဆောင်ချက်များကို အပြည့်အဝအသုံးပြုနိုင်ဖို့ အချက်အလက်များ ဖြည့်စွက်ပေးပါ။",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),

                // Name (အမည်) ရိုက်ရန်ကွက်
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "အမည် (Name)",
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'ကျေးဇူးပြု၍ သင့်အမည်ကို ထည့်ပေးပါ';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email (အီးမေးလ်) ရိုက်ရန်ကွက်
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
                      return 'မှန်ကန်သော အီးမေးလ်ပုံစံ ဖြစ်ရပါမည်';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password (လျှို့ဝှက်နံပါတ်) ရိုက်ရန်ကွက်
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
                    if (value.trim().length < 6) return 'လျှို့ဝှက်နံပါတ်သည် အနည်းဆုံး ၆ လုံးရှိရပါမည်';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // အကောင့်ဖွင့်ရန် ခလုတ်
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1877F2), // Facebook Blue အရောင်နှင့် ကိုက်ညီအောင်ထားပါသည်
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
                        : const Text(
                      "အကောင့်ဖွင့်မည်",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // လော့ဂ်အင်သို့ ပြန်သွားမည့်လင့်ခ်
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("အကောင့်ရှိပြီးသားလား? "),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "လော့ဂ်အင်ဝင်ရန်",
                        style: TextStyle(color: Color(0xFF1877F2), fontWeight: FontWeight.bold),
                      ),
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