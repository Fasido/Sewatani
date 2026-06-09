<?php
require_once __DIR__ . "/../helpers/response.php";
require_once __DIR__ . "/../config/database.php";

set_headers();

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    json_response(false, "Method harus POST", null, 405);
}

$data = get_json_input();
require_fields($data, ["id_alat"]);

$db = (new Database())->connect();

$stmt = $db->prepare("DELETE FROM alat WHERE id_alat = :id_alat");
$stmt->execute([":id_alat" => $data["id_alat"]]);

json_response(true, "Data alat berhasil dihapus");
