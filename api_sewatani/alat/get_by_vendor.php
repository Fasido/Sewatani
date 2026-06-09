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
    SELECT * FROM alat
    WHERE id_vendor = :id_vendor
    ORDER BY id_alat DESC
");
$stmt->execute([":id_vendor" => $idVendor]);

json_response(true, "Data alat vendor berhasil diambil", $stmt->fetchAll());
