class Jasa {
  final int id;
  final String kategori;
  final String nama_jasa;
  final String harga;
  final String deskripsi;
  final String no_hp;
  final String logo;

  const Jasa({
    required this.id,
    required this.kategori,
    required this.nama_jasa,
    required this.harga,
    required this.deskripsi,
    required this.no_hp,
    required this.logo,
  });

  factory Jasa.fromJson(Map<String, dynamic> json) {
    return Jasa(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      kategori: json['kategori'],
      nama_jasa: json['nama_jasa'],
      harga: json['harga'].toString(), // Ensure 'harga' is a String
      deskripsi: json['deskripsi'],
      no_hp: json['no_hp'],
      logo: json['logo'],
    );
  }
}
