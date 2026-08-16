import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/user_profile_model.dart';



class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  

  
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print("Error getting profile: $e");
      return null;
    }
  }
}