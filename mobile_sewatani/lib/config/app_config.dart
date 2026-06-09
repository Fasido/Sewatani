class AppConfig {
  static const String baseUrl = 'http://192.168.10.11/api_sewatani';

  static String imageUrl(String fileName) {
    if (fileName.isEmpty) return '';

    if (fileName.startsWith('http://') || fileName.startsWith('https://')) {
      return fileName;
    }

    if (fileName.startsWith('uploads/')) {
      return '$baseUrl/$fileName';
    }

    return '$baseUrl/assets/images/$fileName';
  }
}
