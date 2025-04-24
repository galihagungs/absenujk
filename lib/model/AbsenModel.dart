class AbsenModel {
  int? id;
  int? userId;
  double? masukLat;
  double? masukLong;
  String? masukAddress;
  String? masukDateTime;
  double? pulangLat;
  double? pulangLong;
  String? pulangAddress;
  String? pulangDateTime;

  AbsenModel({
    this.id,
    this.userId,
    this.masukLat,
    this.masukLong,
    this.masukAddress,
    this.masukDateTime,
    this.pulangLat,
    this.pulangLong,
    this.pulangAddress,
    this.pulangDateTime,
  });

  AbsenModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    masukLat = json['masukLat'];
    masukLong = json['masukLong'];
    masukAddress = json['masukAddress'];
    masukDateTime = json['masukDateTime'];
    pulangLat = json['pulangLat'];
    pulangLong = json['pulangLong'];
    pulangAddress = json['pulangAddress'];
    pulangDateTime = json['pulangDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['masukLat'] = this.masukLat;
    data['masukLong'] = this.masukLong;
    data['masukAddress'] = this.masukAddress;
    data['masukDateTime'] = this.masukDateTime;
    data['pulangLat'] = this.pulangLat;
    data['pulangLong'] = this.pulangLong;
    data['pulangAddress'] = this.pulangAddress;
    data['pulangDateTime'] = this.pulangDateTime;
    return data;
  }
}
