<?php
require_once __DIR__ . "/../helpers/response.php";
require_once __DIR__ . "/../config/database.php";

set_headers();

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    json_response(false, "Method harus POST", null, 405);
}

$data = get_json_input();
require_fields($data, ["id_alat", "nama_alat", "kategori", "deskripsi", "harga_per_hari", "stok", "status"]);

$db = (new Database())->connect();

$stmt = $db->prepare("
    UPDATE alat SET
      nama_alat = :nama_alat,
      kategori = :kategori,
      deskripsi = :deskripsi,
      harga_per_hari = :harga_per_hari,
      stok = :stok,
      status = :status,
      foto_url = :foto_url
    WHERE id_alat = :id_alat
");

$stmt->execute([
    ":id_alat" => $data["id_alat"],
    ":nama_alat" => $data["nama_alat"],
    ":kategori" => $data["kategori"],
    ":deskripsi" => $data["deskripsi"],
    ":harga_per_hari" => $data["harga_per_hari"],
    ":stok" => $data["stok"],
    ":status" => $data["status"],
    ":foto_url" => $data["foto_url"] ?? ""
]);

$stmt = $db->prepare("SELECT * FROM alat WHERE id_alat = :id");
$stmt->execute([":id" => $data["id_alat"]]);

json_response(true, "Data alat berhasil diperbarui", $stmt->fetch());
