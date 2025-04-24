// lib\features\auth\data\models\register_response_model.dart

class RegisterResponseModel {
  final String email;

  RegisterResponseModel({required this.email});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(email: json['email']);
  }
}