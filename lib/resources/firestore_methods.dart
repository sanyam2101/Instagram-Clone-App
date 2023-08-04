import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = 'some error occurred';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        postId: postId,
        username: username,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "Success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(
    String postId,
    String uid,
    String text,
    String name,
    String profilePic,
  ) async {
    String res = 'some error occurred';
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'commentId': commentId,
          'postId': postId,
          'name': name,
          'uid': uid,
          'text': text,
          'datePublished': DateTime.now(),
          'likes': [],
        });
        res = 'Success';
      } else {
        res = 'Text is empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likeComment(
      String postId, String commentId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //deleting post
  Future<String> deletePost(String postId) async {
    String res = 'some error occurred';
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> followUser(
      String uid,
      String followId
      ) async {
    try{
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      
      if(following.contains(followId)){
       await _firestore.collection('users').doc(followId).update({
         'followers': FieldValue.arrayRemove([uid]),
       });

       await _firestore.collection('users').doc(uid).update({
         'following': FieldValue.arrayRemove([followId]),
       });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
      
    } catch (e) {
      print(e.toString());
    }
  }


  Future<void> updateProfilePic(String uid, Uint8List file) async {
    try {
      String photoUrl =
      await StorageMethods().uploadImageToStorage('profilePics', file, false);
        await _firestore
            .collection('users')
            .doc(uid)
            .update({
          'photoUrl': photoUrl,
        });
    } catch (e) {
       print(e.toString());
    }
  }
}
