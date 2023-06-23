class GetAppointmentDTO {
  final String kode;
  final String namaDokter;
  final String tanggal;
  final String jam;
  final bool isDone;

  GetAppointmentDTO(this.kode, this.namaDokter, this.tanggal, this.jam, this.isDone);
}