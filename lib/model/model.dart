class ModelSpk {
  final String nama;
  final String nomor;
  final String spk;

  ModelSpk._({this.nama, this.nomor, this.spk});

  factory ModelSpk.fromJson(Map<String, dynamic> json) {
    return new ModelSpk._(
      nama: json['nama'],
      nomor: json['nomor'],
      spk: json['spk'],
    );
  }
}
