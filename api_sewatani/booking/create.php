<?php
require_once __DIR__ . "/../helpers/response.php";
require_once __DIR__ . "/../config/database.php";

set_headers();

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    json_response(false, "Method harus POST", null, 405);
}

$data = get_json_input();
require_fields($data, ["id_user", "id_alat", "id_vendor", "tanggal_mulai", "tanggal_selesai", "alamat"]);

$db = (new Database())->connect();

$stmt = $db->prepare("
    INSERT INTO bookings (id_user, id_alat, id_vendor, tanggal_mulai, tanggal_selesai, alamat, catatan, status)
    VALUES (:id_user, :id_alat, :id_vendor, :tanggal_mulai, :tanggal_selesai, :alamat, :catatan, 'menunggu')
");

$stmt->execute([
    ":id_user" => $data["id_user"],
    ":id_alat" => $data["id_alat"],
    ":id_vendor" => $data["id_vendor"],
    ":tanggal_mulai" => $data["tanggal_mulai"],
    ":tanggal_selesai" => $data["tanggal_selesai"],
    ":alamat" => $data["alamat"],
    ":catatan" => $data["catatan"] ?? ""
]);

$id = $db->lastInsertId();

$stmt = $db->prepare("
    SELECT b.*, a.nama_alat, p.nama AS nama_petani, v.nama AS nama_vendor
    FROM bookings b
    JOIN alat a ON a.id_alat = b.id_alat
    JOIN users p ON p.id_user = b.id_user
    JOIN users v ON v.id_user = b.id_vendor
    WHERE b.id_booking = :id
");
$stmt->execute([":id" => $id]);

json_response(true, "Booking berhasil dibuat", $stmt->fetch(), 201);
