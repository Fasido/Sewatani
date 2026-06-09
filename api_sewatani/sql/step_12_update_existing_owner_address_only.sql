USE sewatani_db;

UPDATE alat
SET
  nama_pemilik = COALESCE(nama_pemilik, 'Wardi'),
  alamat_lengkap = COALESCE(alamat_lengkap, 'Desa Dukuh RT 02 RW 03, Indramayu')
WHERE nama_pemilik IS NULL OR alamat_lengkap IS NULL;
