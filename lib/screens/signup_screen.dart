import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valo_accounts/constants/components.dart';
import 'package:valo_accounts/constants/messages.dart';
import 'package:valo_accounts/cubit/cubit_functions.dart';
import 'package:valo_accounts/cubit/states.dart';
import 'package:valo_accounts/local/cach.dart';
import 'package:valo_accounts/screens/login_screen.dart';
import 'package:valo_accounts/widgets/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

final GlobalKey<FormState> _globalKey = GlobalKey();

String? ema, name, age, gender, pass;

final TextEditingController _emailcontroller = TextEditingController();

final TextEditingController _passcontroller = TextEditingController();

final TextEditingController _namecontroller = TextEditingController();

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ValoAccCubit, ValoAccStates>(
      listener: (BuildContext context, state) {
        if (state is CreateUserSuccessState) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
          CasheHelper.savedata(key: 'uId', value: state.uid);
        } else if (state is RegisterUserErrorState) {
          ToastMsg(text: state.ERROR.toString(), color: Colors.red);
        }
      },
      builder: (BuildContext context, Object? state) {
        var profileimage = ValoAccCubit.get(context).Profileimage;
        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),

                    const Text(
                      'Register Now ',
                      style: TextStyle(fontSize: 40),
                    ),
                    const Text(
                      'Create your account and join us ',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Stack(alignment: AlignmentDirectional.bottomEnd, children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.redAccent,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: profileimage == null
                                ? NetworkImage(UserAvatar) as ImageProvider
                                : FileImage(profileimage),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 23,
                        child: CircleAvatar(
                            backgroundColor: const Color(0xffF16067),
                            child: IconButton(
                              onPressed: () {
                                ValoAccCubit.get(context).getImage();
                              },
                              icon: const Icon(Icons.add_a_photo_outlined),
                              color: Colors.white,
                            )),
                      )
                    ]),
                    const SizedBox(
                      height: 25,
                    ),

                    //2 text field
                    Form(
                      key: _globalKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Textfield(
                            onclick: (name) {
                              name = name;
                            },
                            icon: Icons.person,
                            keyboardtype: TextInputType.emailAddress,
                            obsecure: false,
                            hint: 'Enter your Name',
                            textEditingController: _namecontroller,
                          ),
                          // DropdownButton(
                          //   borderRadius: BorderRadius.circular(20),
                          //   hint: Text('Select your gender',style: TextStyle(fontSize: 25),),
                          //     items: [
                          //       DropdownMenuItem(child: Row(children: [Text('male'),SizedBox(width: 7),Icon(Icons.male)],),value: 'male',),
                          //       DropdownMenuItem(child: Row(children: [Text('female'),SizedBox(width: 7),Icon(Icons.female)],),value: 'female',),
                          //     ],
                          //   onChanged: (String? value){
                          //       gender=value;
                          // },
                          // ),

                          const SizedBox(
                            height: 15,
                          ),
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
                          borderRadius: BorderRadius.circular(
                            15
                          ),
                        ),
                        color: redColor,
                        onPressed: () {
                          _globalKey.currentState!.validate();
                          ValoAccCubit.get(context).RegisterNewUser(
                              email: _emailcontroller.text,
                              password: _passcontroller.text,
                              name: _namecontroller.text);
                          if (state is CreateUserSuccessState) {
                            _emailcontroller.clear();
                            _namecontroller.clear();
                            _passcontroller.clear();
                          } else if (state is RegisterUserSuccessState) {
                            // error msg code
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 17),
                              child: Text(
                                'Register Now',
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
                              Icons.add_card_outlined,
                              color: Colors.white,
                              size: 35,
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
                          'Already have an accuont ',
                          style: TextStyle(fontSize: 17),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            },
                            child: const Text(
                              'Login Now',
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
