<?php
require_once __DIR__ . "/../helpers/response.php";

set_headers();

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    json_response(false, "Method harus POST", null, 405);
}

if (!isset($_FILES["image"])) {
    json_response(false, "File image wajib dikirim dengan key image", null, 422);
}

$file = $_FILES["image"];

if ($file["error"] !== UPLOAD_ERR_OK) {
    json_response(false, "Upload gambar gagal", ["error_code" => $file["error"]], 400);
}

$maxSize = 3 * 1024 * 1024;
if ($file["size"] > $maxSize) {
    json_response(false, "Ukuran gambar maksimal 3 MB", null, 422);
}

$allowedExtensions = ["jpg", "jpeg", "png", "webp"];
$originalName = $file["name"];
$extension = strtolower(pathinfo($originalName, PATHINFO_EXTENSION));

if (!in_array($extension, $allowedExtensions, true)) {
    json_response(false, "Format gambar harus jpg, jpeg, png, atau webp", null, 422);
}

$uploadDir = __DIR__ . "/../uploads/alat";
if (!is_dir($uploadDir)) {
    if (!mkdir($uploadDir, 0777, true)) {
        json_response(false, "Folder upload gagal dibuat", null, 500);
    }
}

$fileName = "alat_" . date("Ymd_His") . "_" . bin2hex(random_bytes(4)) . "." . $extension;
$targetPath = $uploadDir . "/" . $fileName;

if (!move_uploaded_file($file["tmp_name"], $targetPath)) {
    json_response(false, "Gagal menyimpan gambar ke server", null, 500);
}

$relativePath = "uploads/alat/" . $fileName;

json_response(true, "Gambar alat berhasil diupload", [
    "file_name" => $fileName,
    "file_path" => $relativePath,
    "url" => $relativePath
], 201);
