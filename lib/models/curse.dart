enum ReleaseType { None, Release, Beta, Alpha }

class CurseAddon {
  bool isUpdate;
  var id;
  String name;
  List<Authors> authors;
  List<Attachments> attachments;
  String websiteUrl;
  var gameId;
  String summary;
  var defaultFileId;
  var downloadCount;
  List<LatestFiles> latestFiles;
  List<Categories> categories;
  var status;
  var primaryCategoryId;
  CategorySection categorySection;
  String slug;
  List<GameVersionLatestFiles> gameVersionLatestFiles;
  bool isFeatured;
  double popularityScore;
  var gamePopularityRank;
  String primaryLanguage;
  String gameSlug;
  String gameName;
  String portalName;
  String dateModified;
  String dateCreated;
  String dateReleased;
  bool isAvailable;
  bool isExperiemental;

  CurseAddon(
      {this.isUpdate,
      this.id,
      this.name,
      this.authors,
      this.attachments,
      this.websiteUrl,
      this.gameId,
      this.summary,
      this.defaultFileId,
      this.downloadCount,
      this.latestFiles,
      this.categories,
      this.status,
      this.primaryCategoryId,
      this.categorySection,
      this.slug,
      this.gameVersionLatestFiles,
      this.isFeatured,
      this.popularityScore,
      this.gamePopularityRank,
      this.primaryLanguage,
      this.gameSlug,
      this.gameName,
      this.portalName,
      this.dateModified,
      this.dateCreated,
      this.dateReleased,
      this.isAvailable,
      this.isExperiemental});

