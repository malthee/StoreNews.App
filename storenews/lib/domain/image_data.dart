import 'dart:convert';
import 'dart:typed_data';

class ImageData {
  final String id;
  final String altText;
  final Uint8List data;

  ImageData({
    required this.id,
    required this.altText,
    required String sourceString,
  }) : data = base64Decode(sourceString);

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      id: json['id'],
      altText: json['altText'],
      sourceString: json['data'],
    );
  }
}
