import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:rumahsehat_flutter/pages/list_tagihan.dart';
import 'package:rumahsehat_flutter/pages/view_profile_user.dart';
import 'package:rumahsehat_flutter/pages/viewall_appointment.dart';

import 'form_create_appointment.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rumah Sehat'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: FlutterSession().get("token"),
        builder: (context, snapshot) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                  // Text(snapshot.data.toString()), // TODO: debug
                  const Text(
                    'Selamat Datang di',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'Rumah Sehat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ViewUserProfile(token: snapshot.data.toString());
                      }));
                    },
                    child: const Text('Lihat Profile User'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FormCreateAppointment(
                          token: snapshot.data.toString(),
                        );
                      }));
                    },
                    child: const Text('Buat Appointment'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ViewAllAppointment(
                          token: snapshot.data.toString(),
                        );
                      }));
                    },
                    child: const Text('Lihat Semua Appointment'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ViewAllTagihan(token: snapshot.data.toString());
                      }));
                    },
                    child: const Text('Detail Tagihan'),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
