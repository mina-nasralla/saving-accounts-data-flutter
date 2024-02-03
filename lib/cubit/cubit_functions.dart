


// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:valo_accounts/constants/components.dart';
import 'package:valo_accounts/cubit/states.dart';
import 'package:valo_accounts/model/accounts_model.dart';
import 'package:valo_accounts/model/user_model.dart';

class ValoAccCubit extends Cubit<ValoAccStates> {
  ValoAccCubit() : super(InstaInitialState());

  static ValoAccCubit get(context) => BlocProvider.of(context);

//============================================================================== change password

  IconData suffix = Icons.visibility_off;
  IconData prefix = Icons.lock;

  bool showpassword = true;

  void changevisability() {
    showpassword = !showpassword;
    if (showpassword) {
      suffix = Icons.visibility_off;
      prefix = Icons.lock;
    } else {
      suffix = Icons.visibility;
      prefix = Icons.lock_open_outlined;
    }
    emit(ChangepasswordState());
  }

//============================================================================== image picker
  String userimage = UserAvatar;

  File? Profileimage;
  var picker = ImagePicker();

  Future<void> getImage() async {
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      Profileimage = File(PickedFile.path);
      FirebaseStorage.instance
          .ref()
          .child('users/${Uri.file(Profileimage!.path).pathSegments.last}')
          .putFile(Profileimage!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          userimage = value;
        });
      });

      emit(ImagePickerSuccessState());
    } else {
      print('no image selected');
      emit(ImagePickerErrorState());
    }
  }

//============================================================================== Create user with email & pass and fill the user model

  Future<void> RegisterNewUser({
    required email,
    required password,
    required name,
  }) async {
    //check if the user uploaded image
    emit(RegisterUserLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user?.email);
      CreateNewUser(
        name: name,
        email: email,
        uid: value.user?.uid,
        password: password,
      );
      print('شغال يسطا');
    }).catchError((err) {
      emit(RegisterUserErrorState(ERROR: err));
      print(err.toString());
    });
  }

  void CreateNewUser({
    required name,
    required email,
    required uid,
    required password,
    image,
  }) {
    emit(CreateUserLoadingState());
    UserModel model =
        UserModel(name: name, uid: uid, email: email, image: userimage);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(model.toMap() as Map<String, dynamic>)
        .then((value) {
      emit(CreateUserSuccessState());
      print('user Created');
    }).catchError((err) {
      emit(CreateUserErrorState());
      print(err.toString());
    });
  }

//============================================================================== Signin

  void UserSignIn({
    required email,
    required password,
  }) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(CreateUserSuccessState(uid: value.user!.uid));
      print(' شغال');
    }).catchError((err) {
      emit(SignInUserErrorState(ERROR: err));
      print(err);
      print('مش شغال');
    });
  }

//============================================================================== Get user data
  UserModel? user_model;

  void GetUserData() {
    print('getUserData');
    emit(GetUserDataLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      user_model = UserModel.fromjson(value.data());
      emit(GetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserDataErrorState(ERROR: error));
    });
  }

//============================================================================== Add Account

  void AddNewAcc({
    required name,
    required email,
    required rank,
    required password,
    uid,
  }) {
    emit(AddAccountLoadingState());
    AccountModel model = AccountModel(
        acc_Email: email,
        acc_password: password,
        acc_rank: rank,
        name: name,
        uid: uid,
        image: user_model?.image,
        acc_state: false);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user_model?.uid)
        .collection('accounts')
        .add(model.toMap() as Map<String, dynamic>)
        .then((value) {
      late String docid = value.id;
      value.update({'uid': docid});
      emit(AddAccountSuccessState());
      print('Acc Added');
    }).catchError((err) {
      emit(AddAccountErrorState(ERROR: err));
      print(err.toString());
    });
  }

//============================================================================== Get Account
  AccountModel? acc_model;

  List<AccountModel> localaccounts = [];

  // List<String> accId=[];

  void GetAccounts() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('accounts')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (!localaccounts.contains(element))
          localaccounts.add(AccountModel.fromjson(element.data()));
      });
    }).catchError((error) {
      emit(GetAccountsErrorState(ERROR: error));
    });
  }

//============================================================================== Edite Account
  void EditeAccount(
      {required name, required email, required rank, required pass, uid}) {
    emit(UpdateAccountsLoadingState());
    AccountModel model = AccountModel(
      acc_Email: email,
      acc_password: pass,
      acc_rank: rank,
      name: name,
      image: user_model!.image,
      uid: uid,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('accounts')
        .doc(uid)
        .update(model.toMap() as Map<String, dynamic>)
        .then((value) {
      emit(UpdateAccountsSuccessState());
      GetAccounts();
    }).catchError((onError) {
      emit(UpdateAccountsErrorState(ERROR: onError));
    });
  }

//============================================================================== Share Account

  void ShareAccount({required accid}) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .collection('accounts')
        .doc(accid)
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection("shared_accounts")
          .doc(accid)
          .set(value.data() as Map<String, dynamic>)
          .then((value){
        FirebaseFirestore.instance
            .collection("users")
            .doc(uId)
            .collection('accounts')
            .doc(accid)
            .delete();
      });
    }).catchError((onError) {});
  }

//============================================================================== Get Shared Account

  List<AccountModel> sharedaccounts =[] ;

  void GetSharedAccounts() {
    FirebaseFirestore.instance
        .collection('shared_accounts')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (!sharedaccounts.contains(element))
          sharedaccounts.add(AccountModel.fromjson(element.data()));
      });
    }).catchError((error) {
      emit(GetAccountsErrorState(ERROR: error));
    });
  }

//============================================================================== Change state Account


  void ChangeAccState({required String accid, required bool? accState}) {
    accState =!accState!;
    FirebaseFirestore.instance
        .collection('shared_accounts')
        .doc(accid)
        .update({'acc_state': accState}).then((value) {
      emit(UpdateAccountsStateSuccessState());
    });
  }

  IconData paused = Icons.pause;
  bool changestate = true;

  void changeAccstate() {
    changestate = !changestate;
    if (changestate) {
      paused = Icons.pause;
    } else {
      paused = Icons.play_circle_outline;
    }
    emit(ChangepasswordState());
  }

  void DeleteSharedAcc(
  {required accid}
      ){
    FirebaseFirestore.instance.collection('shared_accounts').doc(accid).delete();
    FirebaseFirestore.instance.collection("users")
        .doc(uId)
        .collection('accounts')
        .doc(accid).delete();
  }




}
