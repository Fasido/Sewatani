# API SewaTani - PHP Native + MySQL

Backend ini digunakan untuk tugas besar PPB aplikasi SewaTani.

## Fitur API
- Sync user Google Login ke MySQL
- CRUD data alat pertanian
- Booking sewa alat
- Update status booking
- Endpoint test koneksi

## Database
Import file:
`sql/sewatani_db.sql`

## Cara menjalankan cepat

### Opsi 1 - PHP built-in server
```powershell
cd C:\ido\sewatani\api_sewatani
php -S 0.0.0.0:8000
```

Akses:
`http://localhost:8000/health.php`

Untuk HP fisik, pakai IP laptop:
`http://IP_LAPTOP:8000/health.php`

### Opsi 2 - Laragon
Copy folder `api_sewatani` ke:
`C:\laragon\www\api_sewatani`

Akses:
`http://localhost/api_sewatani/health.php`
