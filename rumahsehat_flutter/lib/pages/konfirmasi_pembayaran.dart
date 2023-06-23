import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rumahsehat_flutter/DTO/GetDetailAppointmentDTO.dart';

import 'package:http/http.dart' as http;
import 'package:rumahsehat_flutter/DTO/TagihanDTO.dart';
import 'package:rumahsehat_flutter/pages/tagihan_sukses.dart';

class KonfirmasiPembayaran extends StatelessWidget {
  // Handle tagihan lanjutan
  late final TagihanDTO newTagihan;
  late final String token;

  KonfirmasiPembayaran({required this.token, required this.newTagihan});

  // Handle untuk fix pembayaran
  late final String noTagihan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rumah Sehat'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Konfirmasi Pembayaran Tagihan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                      elevation: 20,
                      shadowColor: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Total tagihan Anda sebesar Rp.${newTagihan.jumlahTagihan}. Tekan tombol konfirmasi pembayaran untuk melanjutkan pembayaran',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ButtonPembayaran(
                            token: token, noTagihan: newTagihan.nomorTagihan),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class ButtonPembayaran extends StatelessWidget {
  late final String noTagihan;
  late final String token;
  // late final TagihanDTO updatedTagihan;

  ButtonPembayaran({required this.token, required this.noTagihan});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 12),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Pembayaran(token: token, noTagihan: noTagihan);
            }));
          },
          child: const Text('Bayar Tagihan'),
        ));
  }
}
