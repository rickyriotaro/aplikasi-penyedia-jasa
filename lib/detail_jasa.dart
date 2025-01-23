import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'jasa.dart';

class DetailJasa extends StatelessWidget {
  final Jasa data;

  const DetailJasa({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0F558F),
        title: Center(
          child: Text('Detail Jasa'),
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: EdgeInsets.all(16.0),
          child: Card(
            color: Color(0xFFF2F5F7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 200,
                    child: Image.network(
                      'http://192.168.88.8/kelompok7/image/logo/${data.logo}',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    data.nama_jasa,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Harga: ${data.harga}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF0F558F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    data.deskripsi,
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton.icon(
                    onPressed: () => _launchWhatsApp(context, data),
                    icon: Icon(Icons.message, color: Colors.white),
                    label: Text('Hubungi via WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchWhatsApp(BuildContext context, Jasa data) async {
    String phoneNumber = data.no_hp;
    String message = 'Halo, saya tertarik dengan jasa ${data.nama_jasa}. '
        'Bisa berikan informasi lebih lanjut?';

    String url =
        'https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Gagal membuka WhatsApp. Pastikan aplikasi WhatsApp terinstal.'),
        ),
      );
    }
  }
}
