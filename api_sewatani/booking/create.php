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

try {
    $db->beginTransaction();

    $stmt = $db->prepare("
        SELECT id_alat, stok, status
        FROM alat
        WHERE id_alat = :id_alat
        FOR UPDATE
    ");
    $stmt->execute([":id_alat" => $data["id_alat"]]);
    $alat = $stmt->fetch();

    if (!$alat) {
        $db->rollBack();
        json_response(false, "Alat tidak ditemukan", null, 404);
    }

    if ((int)$alat["stok"] <= 0 || $alat["status"] !== "tersedia") {
        $db->rollBack();
        json_response(false, "Stok alat habis atau alat tidak tersedia", null, 422);
    }

    $stmt = $db->prepare("
        INSERT INTO bookings (
            id_user,
            id_alat,
            id_vendor,
            tanggal_mulai,
            tanggal_selesai,
            alamat,
            catatan,
            status
        )
        VALUES (
            :id_user,
            :id_alat,
            :id_vendor,
            :tanggal_mulai,
            :tanggal_selesai,
            :alamat,
            :catatan,
            'menunggu'
        )
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

    $idBooking = $db->lastInsertId();

    $newStock = (int)$alat["stok"] - 1;
    $newStatus = $newStock <= 0 ? "tidak_tersedia" : "tersedia";

    $stmt = $db->prepare("
        UPDATE alat
        SET stok = :stok, status = :status
        WHERE id_alat = :id_alat
    ");
    $stmt->execute([
        ":stok" => $newStock,
        ":status" => $newStatus,
        ":id_alat" => $data["id_alat"]
    ]);

    $stmt = $db->prepare("
        SELECT b.*, a.nama_alat, a.foto_url, a.stok, a.status AS status_alat,
               p.nama AS nama_petani, v.nama AS nama_vendor
        FROM bookings b
        JOIN alat a ON a.id_alat = b.id_alat
        JOIN users p ON p.id_user = b.id_user
        JOIN users v ON v.id_user = b.id_vendor
        WHERE b.id_booking = :id
    ");
    $stmt->execute([":id" => $idBooking]);
    $booking = $stmt->fetch();

    $db->commit();

    json_response(true, "Booking berhasil dibuat dan stok alat diperbarui", $booking, 201);
} catch (Exception $e) {
    if ($db->inTransaction()) {
        $db->rollBack();
    }

    json_response(false, "Gagal membuat booking", ["error" => $e->getMessage()], 500);
}
