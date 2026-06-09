<?php
require_once __DIR__ . "/helpers/response.php";
require_once __DIR__ . "/config/database.php";

set_headers();

$db = (new Database())->connect();
$stmt = $db->query("SELECT NOW() AS server_time");
$time = $stmt->fetch();

json_response(true, "API SewaTani aktif dan database terhubung", [
    "app" => "SewaTani API",
    "server_time" => $time["server_time"]
]);
