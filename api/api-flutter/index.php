<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
// Koneksi ke database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "responsi_tugas";
$conn = new mysqli($servername, $username, $password,
$dbname);
if ($conn->connect_error) {
die("Koneksi ke database gagal: " . $conn->connect_error);
}

//TAMPIL DATA
$method = $_SERVER["REQUEST_METHOD"];
if ($method === "GET") {
 // Mengambil data pekerjaan
$sql = "SELECT * FROM pekerjaan";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
$pekerjaan = array();
while ($row = $result->fetch_assoc()) {
$pekerjaan[] = $row;
}
echo json_encode($pekerjaan);
} else {
echo "Data pekerjaan kosong.";
}
} 

//TAMBAH DATA
if ($method === "POST") {
    // Menambahkan data pekerjaan
   $data = json_decode(file_get_contents("php://input"), true);
   $title = $data["title"];
   $status = $data["status"];
   $sql = "INSERT INTO pekerjaan (title, status) VALUES ('$title', '$status')";
   if ($conn->query($sql) === TRUE) {
   $data['pesan'] = 'berhasil';
   //echo "Berhasil tambah data";
   } else {
   $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
   }
   echo json_encode($data);
   } 

//EDIT DATA
if ($method === "PUT") {
    // Memperbarui data pekerjaan
   $data = json_decode(file_get_contents("php://input"), true);
   $id = $data["id"];
   $title = $data["title"];
   $status = $data["status"];
   $sql = "UPDATE pekerjaan SET title='$title', status='$status' WHERE id=$id";
   if ($conn->query($sql) === TRUE) {
   } else {
   echo "Error: " . $sql . "<br>" . $conn->error;
   }
   } 
//HAPUS
if ($method === "DELETE") {
    // Menghapus data pekerjaan
   $id = $_GET["id"];
   $sql = "DELETE FROM pekerjaan WHERE id=$id";
   if ($conn->query($sql) === TRUE) {
   $data['pesan'] = 'berhasil';
   } else {
   $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
   }
   echo json_encode($data);
   }
   $conn->close();