class iTunesMedia {
  final String title;
  final String artist;
  final String artworkUrl;
  final String previewUrl;
  final String mediaType;
  final String description;
  final String primaryGenreName;

  iTunesMedia({
    required this.title,
    required this.artist,
    required this.artworkUrl,
    required this.previewUrl,
    required this.mediaType,
    required this.description,
    required this.primaryGenreName
  });

  factory iTunesMedia.fromJson(Map<String, dynamic> json) {
    return iTunesMedia(

      title: json['trackName'] ?? json['collectionName'] ?? json['artistName'] ?? '',
      artist: json['artistName'] ?? '',
      artworkUrl: json['artworkUrl100'] ?? 'https://www.anelto.com/wp-content/uploads/2021/08/placeholder-image.png',
      previewUrl: json['previewUrl'] ?? json['collectionViewUrl'] ?? json['artistLinkUrl']??'',
      mediaType: json['kind'] ?? json['collectionType'] ?? json['artistType'] ?? '',
      description: json['longDescription'] ?? '',
      primaryGenreName: json['primaryGenreName'] ?? '',
    );
  }
}
