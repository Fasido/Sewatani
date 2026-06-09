class AlatPreview {
  final String name;
  final String category;
  final String price;
  final String imagePath;
  final String location;
  final String description;
  final int stock;

  const AlatPreview({
    required this.name,
    required this.category,
    required this.price,
    required this.imagePath,
    required this.location,
    required this.description,
    required this.stock,
  });
}

const List<AlatPreview> demoAlatList = [
  AlatPreview(
    name: 'Traktor Roda 2',
    category: 'Pengolahan Tanah',
    price: 'Rp150.000 / hari',
    imagePath: 'assets/images/alat_traktor.png',
    location: 'Lohbener, Indramayu',
    stock: 2,
    description:
        'Cocok untuk membantu proses pengolahan lahan sawah sebelum masa tanam. Kondisi alat terawat dan siap digunakan.',
  ),
  AlatPreview(
    name: 'Pompa Air Sawah',
    category: 'Irigasi',
    price: 'Rp75.000 / hari',
    imagePath: 'assets/images/alat_pompa_air.png',
    location: 'Jatibarang, Indramayu',
    stock: 3,
    description:
        'Pompa air untuk kebutuhan pengairan sawah. Praktis digunakan saat saluran air kurang lancar atau musim tanam.',
  ),
  AlatPreview(
    name: 'Cultivator',
    category: 'Pengolahan Tanah',
    price: 'Rp120.000 / hari',
    imagePath: 'assets/images/alat_cultivator.png',
    location: 'Sindang, Indramayu',
    stock: 1,
    description:
        'Alat untuk menggemburkan tanah dan membantu pekerjaan pertanian skala kecil sampai menengah.',
  ),
  AlatPreview(
    name: 'Mesin Panen Mini',
    category: 'Panen',
    price: 'Rp250.000 / hari',
    imagePath: 'assets/images/alat_harvester.png',
    location: 'Kandanghaur, Indramayu',
    stock: 1,
    description:
        'Mesin panen mini untuk membantu proses panen menjadi lebih cepat dan efisien.',
  ),
];
