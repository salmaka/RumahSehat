class GetDetailResepDTO {
  String id;
  String namaDokter;
  String namaPasien;
  String statusResep;
  String namaApoteker;
  List<dynamic> listObat;

  GetDetailResepDTO(this.id, this.namaDokter, this.namaPasien, this.statusResep, this.namaApoteker, this.listObat);
}