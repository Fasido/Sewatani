<?php
require_once __DIR__ . "/../helpers/response.php";
require_once __DIR__ . "/../config/database.php";

set_headers();

$idUser = $_GET["id_user"] ?? null;
if (!$idUser) {
    json_response(false, "Parameter id_user wajib diisi", null, 422);
}

$db = (new Database())->connect();

$stmt = $db->prepare("
    SELECT b.*, a.nama_alat, a.foto_url, v.nama AS nama_vendor
    FROM bookings b
    JOIN alat a ON a.id_alat = b.id_alat
    JOIN users v ON v.id_user = b.id_vendor
    WHERE b.id_user = :id_user
    ORDER BY b.id_booking DESC
");
$stmt->execute([":id_user" => $idUser]);

json_response(true, "Riwayat booking user berhasil diambil", $stmt->fetchAll());
