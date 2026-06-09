<?php
require_once __DIR__ . "/../helpers/response.php";
require_once __DIR__ . "/../config/database.php";

set_headers();

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    json_response(false, "Method harus POST", null, 405);
}

$data = get_json_input();
require_fields($data, ["id_booking", "status"]);

$status = $data["status"];
if (!in_array($status, ["menunggu", "diterima", "ditolak", "selesai"], true)) {
    json_response(false, "Status tidak valid", null, 422);
}

$db = (new Database())->connect();

$stmt = $db->prepare("
    UPDATE bookings
    SET status = :status
    WHERE id_booking = :id_booking
");
$stmt->execute([
    ":status" => $status,
    ":id_booking" => $data["id_booking"]
]);

$stmt = $db->prepare("
    SELECT b.*, a.nama_alat, p.nama AS nama_petani, v.nama AS nama_vendor
    FROM bookings b
    JOIN alat a ON a.id_alat = b.id_alat
    JOIN users p ON p.id_user = b.id_user
    JOIN users v ON v.id_user = b.id_vendor
    WHERE b.id_booking = :id
");
$stmt->execute([":id" => $data["id_booking"]]);

json_response(true, "Status booking berhasil diperbarui", $stmt->fetch());
