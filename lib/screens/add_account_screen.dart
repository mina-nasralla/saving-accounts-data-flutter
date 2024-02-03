
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valo_accounts/cubit/cubit_functions.dart';
import 'package:valo_accounts/screens/home_screen.dart';
import 'package:valo_accounts/widgets/text_field.dart';
import 'package:valo_accounts/constants/messages.dart';

import '../cubit/states.dart';


class AddAccount extends StatefulWidget {
  const AddAccount({super.key});

  @override
  State<AddAccount> createState() => _AddAccountState();
}

final GlobalKey<FormState> _globalKey = GlobalKey();

String? ema, pass, notes, name;

final TextEditingController _emailcontroller = TextEditingController();

final TextEditingController _namecontroller = TextEditingController();

final TextEditingController _passcontroller = TextEditingController();

final TextEditingController _notescontroller = TextEditingController();

class _AddAccountState extends State<AddAccount> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ValoAccCubit, ValoAccStates>(
        listener: (BuildContext context, ValoAccStates state) {},
        builder: (BuildContext context, ValoAccStates state) {
          return Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text(
                          'Add Account',
                          style: TextStyle(fontSize: 20),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                              ValoAccCubit.get(context).GetAccounts();
                              ValoAccCubit.get(context).GetSharedAccounts();
                            },
                            icon: const Icon(Icons.close)),

                      ],
                    ),
                  ),
                  Form(
                      key: _globalKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
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
                            Textfield(
                              onclick: (name) {
                                name = name;
                              },
                              icon: Icons.add_comment_outlined,
                              keyboardtype: TextInputType.name,
                              obsecure: false,
                              textEditingController: _namecontroller,
                              hint: ' Account_Name # 00000',
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Textfield(
                              onclick: (password) {
                                pass = password;
                              },
                              icon: Icons.lock,
                              keyboardtype: TextInputType.visiblePassword,
                              obsecure: true,
                              textEditingController: _passcontroller,
                              hint: 'Enter account password',
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
                              height: 100,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_globalKey.currentState!.validate()) {
                                  ValoAccCubit.get(context).AddNewAcc(
                                      name: _namecontroller.text,
                                      email: _emailcontroller.text,
                                      rank: _notescontroller.text,
                                      password: _passcontroller.text);
                                  _namecontroller.clear();
                                  _emailcontroller.clear();
                                  _notescontroller.clear();
                                  _passcontroller.clear();
                                  ToastMsg(
                                      text: 'Account added successfully',
                                      color: Colors.green);
                                  ValoAccCubit.get(context).GetAccounts();

                                } else {
                                  ToastMsg(
                                      text: 'please check all fields',
                                      color: Colors.red);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                textStyle: const TextStyle(fontSize: 20),
                                // Adjust font size if desired
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12), // Adjust padding
                              ),
                              child: const Text('Save & Upload'),
                            ),
                          ],
                        ),
                      )),

                ],
              ),
            )),
          );
        });
  }
}
