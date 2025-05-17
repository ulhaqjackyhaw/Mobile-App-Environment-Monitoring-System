# 🌿 Environment Monitoring System

Sistem monitoring lingkungan berbasis IoT dan mobile application untuk menampilkan data suhu, kelembapan, serta mengontrol lampu indikator secara real-time.

---

## 🛠️ Teknologi yang Digunakan

### 📱 Mobile App
- **Flutter**: UI Framework untuk aplikasi lintas platform (Android & iOS)
- **Firebase Realtime Database**: Penyimpanan cloud untuk data sensor secara langsung
- **Firebase Core & Database Plugin**: Integrasi Flutter dengan Firebase

### 🔧 IoT / Hardware
- **ESP32**: Mikrokontroler utama untuk membaca data dan mengirim ke Firebase
- **Sensor DHT11 / DHT22**: Mengukur suhu dan kelembapan
- **LED**: Sebagai indikator berdasarkan nilai sensor
- **WiFi**: Koneksi internet dari ESP32 ke Firebase

---

## ⚙️ Fitur Utama

- 🔴 Monitoring **suhu dan kelembapan** secara real-time
- 🟢 Tampilan data sensor dalam bentuk **teks & grafik** (opsional)
- 💡 **Kontrol LED** dari aplikasi (ON/OFF) berdasarkan suhu/kelembapan
- ☁️ Data dikirim dan diterima secara **langsung dari Firebase**

---

## 📱 Tampilan Aplikasi (UI Preview)
> *(Tambahkan screenshot di sini jika tersedia)*

---

## 🧰 Cara Instalasi dan Penggunaan

### 📦 1. Flutter App

#### a. Clone repositori
```bash
git clone https://github.com/username/environment-monitoring-system.git
cd environment-monitoring-system
