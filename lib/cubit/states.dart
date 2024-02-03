abstract class ValoAccStates {}

class InstaInitialState extends ValoAccStates {}

class ChangepasswordState extends ValoAccStates {}

class ImagePickerSuccessState extends ValoAccStates {}

class ImagePickerErrorState extends ValoAccStates {}

//############################################################################## RegisterUserStates
class RegisterUserLoadingState extends ValoAccStates {}

class RegisterUserSuccessState extends ValoAccStates {}

class RegisterUserErrorState extends ValoAccStates {
  var ERROR;

  RegisterUserErrorState({required this.ERROR});
}

//############################################################################## CreateUserStates
class CreateUserLoadingState extends ValoAccStates {}

class CreateUserSuccessState extends ValoAccStates {
  final String? uid;

  CreateUserSuccessState({this.uid});
}

class CreateUserErrorState extends ValoAccStates {}

//############################################################################## SignInUserStates
class SignInUserLoadingState extends ValoAccStates {}

class SignInUserSuccessState extends ValoAccStates {}

class SignInUserErrorState extends ValoAccStates {
  var ERROR;

  SignInUserErrorState({required this.ERROR});
}

//############################################################################## SignInUserStates
class GetUserDataLoadingState extends ValoAccStates {}

class GetUserDataSuccessState extends ValoAccStates {}

class GetUserDataErrorState extends ValoAccStates {
  var ERROR;

  GetUserDataErrorState({required this.ERROR});
}
//############################################################################## AddAccount

class AddAccountLoadingState extends ValoAccStates {}

class AddAccountSuccessState extends ValoAccStates {}

class AddAccountErrorState extends ValoAccStates {
  var ERROR;

  AddAccountErrorState({required this.ERROR});
}

//############################################################################## GetAccount

class GetAccountsLoadingState extends ValoAccStates {}

class GetAccountsSuccessState extends ValoAccStates {}

class GetAccountsErrorState extends ValoAccStates {
  var ERROR;

  GetAccountsErrorState({required this.ERROR});}


//############################################################################## GetAccount

class ShareAccountsLoadingState extends ValoAccStates {}

class ShareAccountsSuccessState extends ValoAccStates {}

class ShareAccountsErrorState extends ValoAccStates {
  var ERROR;

  ShareAccountsErrorState({required this.ERROR});}


//############################################################################## UpdateAcc

class UpdateAccountsLoadingState extends ValoAccStates {}

class UpdateAccountsSuccessState extends ValoAccStates {}

class UpdateAccountsErrorState extends ValoAccStates {
  var ERROR;

  UpdateAccountsErrorState({required this.ERROR});}

//############################################################################## UpdateAccState

class UpdateAccountsStateLoadingState extends ValoAccStates {}

class UpdateAccountsStateSuccessState extends ValoAccStates {}

class UpdateAccountsStateErrorState extends ValoAccStates {
  var ERROR;

  UpdateAccountsStateErrorState({required this.ERROR});}
