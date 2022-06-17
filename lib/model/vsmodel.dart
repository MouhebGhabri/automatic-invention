class VsModel {
  String? status;
  List<Data>? data;

  VsModel({this.status, this.data});

  VsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? vsId;
  String? temp;
  String? gluc;
  String? bmp;
  int? vsuser;

  Data({this.vsId, this.temp, this.gluc, this.bmp, this.vsuser});

  Data.fromJson(Map<String, dynamic> json) {
    vsId = json['vs_id'];
    temp = json['temp'];
    gluc = json['gluc'];
    bmp = json['bmp'];
    vsuser = json['vsuser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vs_id'] = this.vsId;
    data['temp'] = this.temp;
    data['gluc'] = this.gluc;
    data['bmp'] = this.bmp;
    data['vsuser'] = this.vsuser;
    return data;
  }
}
