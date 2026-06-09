<?php
require_once __DIR__ . "/../helpers/response.php";
require_once __DIR__ . "/../config/database.php";

set_headers();

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    json_response(false, "Method harus POST", null, 405);
}

$data = get_json_input();
require_fields($data, ["firebase_uid", "nama", "email", "role"]);

$role = $data["role"];
if (!in_array($role, ["petani", "vendor"], true)) {
    json_response(false, "Role tidak valid", null, 422);
}

$db = (new Database())->connect();

$sql = "
    INSERT INTO users (firebase_uid, nama, email, photo_url, role, fcm_token)
    VALUES (:firebase_uid, :nama, :email, :photo_url, :role, :fcm_token)
    ON DUPLICATE KEY UPDATE
      nama = VALUES(nama),
      email = VALUES(email),
      photo_url = VALUES(photo_url),
      role = VALUES(role),
      fcm_token = COALESCE(VALUES(fcm_token), fcm_token)
";

$stmt = $db->prepare($sql);
$stmt->execute([
    ":firebase_uid" => $data["firebase_uid"],
    ":nama" => $data["nama"],
    ":email" => $data["email"],
    ":photo_url" => $data["photo_url"] ?? "",
    ":role" => $role,
    ":fcm_token" => $data["fcm_token"] ?? null
]);

$stmt = $db->prepare("SELECT * FROM users WHERE firebase_uid = :firebase_uid LIMIT 1");
$stmt->execute([":firebase_uid" => $data["firebase_uid"]]);
$user = $stmt->fetch();

json_response(true, "User berhasil disinkronkan", $user);
