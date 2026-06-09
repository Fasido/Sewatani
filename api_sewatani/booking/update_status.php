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

try {
    $db->beginTransaction();

    $stmt = $db->prepare("
        SELECT id_booking, id_alat, status
        FROM bookings
        WHERE id_booking = :id_booking
        FOR UPDATE
    ");
    $stmt->execute([":id_booking" => $data["id_booking"]]);
    $booking = $stmt->fetch();

    if (!$booking) {
        $db->rollBack();
        json_response(false, "Booking tidak ditemukan", null, 404);
    }

    $oldStatus = $booking["status"];

    $stmt = $db->prepare("
        UPDATE bookings
        SET status = :status
        WHERE id_booking = :id_booking
    ");
    $stmt->execute([
        ":status" => $status,
        ":id_booking" => $data["id_booking"]
    ]);

    // Jika vendor menolak pesanan yang sebelumnya mengunci stok,
    // stok dikembalikan satu.
    if ($status === "ditolak" && $oldStatus !== "ditolak") {
        $stmt = $db->prepare("
            UPDATE alat
            SET stok = stok + 1,
                status = 'tersedia'
            WHERE id_alat = :id_alat
        ");
        $stmt->execute([":id_alat" => $booking["id_alat"]]);
    }

    $stmt = $db->prepare("
        SELECT b.*, a.nama_alat, a.foto_url, a.stok, a.status AS status_alat,
               p.nama AS nama_petani, v.nama AS nama_vendor
        FROM bookings b
        JOIN alat a ON a.id_alat = b.id_alat
        JOIN users p ON p.id_user = b.id_user
        JOIN users v ON v.id_user = b.id_vendor
        WHERE b.id_booking = :id
    ");
    $stmt->execute([":id" => $data["id_booking"]]);
    $updated = $stmt->fetch();

    $db->commit();

    json_response(true, "Status booking berhasil diperbarui", $updated);
} catch (Exception $e) {
    if ($db->inTransaction()) {
        $db->rollBack();
    }

    json_response(false, "Gagal memperbarui status booking", ["error" => $e->getMessage()], 500);
}
