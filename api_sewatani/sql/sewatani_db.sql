CREATE DATABASE IF NOT EXISTS sewatani_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE sewatani_db;

DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS alat;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id_user INT AUTO_INCREMENT PRIMARY KEY,
  firebase_uid VARCHAR(150) NOT NULL UNIQUE,
  nama VARCHAR(120) NOT NULL,
  email VARCHAR(150) NOT NULL,
  photo_url TEXT NULL,
  role ENUM('petani', 'vendor') NOT NULL,
  fcm_token TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE alat (
  id_alat INT AUTO_INCREMENT PRIMARY KEY,
  id_vendor INT NOT NULL,
  nama_alat VARCHAR(120) NOT NULL,
  kategori VARCHAR(100) NOT NULL,
  deskripsi TEXT NOT NULL,
  harga_per_hari INT NOT NULL,
  stok INT NOT NULL DEFAULT 1,
  status ENUM('tersedia', 'tidak_tersedia') NOT NULL DEFAULT 'tersedia',
  foto_url TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_alat_vendor
    FOREIGN KEY (id_vendor) REFERENCES users(id_user)
    ON DELETE CASCADE
);

CREATE TABLE bookings (
  id_booking INT AUTO_INCREMENT PRIMARY KEY,
  id_user INT NOT NULL,
  id_alat INT NOT NULL,
  id_vendor INT NOT NULL,
  tanggal_mulai DATE NOT NULL,
  tanggal_selesai DATE NOT NULL,
  alamat TEXT NOT NULL,
  catatan TEXT NULL,
  status ENUM('menunggu', 'diterima', 'ditolak', 'selesai') NOT NULL DEFAULT 'menunggu',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_booking_user
    FOREIGN KEY (id_user) REFERENCES users(id_user)
    ON DELETE CASCADE,
  CONSTRAINT fk_booking_alat
    FOREIGN KEY (id_alat) REFERENCES alat(id_alat)
    ON DELETE CASCADE,
  CONSTRAINT fk_booking_vendor
    FOREIGN KEY (id_vendor) REFERENCES users(id_user)
    ON DELETE CASCADE
);

INSERT INTO users (firebase_uid, nama, email, photo_url, role) VALUES
('seed-vendor-001', 'Vendor SewaTani Indramayu', 'vendor@sewatani.test', '', 'vendor'),
('seed-petani-001', 'Fasido', 'fasido@sewatani.test', '', 'petani');

INSERT INTO alat (id_vendor, nama_alat, kategori, deskripsi, harga_per_hari, stok, status, foto_url) VALUES
(1, 'Traktor Roda 2', 'Pengolahan Tanah', 'Traktor roda dua untuk membantu proses pengolahan lahan sawah sebelum masa tanam.', 150000, 2, 'tersedia', 'alat_traktor.png'),
(1, 'Pompa Air Sawah', 'Irigasi', 'Pompa air untuk membantu pengairan sawah saat musim tanam dan kondisi lahan kering.', 75000, 3, 'tersedia', 'alat_pompa_air.png'),
(1, 'Cultivator', 'Pengolahan Tanah', 'Cultivator untuk menggemburkan tanah agar lebih siap ditanami.', 120000, 1, 'tersedia', 'alat_cultivator.png'),
(1, 'Mesin Panen Mini', 'Panen', 'Mesin panen ukuran kecil untuk membantu proses panen padi secara lebih cepat.', 250000, 1, 'tersedia', 'alat_harvester.png');

INSERT INTO bookings (id_user, id_alat, id_vendor, tanggal_mulai, tanggal_selesai, alamat, catatan, status) VALUES
(2, 1, 1, '2026-06-10', '2026-06-11', 'Lohbener, Indramayu', 'Butuh pagi hari setelah subuh.', 'menunggu');
