import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valo_accounts/cubit/cubit_functions.dart';
import 'package:valo_accounts/cubit/states.dart';
import 'package:valo_accounts/model/accounts_model.dart';
import 'package:valo_accounts/screens/add_account_screen.dart';
import 'package:valo_accounts/screens/view_account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ValoAccCubit()
        ..GetUserData()..GetSharedAccounts()..GetAccounts(),
      child: BlocConsumer<ValoAccCubit, ValoAccStates>(
        listener: (BuildContext context, ValoAccStates state) {},
        builder: (BuildContext context, ValoAccStates state) {
          var userdata = ValoAccCubit.get(context).user_model;
          return ConditionalBuilder(
            fallback: (BuildContext context) => const Scaffold(
                body: Center(child: CircularProgressIndicator())),
            condition: userdata != null,
            builder: (BuildContext context) => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.red,
                title: Text(
                  'Hello ${userdata!.name}',
                  style: const TextStyle(fontSize: 25),
                ),
                actions: [
                  Container(
                    padding: const EdgeInsets.only(right: 10, bottom: 2),
                    child: CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            NetworkImage(userdata.image.toString())),
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Accounts',
                        style: TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                      const Divider(height: 20),
                      ConditionalBuilder(
                        condition:
                            ValoAccCubit.get(context).localaccounts.isNotEmpty,
                        fallback: (BuildContext context) => const Text(
                            'There is no accounts',
                            style: TextStyle(fontSize: 20)),
                        builder: (BuildContext context) => ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) => UserAcconutsList(
                              ValoAccCubit.get(context).localaccounts[index],
                              context,
                              index),
                          itemCount:
                              ValoAccCubit.get(context).localaccounts.length,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Shared Accounts',
                        style: TextStyle(fontSize: 17, color: Colors.red),
                      ),
                      const Divider(height: 20),
                      ConditionalBuilder(
                        condition:
                            ValoAccCubit.get(context).sharedaccounts.isNotEmpty,
                        fallback: (BuildContext context) => Text(
                          'There is no accounts',
                          style: TextStyle(fontSize: 20),
                        ),
                        builder: (BuildContext context) => ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => SharedAcconutsList(
                              ValoAccCubit.get(context).sharedaccounts[index],
                              context,
                              index),
                          itemCount:
                              ValoAccCubit.get(context).sharedaccounts.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                extendedPadding: const EdgeInsets.only(left: 10, right: 10),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AddAccount()));
                },
                backgroundColor: Colors.red,
                label: const Row(
                  children: [
                    Icon(Icons.add_circle),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Add Account",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget UserAcconutsList(AccountModel model, context, index) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white24, borderRadius: BorderRadius.circular(7)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage('${model.image}'),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.name}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${model.acc_rank}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      ValoAccCubit.get(context).ShareAccount(accid: model.uid);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                      ValoAccCubit.get(context).GetAccounts();
                      ValoAccCubit.get(context).GetSharedAccounts();
                    },
                    icon: const Icon(Icons.share)),
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewAccount(acc_model: model)));
                    },
                    icon: const Icon(Icons.arrow_forward_ios_outlined))
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget SharedAcconutsList(AccountModel model, context, index) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white24, borderRadius: BorderRadius.circular(7)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/images/logo.jpg'),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.name}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      children: [
                        Text(
                          '${model.acc_rank}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        TextButton(onPressed: () {
                          ValoAccCubit.get(context).ChangeAccState(
                              accid: '${model.uid}', accState: model.acc_state);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                          ValoAccCubit.get(context).changeAccstate();
                          ValoAccCubit.get(context).GetAccounts();
                          ValoAccCubit.get(context).GetSharedAccounts();
                        },
                            child: ConditionalBuilder(
                                condition: model.acc_state==true,
                                fallback: (BuildContext context)=>Text(' cloesd',style: TextStyle(color: Colors.grey),),
                                builder: (BuildContext context)=>Text(' opend' ,style: TextStyle(color: Colors.red)))),
                      ],
                    ),
                  ],
                ),
                const Spacer(),

                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewAccount(acc_model: model)));
                    },
                    icon: const Icon(Icons.arrow_forward_ios_outlined))
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
