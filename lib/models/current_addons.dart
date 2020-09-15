class CurrentAddons {
  bool isUpdated;
  String btnText;
  String onPCFolderName;
  String onPCTocTitle;
  String onPCVersion;
  String onPCDependencies;
  String dependencies;
  String addonName;
  String thumbnailUrl;
  String latestVersion;
  String gameVersion;
  String source;
  String authors;
  String filename;
  String currentAddonGameVersion;
  String slug;
  String downloadUrl;

  CurrentAddons({
    this.btnText = "",
    this.isUpdated = true,
    this.onPCFolderName,
    this.onPCTocTitle,
    this.onPCVersion,
    this.onPCDependencies,
    this.dependencies,
    this.addonName,
    this.thumbnailUrl,
    this.latestVersion,
    this.gameVersion,
    this.source,
    this.authors,
    this.filename,
    this.currentAddonGameVersion,
    this.slug,
    this.downloadUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['btnText'] = this.btnText;
    data['isUpdated'] = this.isUpdated;
    data['onPCFolderName'] = this.onPCFolderName;
    data['onPCTocTitle'] = this.onPCTocTitle;
    data['onPCVersion'] = this.onPCVersion;
    data['onPCDependencies'] = this.onPCDependencies;
    data['dependencies'] = this.dependencies;
    data['addonName'] = this.addonName;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['latestVersion'] = this.latestVersion;
    data['gameVersion'] = this.gameVersion;
    data['source'] = this.source;
    data['authors'] = this.authors;
    data['filename'] = this.filename;
    data['currentAddonGameVersion'] = this.currentAddonGameVersion;
    data['slug'] = this.slug;
    data['downloadUrl'] = this.downloadUrl;
    return data;
  }
}
