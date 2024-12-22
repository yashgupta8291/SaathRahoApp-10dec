import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String?> uploadImageToCloudinary(File imageFile) async {
  const cloudName = 'dmy819zey';
  const apiKey = '865878158832592';

  final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

  // Generate timestamp and signature
  final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  // Create multipart request
  final request = http.MultipartRequest('POST', url);

  // Add file
  final fileStream = http.ByteStream(imageFile.openRead());
  final fileLength = await imageFile.length();

  final multipartFile = http.MultipartFile(
      'file',
      fileStream,
      fileLength,
      filename: 'image_${DateTime.now().millisecondsSinceEpoch}.jpg'
  );

  // Add fields to request
  request.files.add(multipartFile);
  request.fields['api_key'] = apiKey;
  request.fields['timestamp'] = timestamp.toString();
  request.fields['upload_preset'] = 'ml_default';

  try {
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print("Failed to upload image: ${response.body}");
      final responseData = json.decode(response.body);
      print(responseData['secure_url']);
      return responseData['secure_url'];

    } else {
      print("Failed to upload image: ${response.body}");
      return null;
    }
  } catch (e) {
    print("Error uploading image: $e");
    return null;
  }
}