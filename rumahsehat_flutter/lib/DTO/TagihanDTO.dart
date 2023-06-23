// Yang belum: tanggaldibuat tanggal dibayar, dan appoinment

class TagihanDTO {
  final String nomorTagihan;
  final String tanggalTerbuat;
  final String status;
  final String idPasien;
  final String tanggalBayar;
  final int jumlahTagihan;

  TagihanDTO(this.nomorTagihan, this.tanggalTerbuat, this.status, this.idPasien,
      this.jumlahTagihan, this.tanggalBayar);
}
