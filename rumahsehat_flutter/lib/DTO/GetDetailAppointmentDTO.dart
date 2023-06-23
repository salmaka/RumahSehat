class GetDetailAppointmentDTO {
  String kode;
  bool isDone;
  String tanggal;
  String jam;
  String namaDokter;
  String idResep;

  GetDetailAppointmentDTO(this.kode, this.isDone, this.tanggal, this.jam, this.namaDokter, this.idResep);
}