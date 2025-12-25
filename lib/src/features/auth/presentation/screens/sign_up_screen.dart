import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/extensions/build_context.dart';
import '../../../../core/utils/regex.dart';
import '../../../../core/widgets/custom_text_field.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  ValueNotifier<bool> obsecureState = ValueNotifier(true);
  final _formKey = GlobalKey<FormState>();
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.createAccount,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            Text(context.l10n.signInToContinue),
            SizedBox(height: 20.h),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  EbTextFormField(
                    controller: fullNameController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    labelText: context.l10n.fullName,
                    validator: (value) {
                      if (value == null) return context.l10n.validationFullname;
                      if (!RegExp(Regex.name).hasMatch(value)) {
                        return context.l10n.validationFullname;
                      }
                      return null;
                    },
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 20.h),
                  EbTextFormField(
                    controller: emailController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    labelText: context.l10n.email,
                    validator: (value) {
                      if (value == null) return context.l10n.validationEmail;
                      if (!RegExp(Regex.email).hasMatch(value)) {
                        return context.l10n.validationEmail;
                      }
                      return null;
                    },
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 20.h),

                  ValueListenableBuilder(
                    valueListenable: obsecureState,
                    builder: (context, value, child) {
                      return EbTextFormField(
                        controller: passwordController,
                        labelText: context.l10n.password,
                        obscureText: obsecureState.value,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            // if empty or null password is required.
                            // we don't validation password strength while login.
                            return context.l10n.validationPasswordRequired;
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          errorMaxLines: 3,
                          suffixIcon: IconButton(
                            icon: obsecureState.value
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            onPressed: () {
                              obsecureState.value = !obsecureState.value;
                            },
                          ),
                        ),
                        onChanged: (value) {},
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: 1.sw,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue, // Button background color
                  foregroundColor: Colors.white, // Text & icon color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await Supabase.instance.client.auth.signUp(
                      password: passwordController.text,
                      email: emailController.text,
                      data: {"full_name": fullNameController.text},
                    );

                    log(
                      'sign up response user: ${response.user} session : ${response.session}',
                    );
                  }
                },
                child: Text(context.l10n.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