  CurseAddon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['authors'] != null) {
      authors = new List<Authors>();
      json['authors'].forEach((v) {
        authors.add(new Authors.fromJson(v));
      });
    }
    if (json['attachments'] != null) {
      attachments = new List<Attachments>();
      json['attachments'].forEach((v) {
        attachments.add(new Attachments.fromJson(v));
      });
    }
    websiteUrl = json['websiteUrl'];
    gameId = json['gameId'];
    summary = json['summary'];
    defaultFileId = json['defaultFileId'];
    downloadCount = json['downloadCount'];
    if (json['latestFiles'] != null) {
      latestFiles = new List<LatestFiles>();
      json['latestFiles'].forEach((v) {
        latestFiles.add(new LatestFiles.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    status = json['status'];
    primaryCategoryId = json['primaryCategoryId'];
    categorySection = json['categorySection'] != null ? new CategorySection.fromJson(json['categorySection']) : null;
    slug = json['slug'];
    if (json['gameVersionLatestFiles'] != null) {
      gameVersionLatestFiles = new List<GameVersionLatestFiles>();
      json['gameVersionLatestFiles'].forEach((v) {
        gameVersionLatestFiles.add(new GameVersionLatestFiles.fromJson(v));
      });
    }
    isFeatured = json['isFeatured'];
    popularityScore = json['popularityScore'];
    gamePopularityRank = json['gamePopularityRank'];
    primaryLanguage = json['primaryLanguage'];
    gameSlug = json['gameSlug'];
    gameName = json['gameName'];
    portalName = json['portalName'];
    dateModified = json['dateModified'];
    dateCreated = json['dateCreated'];
    dateReleased = json['dateReleased'];
    isAvailable = json['isAvailable'];
    isExperiemental = json['isExperiemental'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.authors != null) {
      data['authors'] = this.authors.map((v) => v.toJson()).toList();
    }
    if (this.attachments != null) {
      data['attachments'] = this.attachments.map((v) => v.toJson()).toList();
    }
    data['websiteUrl'] = this.websiteUrl;
    data['gameId'] = this.gameId;
    data['summary'] = this.summary;
    data['defaultFileId'] = this.defaultFileId;
    data['downloadCount'] = this.downloadCount;
    if (this.latestFiles != null) {
      data['latestFiles'] = this.latestFiles.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['primaryCategoryId'] = this.primaryCategoryId;
    if (this.categorySection != null) {
      data['categorySection'] = this.categorySection.toJson();
    }
    data['slug'] = this.slug;
    if (this.gameVersionLatestFiles != null) {
      data['gameVersionLatestFiles'] = this.gameVersionLatestFiles.map((v) => v.toJson()).toList();
    }
    data['isFeatured'] = this.isFeatured;
    data['popularityScore'] = this.popularityScore;
    data['gamePopularityRank'] = this.gamePopularityRank;
    data['primaryLanguage'] = this.primaryLanguage;
    data['gameSlug'] = this.gameSlug;
    data['gameName'] = this.gameName;
    data['portalName'] = this.portalName;
    data['dateModified'] = this.dateModified;
    data['dateCreated'] = this.dateCreated;
    data['dateReleased'] = this.dateReleased;
    data['isAvailable'] = this.isAvailable;
    data['isExperiemental'] = this.isExperiemental;
    return data;
  }
}

class Authors {
  String name;
  String url;
  var projectId;
  var id;
  var projectTitleId;
  String projectTitleTitle;
  var userId;
  var twitchId;

  Authors({this.name, this.url, this.projectId, this.id, this.projectTitleId, this.projectTitleTitle, this.userId, this.twitchId});

  Authors.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    projectId = json['projectId'];
    id = json['id'];
    projectTitleId = json['projectTitleId'];
    projectTitleTitle = json['projectTitleTitle'];
    userId = json['userId'];
    twitchId = json['twitchId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    data['projectId'] = this.projectId;
    data['id'] = this.id;
    data['projectTitleId'] = this.projectTitleId;
    data['projectTitleTitle'] = this.projectTitleTitle;
    data['userId'] = this.userId;
    data['twitchId'] = this.twitchId;
    return data;
  }
}

class Attachments {
  var id;
  var projectId;
  String description;
  bool isDefault;
  String thumbnailUrl;
  String title;
  String url;
  var status;

  Attachments({this.id, this.projectId, this.description, this.isDefault, this.thumbnailUrl, this.title, this.url, this.status});

  Attachments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['projectId'];
    description = json['description'];
    isDefault = json['isDefault'];
    thumbnailUrl = json['thumbnailUrl'];
    title = json['title'];
    url = json['url'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['projectId'] = this.projectId;
    data['description'] = this.description;
    data['isDefault'] = this.isDefault;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['title'] = this.title;
    data['url'] = this.url;
    data['status'] = this.status;
    return data;
  }
}

class LatestFiles {
  var id;
  String displayName;
  String fileName;
  String fileDate;
  var fileLength;
  var releaseType;
  var fileStatus;
  String downloadUrl;
  bool isAlternate;
  var alternateFileId;
  List<Dependencies> dependencies;
  bool isAvailable;
  List<Modules> modules;
  var packageFingerprint;
  List<String> gameVersion;
  List<SortableGameVersion> sortableGameVersion;
  Null installMetadata;
  Null changelog;
  bool hasInstallScript;
  bool isCompatibleWithClient;
  var categorySectionPackageType;
  var restrictProjectFileAccess;
  var projectStatus;
  var renderCacheId;
  Null fileLegacyMappingId;
  var projectId;
  var parentProjectFileId;
  Null parentFileLegacyMappingId;
  var fileTypeId;
  bool exposeAsAlternative;
  var packageFingerprintId;
  String gameVersionDateReleased;
  var gameVersionMappingId;
  var gameVersionId;
  var gameId;
  bool isServerPack;
  Null serverPackFileId;
  String gameVersionFlavor;

  LatestFiles(
      {this.id,
      this.displayName,
      this.fileName,
      this.fileDate,
      this.fileLength,
      this.releaseType,
      this.fileStatus,
      this.downloadUrl,
      this.isAlternate,
      this.alternateFileId,
      this.dependencies,
      this.isAvailable,
      this.modules,
      this.packageFingerprint,
      this.gameVersion,
      this.sortableGameVersion,
      this.installMetadata,
      this.changelog,
      this.hasInstallScript,
      this.isCompatibleWithClient,
      this.categorySectionPackageType,
      this.restrictProjectFileAccess,
      this.projectStatus,
      this.renderCacheId,
      this.fileLegacyMappingId,
      this.projectId,
      this.parentProjectFileId,
      this.parentFileLegacyMappingId,
      this.fileTypeId,
      this.exposeAsAlternative,
      this.packageFingerprintId,
      this.gameVersionDateReleased,
      this.gameVersionMappingId,
      this.gameVersionId,
      this.gameId,
      this.isServerPack,
      this.serverPackFileId,
      this.gameVersionFlavor});

  LatestFiles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['displayName'];
    fileName = json['fileName'];
    fileDate = json['fileDate'];
    fileLength = json['fileLength'];
    releaseType = json['releaseType'];
    fileStatus = json['fileStatus'];
    downloadUrl = json['downloadUrl'];
    isAlternate = json['isAlternate'];
    alternateFileId = json['alternateFileId'];
    if (json['dependencies'] != null) {
      dependencies = new List<Dependencies>();
      json['dependencies'].forEach((v) {
        dependencies.add(new Dependencies.fromJson(v));
      });
    }
    isAvailable = json['isAvailable'];
    if (json['modules'] != null) {
      modules = new List<Modules>();
      json['modules'].forEach((v) {
        modules.add(new Modules.fromJson(v));
      });
    }
    packageFingerprint = json['packageFingerprint'];
    gameVersion = json['gameVersion'].cast<String>();
    if (json['sortableGameVersion'] != null) {
      sortableGameVersion = new List<SortableGameVersion>();
      json['sortableGameVersion'].forEach((v) {
        sortableGameVersion.add(new SortableGameVersion.fromJson(v));
      });
    }
    installMetadata = json['installMetadata'];
    changelog = json['changelog'];
    hasInstallScript = json['hasInstallScript'];
    isCompatibleWithClient = json['isCompatibleWithClient'];
    categorySectionPackageType = json['categorySectionPackageType'];
    restrictProjectFileAccess = json['restrictProjectFileAccess'];
    projectStatus = json['projectStatus'];
    renderCacheId = json['renderCacheId'];
    fileLegacyMappingId = json['fileLegacyMappingId'];
    projectId = json['projectId'];
    parentProjectFileId = json['parentProjectFileId'];
    parentFileLegacyMappingId = json['parentFileLegacyMappingId'];
    fileTypeId = json['fileTypeId'];
    exposeAsAlternative = json['exposeAsAlternative'];
    packageFingerprintId = json['packageFingerprintId'];
    gameVersionDateReleased = json['gameVersionDateReleased'];
    gameVersionMappingId = json['gameVersionMappingId'];
    gameVersionId = json['gameVersionId'];
    gameId = json['gameId'];
    isServerPack = json['isServerPack'];
    serverPackFileId = json['serverPackFileId'];
    gameVersionFlavor = json['gameVersionFlavor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['displayName'] = this.displayName;
    data['fileName'] = this.fileName;
    data['fileDate'] = this.fileDate;
    data['fileLength'] = this.fileLength;
    data['releaseType'] = this.releaseType;
    data['fileStatus'] = this.fileStatus;
    data['downloadUrl'] = this.downloadUrl;
    data['isAlternate'] = this.isAlternate;
    data['alternateFileId'] = this.alternateFileId;
    if (this.dependencies != null) {
      data['dependencies'] = this.dependencies.map((v) => v.toJson()).toList();
    }
    data['isAvailable'] = this.isAvailable;
    if (this.modules != null) {
      data['modules'] = this.modules.map((v) => v.toJson()).toList();
    }
    data['packageFingerprint'] = this.packageFingerprint;
    data['gameVersion'] = this.gameVersion;
    if (this.sortableGameVersion != null) {
      data['sortableGameVersion'] = this.sortableGameVersion.map((v) => v.toJson()).toList();
    }
    data['installMetadata'] = this.installMetadata;
    data['changelog'] = this.changelog;
    data['hasInstallScript'] = this.hasInstallScript;
    data['isCompatibleWithClient'] = this.isCompatibleWithClient;
    data['categorySectionPackageType'] = this.categorySectionPackageType;
    data['restrictProjectFileAccess'] = this.restrictProjectFileAccess;
    data['projectStatus'] = this.projectStatus;
    data['renderCacheId'] = this.renderCacheId;
    data['fileLegacyMappingId'] = this.fileLegacyMappingId;
    data['projectId'] = this.projectId;
    data['parentProjectFileId'] = this.parentProjectFileId;
    data['parentFileLegacyMappingId'] = this.parentFileLegacyMappingId;
    data['fileTypeId'] = this.fileTypeId;
    data['exposeAsAlternative'] = this.exposeAsAlternative;
    data['packageFingerprintId'] = this.packageFingerprintId;
    data['gameVersionDateReleased'] = this.gameVersionDateReleased;
    data['gameVersionMappingId'] = this.gameVersionMappingId;
    data['gameVersionId'] = this.gameVersionId;
    data['gameId'] = this.gameId;
    data['isServerPack'] = this.isServerPack;
    data['serverPackFileId'] = this.serverPackFileId;
    data['gameVersionFlavor'] = this.gameVersionFlavor;
    return data;
  }
}

class Dependencies {
  var id;
  var addonId;
  var type;
  var fileId;

  Dependencies({this.id, this.addonId, this.type, this.fileId});

  Dependencies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addonId = json['addonId'];
    type = json['type'];
    fileId = json['fileId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['addonId'] = this.addonId;
    data['type'] = this.type;
    data['fileId'] = this.fileId;
    return data;
  }
}

class Modules {
  String foldername;
  var Fingerprint;
  var type;

  Modules({this.foldername, this.Fingerprint, this.type});

  Modules.fromJson(Map<String, dynamic> json) {
    foldername = json['foldername'];
    Fingerprint = json['Fingerprint'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foldername'] = this.foldername;
    data['Fingerprint'] = this.Fingerprint;
    data['type'] = this.type;
    return data;
  }
}

class SortableGameVersion {
  String gameVersionPadded;
  String gameVersion;
  String gameVersionReleaseDate;
  String gameVersionName;

  SortableGameVersion({this.gameVersionPadded, this.gameVersion, this.gameVersionReleaseDate, this.gameVersionName});

  SortableGameVersion.fromJson(Map<String, dynamic> json) {
    gameVersionPadded = json['gameVersionPadded'];
    gameVersion = json['gameVersion'];
    gameVersionReleaseDate = json['gameVersionReleaseDate'];
    gameVersionName = json['gameVersionName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameVersionPadded'] = this.gameVersionPadded;
    data['gameVersion'] = this.gameVersion;
    data['gameVersionReleaseDate'] = this.gameVersionReleaseDate;
    data['gameVersionName'] = this.gameVersionName;
    return data;
  }
}

class Categories {
  var categoryId;
  String name;
  String url;
  String avatarUrl;
  var parentId;
  var rootId;
  var projectId;
  var avatarId;
  var gameId;

  Categories({this.categoryId, this.name, this.url, this.avatarUrl, this.parentId, this.rootId, this.projectId, this.avatarId, this.gameId});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    name = json['name'];
    url = json['url'];
    avatarUrl = json['avatarUrl'];
    parentId = json['parentId'];
    rootId = json['rootId'];
    projectId = json['projectId'];
    avatarId = json['avatarId'];
    gameId = json['gameId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['name'] = this.name;
    data['url'] = this.url;
    data['avatarUrl'] = this.avatarUrl;
    data['parentId'] = this.parentId;
    data['rootId'] = this.rootId;
    data['projectId'] = this.projectId;
    data['avatarId'] = this.avatarId;
    data['gameId'] = this.gameId;
    return data;
  }
}

class CategorySection {
  var id;
  var gameId;
  String name;
  var packageType;
  String path;
  String initialInclusionPattern;
  String extraIncludePattern;
  var gameCategoryId;

  CategorySection(
      {this.id, this.gameId, this.name, this.packageType, this.path, this.initialInclusionPattern, this.extraIncludePattern, this.gameCategoryId});

  CategorySection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gameId = json['gameId'];
    name = json['name'];
    packageType = json['packageType'];
    path = json['path'];
    initialInclusionPattern = json['initialInclusionPattern'];
    extraIncludePattern = json['extraIncludePattern'];
    gameCategoryId = json['gameCategoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['gameId'] = this.gameId;
    data['name'] = this.name;
    data['packageType'] = this.packageType;
    data['path'] = this.path;
    data['initialInclusionPattern'] = this.initialInclusionPattern;
    data['extraIncludePattern'] = this.extraIncludePattern;
    data['gameCategoryId'] = this.gameCategoryId;
    return data;
  }
}

class GameVersionLatestFiles {
  String gameVersion;
  var projectFileId;
  String projectFileName;
  var fileType;
  String gameVersionFlavor;

  GameVersionLatestFiles({this.gameVersion, this.projectFileId, this.projectFileName, this.fileType, this.gameVersionFlavor});

  GameVersionLatestFiles.fromJson(Map<String, dynamic> json) {
    gameVersion = json['gameVersion'];
    projectFileId = json['projectFileId'];
    projectFileName = json['projectFileName'];
    fileType = json['fileType'];
    gameVersionFlavor = json['gameVersionFlavor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameVersion'] = this.gameVersion;
    data['projectFileId'] = this.projectFileId;
    data['projectFileName'] = this.projectFileName;
    data['fileType'] = this.fileType;
    data['gameVersionFlavor'] = this.gameVersionFlavor;
    return data;
  }
}
