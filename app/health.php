<?php

header('Content-type: application/json; charset=utf-8');

$data = [
    "status" => "OK"
];

echo json_encode($data, JSON_PRETTY_PRINT);

