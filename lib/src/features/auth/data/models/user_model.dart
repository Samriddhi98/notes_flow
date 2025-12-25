import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.id, required super.email});

  // Factory constructor to create a UserModel from a Supabase User object
  factory UserModel.fromJson(User user) {
    return UserModel(
      id: user.id,
      email:
          user.email ??
          '', // Supabase user email might be null sometimes in advanced flows
    );
  }
}
