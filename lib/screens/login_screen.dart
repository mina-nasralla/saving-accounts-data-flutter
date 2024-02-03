import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valo_accounts/constants/components.dart';
import 'package:valo_accounts/constants/messages.dart';
import 'package:valo_accounts/cubit/cubit_functions.dart';
import 'package:valo_accounts/cubit/states.dart';
import 'package:valo_accounts/local/cach.dart';
import 'package:valo_accounts/screens/home_screen.dart';
import 'package:valo_accounts/widgets/text_field.dart';

import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final GlobalKey<FormState> _globalKey = GlobalKey();

String? ema, pass;

final TextEditingController _emailcontroller = TextEditingController();

final TextEditingController _passcontroller = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ValoAccCubit, ValoAccStates>(
      listener: (BuildContext context, state) {
        if (state is CreateUserSuccessState) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          CasheHelper.savedata(key: 'uId', value: state.uid);
        } else if (state is SignInUserErrorState) {
          ToastMsg(text: state.ERROR.toString(), color: Colors.red);
        }
      },
      builder: (BuildContext context, Object? state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // logo image and app name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/login logo.png',
                          width: 300,
                          height: 300,
                        ),
                      ],
                    ),
                    const Text(
                      'Login',
                      style: TextStyle(fontSize: 30),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    //2 text field
                    Form(
                      key: _globalKey,
                      child: Column(
                        children: [
                          Textfield(
                            onclick: (email) {
                              ema = email;
                            },
                            icon: Icons.email,
                            keyboardtype: TextInputType.emailAddress,
                            obsecure: false,
                            hint: 'Enter your Email',
                            textEditingController: _emailcontroller,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This Field is required';
                              }
                              return null;
                            },
                            onChanged: (password) {
                              pass = password;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: ValoAccCubit.get(context).showpassword,
                            controller: _passcontroller,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(color: Colors.red),
                              hintText: 'Enter your password',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide:
                                      const BorderSide(color: Colors.white)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide:
                                      const BorderSide(color: Colors.white)),
                              suffixIcon: GestureDetector(
                                child: Icon(ValoAccCubit.get(context).suffix),
                                onTap: () {
                                  ValoAccCubit.get(context).changevisability();
                                },
                              ),
                              prefixIcon:
                                  Icon(ValoAccCubit.get(context).prefix),
                              prefixIconColor: Colors.white,
                              suffixIconColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // ######################################################### login button
                    GestureDetector(
                      child: MaterialButton(
                        elevation: 30,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: redColor,
                        onPressed: () {
                          _globalKey.currentState!.validate();
                          ValoAccCubit.get(context).UserSignIn(
                              email: _emailcontroller.text,
                              password: _passcontroller.text);
                          _emailcontroller.clear();
                          _passcontroller.clear();
                          ValoAccCubit.get(context).GetUserData();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 17),
                              child: Text(
                                'Sign in',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.login,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    // go to signup
                    const SizedBox(
                      height: 15,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an accuont ',
                          style: TextStyle(fontSize: 17),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen()));
                            },
                            child: const Text(
                              'Register Now',
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 17),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
