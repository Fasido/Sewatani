<?php
require_once __DIR__ . "/../helpers/response.php";
require_once __DIR__ . "/../config/database.php";

set_headers();

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    json_response(false, "Method harus POST", null, 405);
}

$data = get_json_input();
require_fields($data, ["firebase_uid", "fcm_token"]);

$db = (new Database())->connect();

$stmt = $db->prepare("
    UPDATE users
    SET fcm_token = :fcm_token
    WHERE firebase_uid = :firebase_uid
");
$stmt->execute([
    ":fcm_token" => $data["fcm_token"],
    ":firebase_uid" => $data["firebase_uid"]
]);

json_response(true, "FCM token berhasil diperbarui");
