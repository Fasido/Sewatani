class AppConfig {
  // PENTING:
  // Kalau run di HP fisik, jangan pakai localhost.
  // Ganti IP ini dengan IPv4 laptop dari ipconfig.
  //
  // Contoh:
  // static const String baseUrl = 'http://192.168.1.10/api_sewatani';
  //
  // Kalau pakai emulator Android bawaan:
  // static const String baseUrl = 'http://10.0.2.2/api_sewatani';

  static const String baseUrl = 'http://192.168.10.11/api_sewatani';

  static String imageUrl(String fileName) {
    if (fileName.isEmpty) return '';
    if (fileName.startsWith('http')) return fileName;
    return '$baseUrl/assets/images/$fileName';
  }
}
