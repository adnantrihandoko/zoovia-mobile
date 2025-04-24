// models/appointment_model.dart
class AntrianModel {
  final int queueNumber;
  final String serviceName;
  final String patientName;
  final int nextQueueNumber;

  AntrianModel({
    required this.queueNumber,
    required this.serviceName,
    required this.patientName,
    required this.nextQueueNumber,
  });
}