<?php
require_once __DIR__ . "/../helpers/response.php";
require_once __DIR__ . "/../config/database.php";

set_headers();

$idVendor = $_GET["id_vendor"] ?? null;
if (!$idVendor) {
    json_response(false, "Parameter id_vendor wajib diisi", null, 422);
}

$db = (new Database())->connect();

$stmt = $db->prepare("
    SELECT b.*, a.nama_alat, a.foto_url, p.nama AS nama_petani, p.email AS email_petani
    FROM bookings b
    JOIN alat a ON a.id_alat = b.id_alat
    JOIN users p ON p.id_user = b.id_user
    WHERE b.id_vendor = :id_vendor
    ORDER BY b.id_booking DESC
");
$stmt->execute([":id_vendor" => $idVendor]);

json_response(true, "Daftar pesanan vendor berhasil diambil", $stmt->fetchAll());
