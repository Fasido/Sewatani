<?php
require_once __DIR__ . "/../helpers/response.php";
require_once __DIR__ . "/../config/database.php";

set_headers();

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    json_response(false, "Method harus POST", null, 405);
}

$data = get_json_input();

require_fields($data, [
    "id_vendor",
    "nama_pemilik",
    "alamat_lengkap",
    "nama_alat",
    "kategori",
    "deskripsi",
    "harga_per_hari",
    "stok"
]);

$db = (new Database())->connect();

$stok = (int)$data["stok"];
$status = $stok > 0 ? ($data["status"] ?? "tersedia") : "tidak_tersedia";

$stmt = $db->prepare("
    INSERT INTO alat (
        id_vendor,
        nama_pemilik,
        alamat_lengkap,
        nama_alat,
        kategori,
        deskripsi,
        harga_per_hari,
        stok,
        status,
        foto_url
    ) VALUES (
        :id_vendor,
        :nama_pemilik,
        :alamat_lengkap,
        :nama_alat,
        :kategori,
        :deskripsi,
        :harga_per_hari,
        :stok,
        :status,
        :foto_url
    )
");

$stmt->execute([
    ":id_vendor" => $data["id_vendor"],
    ":nama_pemilik" => $data["nama_pemilik"],
    ":alamat_lengkap" => $data["alamat_lengkap"],
    ":nama_alat" => $data["nama_alat"],
    ":kategori" => $data["kategori"],
    ":deskripsi" => $data["deskripsi"],
    ":harga_per_hari" => $data["harga_per_hari"],
    ":stok" => $stok,
    ":status" => $status,
    ":foto_url" => $data["foto_url"] ?? ""
]);

$id = $db->lastInsertId();

$stmt = $db->prepare("
    SELECT a.*, u.nama AS nama_vendor, u.email AS email_vendor
    FROM alat a
    JOIN users u ON u.id_user = a.id_vendor
    WHERE a.id_alat = :id
");
$stmt->execute([":id" => $id]);

json_response(true, "Data alat berhasil ditambahkan", $stmt->fetch(), 201);
