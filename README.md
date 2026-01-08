# Sleepy Panda
![alt text](image.png) ![alt text](image-1.png) ![alt text](image-2.png)
![alt text](image-3.png) ![alt text](image-4.png) ![alt text](image-5.png)

## Tentang Sleepy Panda
Sleepy Panda adalah aplikasi yang dirancang untuk membantu karyawan dalam memantau dan menganalisis pola tidur mereka. Dengan teknologi AI, Sleepy Panda memberikan wawasan terkait kualitas tidur serta rekomendasi yang dipersonalisasi untuk meningkatkan kesehatan dan produktivitas karyawan.

## Latar Belakang
Kurangnya tidur berkualitas berdampak pada produktivitas kerja, meningkatkan risiko kesalahan, serta menurunkan kesehatan mental dan fisik. Berdasarkan penelitian, 50% dari human error dalam pekerjaan disebabkan oleh kelelahan. Oleh karena itu, Sleepy Panda hadir sebagai solusi untuk membantu perusahaan dan karyawan dalam memantau pola tidur dan mencegah gangguan tidur seperti insomnia atau sleep apnea.

## Fitur Utama
- **Analisis Pola Tidur**: Menampilkan durasi tidur, waktu mulai dan bangun, serta kualitas tidur.
- **Prediksi Gangguan Tidur**: Menggunakan AI dan Machine Learning untuk mendeteksi risiko insomnia atau sleep apnea.
- **Rekomendasi Tidur**: Memberikan saran personal berdasarkan data pola tidur pengguna.
- **Laporan Harian, Mingguan, dan Bulanan**: Menyediakan ringkasan pola tidur dalam berbagai periode.

## Teknologi yang Digunakan
### **Front-End**
- **Framework**: Flutter (untuk Android)
- **UI/UX**: Menggunakan desain yang responsif dan mudah digunakan
- **HTTP Requests**: Menggunakan `http` untuk komunikasi dengan server
- **Authentication**: OAuth2 untuk otorisasi pengguna

### **Back-End**
- **Framework**: FastAPI (framework python)
- **Machine Learning**: XGBoost untuk prediksi gangguan tidur
- **Database**: MySQL sebagai penyimpanan utama
- **ORM**: SQLAlchemy untuk pengelolaan database
- **Caching**: Redis untuk meningkatkan kecepatan akses data
- **Web Server**: NGINX sebagai reverse proxy dan load balancer

## Arsitektur Aplikasi
Sleepy Panda menggunakan model client-server, di mana aplikasi mobile berkomunikasi dengan server FastAPI untuk mengirim dan menerima data. Data kemudian diproses menggunakan model machine learning dan disimpan di database MySQL. Redis digunakan untuk caching guna meningkatkan performa aplikasi.

## Cara Menggunakan
1. **Daftar dan Login**: Buat akun menggunakan email yang valid.
2. **Input Data Profil**: Masukkan informasi dasar seperti tinggi, berat badan, dan pola aktivitas.
3. **Pantau Pola Tidur**: Lihat laporan harian, mingguan, dan bulanan.
4. **Terima Rekomendasi**: Ikuti saran yang diberikan untuk meningkatkan kualitas tidur.
5. **Analisis Gangguan Tidur**: Cek apakah ada tanda-tanda insomnia atau sleep apnea.

## Deployment
- **Platform**: Android (belum tersedia di Play Store)
- **Cloud Hosting**: Biznet untuk server FastAPI dan database MySQL
- **Reverse Proxy**: NGINX untuk meningkatkan keamanan dan performa

## Demo
Lihat demo Sleepy Panda di YouTube: [Klik di sini](https://www.youtube.com/watch?v=oyZf6PuFsB8)

