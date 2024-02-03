

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valo_accounts/cubit/cubit_functions.dart';
import 'package:valo_accounts/cubit/states.dart';
import 'package:valo_accounts/model/accounts_model.dart';
import 'package:valo_accounts/screens/home_screen.dart';
import 'package:valo_accounts/widgets/text_field.dart';

class ViewAccount extends StatelessWidget {
  const ViewAccount({super.key, this.acc_model});

 final AccountModel? acc_model;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ValoAccCubit, ValoAccStates>(
      listener: (BuildContext context, ValoAccStates state) {},
      builder: (BuildContext context, ValoAccStates state) {
        _emailcontroller.text = acc_model!.acc_Email!;
        _passcontroller.text = acc_model!.acc_password!;
        _notescontroller.text = acc_model!.acc_rank!;
        _namescontroller.text = acc_model!.name!;
        return Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                          },
                          icon: const Icon(Icons.arrow_back_ios)),
                    ],
                  ),
                  Text(
                    '${acc_model!.name}',
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                      key: _globalKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Textfield(
                            onclick: (name) {
                              name = name;
                            },
                            icon: Icons.drive_file_rename_outline,
                            keyboardtype: TextInputType.name,
                            obsecure: false,
                            textEditingController: _namescontroller,
                            hint: 'Enter account email',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Textfield(
                            onclick: (email) {
                              ema = email;
                            },
                            icon: Icons.email_outlined,
                            keyboardtype: TextInputType.emailAddress,
                            obsecure: false,
                            textEditingController: _emailcontroller,
                            hint: 'Enter account email',
                          ),
                          const SizedBox(
                            height: 20,
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
                          const SizedBox(
                            height: 20,
                          ),
                          Textfield(
                            onclick: (notes) {
                              notes = notes;
                            },
                            icon: Icons.notes_outlined,
                            keyboardtype: TextInputType.text,
                            obsecure: false,
                            textEditingController: _notescontroller,
                            hint: 'Write rank of this account ',
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          ConditionalBuilder(
                              condition: acc_model!.acc_state == true,
                          fallback: (BuildContext context)=>Text('Account is Closed',style: TextStyle(fontSize: 30,color: Colors.grey),),
                          builder: (BuildContext context)=>Text('Account is Open',style: TextStyle(fontSize: 30,color: Colors.red),)),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  ValoAccCubit.get(context).DeleteSharedAcc(accid: acc_model!.uid);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                                  ValoAccCubit.get(context).GetSharedAccounts();
                                  ValoAccCubit.get(context).GetAccounts();

                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  textStyle: const TextStyle(fontSize: 20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ), child:Row(children: [Text('delete')],),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  ValoAccCubit.get(context).EditeAccount(
                                      name: _namescontroller.text,
                                      email: _emailcontroller.text,
                                      rank: _notescontroller.text,
                                      pass: _passcontroller.text,
                                      uid: acc_model!.uid);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.grey,
                                  textStyle: const TextStyle(fontSize: 20),
                                  // Adjust font size if desired
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12), // Adjust padding
                                ),
                                child: const Text('Edite'),
                              ),
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
          )),
        );
      },
    );
  }
}

final GlobalKey<FormState> _globalKey = GlobalKey();

String? ema, pass, notes, name;

TextEditingController _emailcontroller = TextEditingController();

TextEditingController _passcontroller = TextEditingController();

TextEditingController _notescontroller = TextEditingController();
TextEditingController _namescontroller = TextEditingController();
