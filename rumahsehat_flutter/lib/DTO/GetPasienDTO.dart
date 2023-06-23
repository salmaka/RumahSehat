class GetPasienDTO {
  final String? nama;
  final String? username;
  final String? password;
  final String? email;
  final int? saldo;
  final int? umur;

  GetPasienDTO(this.nama, this.username, this.password, this.email, this.saldo,
      this.umur);

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'username': username,
      'password': password,
      'email': email,
      'saldo': saldo,
      'umur': umur
    };
  }
}
