import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_reddit_clone/core/constants/constants.dart';
import 'package:flutter_reddit_clone/core/constants/firebase_constants.dart';
import 'package:flutter_reddit_clone/core/failure.dart';
import 'package:flutter_reddit_clone/core/providers/firebase_providers.dart';
import 'package:flutter_reddit_clone/core/type_df.dart';
import 'package:flutter_reddit_clone/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    firebaseAuth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn
          .signIn();

      final googleAuth = await googleSignInAccount?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      debugPrint("user authenticated: ${userCredential.user?.displayName}");
      final User? user = userCredential.user;

      late UserModel userModel;
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          uid: user?.uid ?? "",
          name: user?.displayName ?? "Guest User",
          profilePic: user?.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          isAuthenticated: true,
          karma: 0,
          awards: [],
        );
        await _users.doc(user?.uid).set(userModel.toJson());
      } else {
        userModel = await getUserData(user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      debugPrint(e.toString());
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String userId) {
    return _users
        .doc(userId)
        .snapshots()
        .map(
          (snapshot) =>
              UserModel.fromJson(snapshot.data() as Map<String, dynamic>),
        );
  }
}
