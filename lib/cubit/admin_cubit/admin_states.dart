 
abstract class AdminStates {}

class InitUserState extends AdminStates {}

class UserLoadingState extends AdminStates {}

class UserSuccessState extends AdminStates {}
 
class ChangeDropDownState extends AdminStates {}

class UserErrorState extends AdminStates { 
}

class ProfileImagePickedSuccessState extends AdminStates {}

class ProfileImagePickedErrorState extends AdminStates {}

class CoverImagePickedSuccessState extends AdminStates {}

class CoverImagePickedErrorState extends AdminStates {}

class ProfileImageUploadSuccessState extends AdminStates {}

class ProfileImageUploadErrorState extends AdminStates {}

class CoverImageUploadSuccessState extends AdminStates {}

class CoverImageUploadErrorState extends AdminStates {}

class ProfileImageUpdateSuccessState extends AdminStates {}

class ProfileImageUpdateErrorState extends AdminStates {}

class CoverImageUpdateSuccessState extends AdminStates {}

class CoverImageUpdateErrorState extends AdminStates {}

class UpdateMyCategoryLoadingState extends AdminStates {}

class UpdateMyCategorySuccessState extends AdminStates {}

class UpdateMyCategoryErrorState extends AdminStates {}

class UploadImgessState extends AdminStates {}

class AddRoomSuccessState extends AdminStates {}

class AddRoomErrorState extends AdminStates {}

class UpdateRoomSuccessState extends AdminStates {}

class UpdateRoomErrorState extends AdminStates {}

class UpdateCategoryImageSuccessState extends AdminStates {}

class UpdateCategoryImageErrorState extends AdminStates {}

class RemoveSelectedRoomState extends AdminStates {}

class RemoveEditedRoomState extends AdminStates {}

class AddSelectedRoomState extends AdminStates {
  final bool isAdd;
  AddSelectedRoomState(this.isAdd);
}

class SetCategoryModelState extends AdminStates {}

class BigSelectedRoomState extends AdminStates {}

class ProblemSelectedRoomState extends AdminStates {}

class NoSelectedRoomState extends AdminStates {}

class ChangeAddCheckBoxState extends AdminStates {}

class ChangeRemoveCheckBoxState extends AdminStates {}

class SetIsOfferState extends AdminStates {}

class ProfileImageClearedState extends AdminStates {}

class ProfileImageUploadLoadingState extends AdminStates {}

class DeleteCategorySuccessState extends AdminStates {}

class DeleteCategoryErrorState extends AdminStates {}

class SetNameState extends AdminStates {}
