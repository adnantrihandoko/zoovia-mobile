// features/auth/data/models/otp_response_model.dart
class OtpResponseModel {
  final String message;

  OtpResponseModel({required this.message});

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(message: json['message']);
  }
}