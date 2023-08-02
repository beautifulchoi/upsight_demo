import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
var logger = Logger();

enum AuthStatus {
  registerSuccess,
  registerFail,
  loginSuccess,
  loginFail,
}

class FirebaseAuthProvider with ChangeNotifier{
  FirebaseAuth authClient;
  User? user;
  FirebaseAuthProvider({auth}) : authClient = auth ?? FirebaseAuth.instance;
  /// 회원가입
  Future<AuthStatus> createUser(String email, String pw) async {
    try {
      UserCredential credential = await authClient
          .createUserWithEmailAndPassword(
        email: email,
        password: pw,
      );
      logger.d(credential);

    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      return AuthStatus.registerFail;
    }
    return AuthStatus.registerSuccess;
  }

  /// 로그인
  Future<AuthStatus> signIn(String email, String pw) async {
    try {
      final UserCredential userCredential = await authClient
          .signInWithEmailAndPassword(
        email: email,
        password: pw,
      );
      // Login successful
      final User? user = userCredential.user;
      if (user != null) {
        logger.i('Login successful for user: ${user.email}');
        logger.d('persist on');
        authPersistence();
        notifyListeners();
        return AuthStatus.loginSuccess;
      } else {
        return AuthStatus.loginFail;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        logger.w('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        logger.w('Wrong password provided for that user.');
      } else {
        logger.e('Firebase Authentication Exception: ${e.code}');
      }
      return AuthStatus.loginFail;
    } catch (e) {
      logger.e('Error during login: $e');
      return AuthStatus.loginFail;
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    await authClient.signOut();
    logger.d("로그아웃");
    notifyListeners();
  }

  /// 회원가입, 로그인시 사용자 영속
  void authPersistence() async {
    await authClient.setPersistence(Persistence.SESSION);
  }

  /// 유저 삭제
  Future<void> deleteUser(String email) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.delete();
      } catch (e) {
        // If an error occurs during deletion, throw an exception
        throw Exception("Error deleting user: $e");
      }
    } else {
      throw Exception("No user found to delete.");
    }
  }

  /// 현재 유저 정보 조회
  Map<String, dynamic>? getUserAttributes() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final name = user.displayName;
      final email = user.email;
      final photoUrl = user.photoURL;

      final emailVerified = user.emailVerified;
      final uid = user.uid;

      return {
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'emailVerified': emailVerified,
        'uid': uid,
      };
    }
    return null;
  }


  /// 공급자로부터 유저 정보 조회
  User? getUserFromSocial() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (final providerProfile in user.providerData) {
        // ID of the provider (google.com, apple.cpm, etc.)
        final provider = providerProfile.providerId;

        // UID specific to the provider
        final uid = providerProfile.uid;

        // Name, email address, and profile photo URL
        final name = providerProfile.displayName;
        final emailAddress = providerProfile.email;
        final profilePhoto = providerProfile.photoURL;
      }
    }
    return user;
  }

  /// 유저 이름 업데이트
  Future<void> updateProfileName(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.updateDisplayName(name);
  }

  /// 유저 url 업데이트
  Future<void> updateProfileUrl(String url) async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.updatePhotoURL(url);
  }

  /// 비밀번호 초기화 메일보내기
  Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.setLanguageCode("kr");
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

}