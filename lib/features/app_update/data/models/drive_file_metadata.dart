class DriveFileMetadata {
  const DriveFileMetadata({
    required this.id,
    required this.name,
    required this.webContentLink,
    required this.resourceKey,
    required this.canDownload,
  });

  factory DriveFileMetadata.fromJson(Map<String, dynamic> json) {
    final capabilities = json['capabilities'] as Map<String, dynamic>?;

    return DriveFileMetadata(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      webContentLink: json['webContentLink'] as String?,
      resourceKey: json['resourceKey'] as String?,
      canDownload: capabilities?['canDownload'] as bool? ?? false,
    );
  }

  final String id;
  final String name;
  final String? webContentLink;
  final String? resourceKey;
  final bool canDownload;
}
