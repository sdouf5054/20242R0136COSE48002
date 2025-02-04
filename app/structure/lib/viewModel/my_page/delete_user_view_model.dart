import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:structure/components/custom_dialog.dart';
import 'package:structure/components/custom_pop_up.dart';
import 'package:structure/config/labels.dart';
import 'package:structure/config/palette.dart';
import 'package:structure/dataSource/local_data_source.dart';
import 'package:structure/dataSource/remote_data_source.dart';
import 'package:structure/model/user_model.dart';

class DeleteUserViewModel with ChangeNotifier {
  UserModel userModel;
  BuildContext context;
  DeleteUserViewModel({required this.userModel, required this.context});
  bool isActivateButton = false;
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  bool _isValidPw = false;

  /// 기존 비밀번호 유효성 검사
  String? pwValidate(String? value) {
    isActivateButton = true;
    notifyListeners();

    if (value!.isEmpty) {
      _isValidPw = false;
      return '비밀번호를 입력하세요.';
    } else {
      _isValidPw = true;
      return null;
    }
  }

  /// 값이 올바르게 입력됐는지 확인
  bool isValid() {
    if (_isValidPw) {
      return true;
    } else {
      return false;
    }
  }

  /// 회원 탈퇴 cancel
  void popDialogCancel() {
    isLoading = false;
    notifyListeners();
    context.pop();
  }

  /// 회원 탈퇴 confirm
  void popDialogConfirm() async {
    isLoading = true;
    notifyListeners();
    context.pop();

    try {
      // DB에서 유저 삭제 API 호출
      final response = await RemoteDataSource.deleteUser(userModel.userId!);

      if (response != 200) {
        throw ErrorDescription(response);
      }

      password.clear();

      await LocalDataSource.deleteLocalData(userModel.userId!);
      await LocalDataSource.saveDataToLocal(
          jsonEncode({'auto': null}), 'auto.json');
      userModel.reset();

      if (context.mounted) context.go('/sign-in');
      _showSnackBar('회원 탈퇴가 성공적으로 처리되었습니다.');
    } catch (e) {
      isLoading = false;
      notifyListeners();

      if (context.mounted) showErrorPopup(context, error: e.toString());
    }
  }

  /// 회원 탈퇴 함수
  Future<void> deleteUser() async {
    isLoading = true;
    notifyListeners();

    try {
      // 기존 firebase user 정보 불러오기 (현재 로그인된 유저)
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // 비밀번호 변경 전 firebase에 재인증 필요
        await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: userModel.userId!,
            password: password.text,
          ),
        );

        // 비밀번호 인증 통과하면 최종 확인 팝업 후 탈퇴 진행
        isLoading = false;
        notifyListeners();
        if (context.mounted) {
          showDeleteIdDialog(context, popDialogCancel, popDialogConfirm);
        }
      } else {
        throw ErrorDescription('User does not exist');
      }
    } on FirebaseException catch (e) {
      debugPrint('error: ${e.code}');
      if (e.code == 'wrong-password') {
        _showSnackBar(Labels.pwdNotSame); // 기존 비밀번호가 틀리면 alert 생성
      } else {
        throw ErrorDescription(e.code);
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (context.mounted) showErrorPopup(context, error: e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  /// 오류 snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(message),
        backgroundColor: Palette.error,
      ),
    );
  }
}
