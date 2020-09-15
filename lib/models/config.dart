class Config {
  String wowRetailFolder;
  String wowBetaFolder;
  String wowRetailPTRFolder;
  String wowClassicFolder;

  Config({this.wowRetailFolder, this.wowBetaFolder, this.wowRetailPTRFolder, this.wowClassicFolder});

  Config.fromJson(Map<String, dynamic> json) {
    wowRetailFolder = json['wowRetailFolder'];
    wowBetaFolder = json['wowBetaFolder'];
    wowRetailPTRFolder = json['wowRetailPTRFolder'];
    wowClassicFolder = json['wowClassicFolder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wowRetailFolder'] = this.wowRetailFolder;
    data['wowBetaFolder'] = this.wowBetaFolder;
    data['wowRetailPTRFolder'] = this.wowRetailPTRFolder;
    data['wowClassicFolder'] = this.wowClassicFolder;
    return data;
  }
}
