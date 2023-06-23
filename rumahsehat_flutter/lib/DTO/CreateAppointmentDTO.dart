class CreateAppointmentDTO {
  final DateTime waktuAwal;
  final String dokterId;
  final String pasienId;

  CreateAppointmentDTO(this.waktuAwal, this.dokterId, this.pasienId);

  Map<String, dynamic> toJson() {
    return {'waktuAwal':waktuAwal.toIso8601String(), 'dokterId': dokterId, 'pasienId': pasienId};
  }
}