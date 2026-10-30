TUGAS RUTIN 4 MEMBUAT SISTEM PARKIR

sistem ini membuat simulasi sistem parkir seperti kendaraan masuk dan kendaraan keluar, biaya parkir per jam, member mendapat potongan harga, dan setiap kejadian yg ditampilkan di layar pos jaga. 

## Cara Menjalankan
menjalankan perintah 'dart run' pada terminal.

## Contoh Output
MASUK  Motor BK 1923 WO (sisa 2)
MASUK  Mobil BK 22 AP (sisa 1)
MASUK  Mobil (member) BK 1 RI (sisa 0)
Ditolak: Parkiran penuh
KELUAR Motor ... bayar Rp6000
KELUAR Mobil ... bayar Rp15000
Pendapatan: Rp28500
KELUAR Mobil (member) ... bayar Rp7500

## Penjelasan Penerapan Konsep

### 1. Abstract class
`Kendaraan` adalah kelas abstrak berisi `jenis`, `tarifPerJam`, dan `biaya()`. kelas ini tidak bisa dibuat langsung sehingga hanya menjadi kerangka yang mewajibkan setiap jenis kendaraan menentukan `jenis` dan `tarifPerJam`. rumus `biaya()`ditulis sekali dan dipakai bersama.

### 2. Subclass dan mixin
ada tiga jenis kendaraan: `Motor`, `Mobil`, dan `Truk`yang masing-masing
meng-override `jenis` dan `tarifPerJam`. Mixin `DiskonMember` (`on Kendaraan`)
meng override `biaya()` untuk memberi diskon 50% lalu dipakai oleh
`MobilMember`. mixin dipilih karena diskon adalah kemampuan tambahan yang dapat ditempel ke jenis kendaraan mana saja tanpa menulis ulang kode.

### 3. Enkapsulasi
di kelas `Parkiran`, data `_kapasitas`, `_terparkir`, dan `_pendapatan` bersifat privat (awalan `_`). kode di luar kelas hanya bisa membaca lewat getter `sisa` dan `pendapatan` sehingga pendapatan tidak dapat diubah sembarangan.

### 4. Exception
`ParkirPenuh implements Exception` dilempar (`throw`) oleh `masuk()` saat
kapasitas habis. pemanggil menangkapnya dengan `try`/`on ParkirPenuh catch`yang menampilkan "Ditolak: Parkiran penuh" dan program tetap berjalan.

### 5. Async dan await
`masuk()` dan `keluar()` bertipe `Future<void>` dan memakai `Future.delayed` untuk mensimulasikan proses nyata (palang, pembayaran). Pemanggilnya memakai `await` agar kejadian berjalan berurutan sesuai urutan kendaraan.

### 6. Stream
`Parkiran` memiliki `StreamController<String>.broadcast()`. setiap kejadian masuk atau keluar dikirim ke stream (`layarPos`), dan `main` mendengarkannya dengan `listen(print)` sebagai layar pos jaga. `listen` dipasang sebelum ada kejadian karena pada broadcast stream event yang dikirim sebelum ada pendengar akan hilang.

## Asumsi
dalam sistem, di asumsikan lahan parkir berisi 3 kendaraan yaitu motor, mobi, dan truk. durasi parkir untuk semua kendaraan adalah masing-masing 3 jam. tarif per jam untuk motor Rp 2.000, mobil Rp 5.000 dan truk Rp 10.000.

## Penggunaan AI
dalam tugas ini, saya menggunakan AI (Claude) untuk menyusun rancangan kelas dan membuat draft kode awal. kode kemudian saya uji dan jalankan sehingga dapat saya jelaskan.
