import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDeveloper extends StatelessWidget {
  final List<Map<String, String>> developers = [
    {
      'name': 'Seva Rival Ramadhan',
      'email': 'sevarival0311@gmail.com',
      'phone': '082283522949',
      'skill': 'Graphic Designer',
      'image': 'assets/images/rival.jpeg',
      'github': 'https://github.com/sevarival',
      'linkedin': 'https://linkedin.com/in/sevarival',
      'instagram': 'https://www.instagram.com/_rivaalr/',
    },
    {
      'name': 'Ricky Riotaro',
      'email': 'rickyriotar0@gmail.com',
      'phone': '0895393176699',
      'skill': 'Web Developer',
      'image': 'assets/images/taro.jpg',
      'github': 'https://github.com/rickyriotaro',
      'linkedin':
          'https://www.linkedin.com/in/ricky-riotaro-327915296?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app',
      'instagram': 'https://www.instagram.com/rrtaro_/',
    },
    {
      'name': 'M Solihun',
      'email': 'solihun@gmail.com',
      'phone': '082286462419',
      'skill': 'Data Analyst',
      'image': 'assets/images/solihun.jpeg',
      'github': 'https://github.com/msolihun',
      'linkedin': 'https://linkedin.com/in/msolihun',
      'instagram': 'https://www.instagram.com/solihunsir/',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Developer'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        backgroundColor: Color(0xFF0F558F),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: developers.map((developer) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0),
                        ),
                        child: Image.asset(
                          'assets/images/bg.png', // Ganti dengan path gambar background
                          height: 150.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: AssetImage(developer['image']!),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        developer['name']!,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        developer['skill']!,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.github,
                                color: Color.fromARGB(255, 0, 0, 0)),
                            onPressed: () {
                              _launchURL(developer['github']!);
                            },
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.linkedin,
                                color: Color.fromARGB(244, 0, 126, 245)),
                            onPressed: () {
                              _launchURL(developer['linkedin']!);
                            },
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.instagram,
                                color: Colors.red),
                            onPressed: () {
                              _launchURL(developer['instagram']!);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Politeknik Negeri Bengkalis',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
