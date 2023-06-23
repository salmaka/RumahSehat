class SaldoUpdateDTO {
  String? username;
  final int? saldo;

  SaldoUpdateDTO(this.username, this.saldo);

  Map<String, dynamic> toJson() {
    return {'saldo': saldo, 'username': username};
  }
}
