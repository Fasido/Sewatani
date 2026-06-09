<?php
require_once __DIR__ . "/../helpers/response.php";
require_once __DIR__ . "/../config/database.php";

set_headers();

$db = (new Database())->connect();

$stmt = $db->query("
    SELECT 
      a.*,
      u.nama AS nama_vendor,
      u.email AS email_vendor
    FROM alat a
    JOIN users u ON u.id_user = a.id_vendor
    ORDER BY a.id_alat DESC
");

json_response(true, "Data alat berhasil diambil", $stmt->fetchAll());
