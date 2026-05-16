---
name: bandarmology
description: >
  Panduan analisis Bandarmology saham Indonesia berdasarkan buku "Bandarmology – Membeli Saham Gaya Bandar Bursa" karya Ryan Filbert. Gunakan skill ini setiap kali pengguna bertanya tentang bandarmologi, cara mendeteksi bandar, analisis broker summary, pola akumulasi/distribusi, cara membaca jejak big player / market maker di BEI, teknik "hajar kanan", foreign flow, atau ingin menganalisis saham dengan pendekatan volume & broker. Trigger juga ketika pengguna menyebut: "cara bandar", "ikut bandar", "akumulasi saham", "distribusi saham", "net buy asing", "broker summary", "top broker", "NBSA", atau pertanyaan seputar strategi trading berbasis pergerakan institusional di pasar modal Indonesia.
---

# Skill: Bandarmology (Ryan Filbert)

Skill ini mengkodifikasi kerangka berpikir dan teknik dari buku **Bandarmology – Membeli Saham Gaya Bandar Bursa** oleh Ryan Filbert. Tujuannya adalah membantu pengguna mendeteksi dan mengikuti jejak "bandar" (big player / market maker) di Bursa Efek Indonesia (BEI).

---

## 1. Filosofi Dasar

**Bandar** bukan tokoh jahat misterius, melainkan pihak bermodal besar yang mampu menggerakkan harga saham. Bisa berupa:
- Institusi (manajer investasi, dana pensiun, sekuritas asing)
- Pemilik emiten yang mengontrol saham perusahaannya sendiri
- Market maker yang menjaga likuiditas

**Prinsip inti Bandarmology:**
> "Lakukan apa yang kamu lakukan, bukan apa yang kamu katakan."

Bandar tidak pernah mengumumkan rencananya. Tapi jejaknya **selalu tertinggal di data publik** — khususnya di Broker Summary dan data volume transaksi.

**Bandarmology adalah ilmu kuantitatif**, bukan kualitatif. Keputusan didasarkan pada angka dan data, bukan rumor atau feeling.

---

## 2. Pelaku Pasar Modal (Bab 4)

| Kategori | Kode | Keterangan |
|---|---|---|
| Domestik | D | Investor lokal (ritel & institusi) |
| Asing | F (Foreign) | Investor luar negeri |

Pelaku utama di BEI:
- **Bursa Efek Indonesia (BEI)** — regulator & operator
- **Sekuritas/Broker** — perantara transaksi; setiap broker punya kode unik
- **Investor ritel** — individu, sering menjadi "korban" distribusi bandar
- **Institusi** — bandar sesungguhnya; bergerak besar & lambat

---

## 3. Siklus Harga: Akumulasi → Mark-Up → Distribusi (Bab 5 & 3)

Ini adalah inti dari Bandarmology. Bandar bekerja dalam **tiga fase utama**:

### Fase 1: Akumulasi
- Bandar mengumpulkan saham **diam-diam** dari investor ritel
- Harga cenderung **sideways atau turun pelan-pelan**
- Volume transaksi kecil, tidak mencolok
- Dilakukan lewat **lebih dari 1 broker** agar tidak ketahuan
- Bisa berlangsung **mingguan hingga bulanan**

**Ciri-ciri akumulasi:**
- Saham belum terkenal / tidak ramai diperbincangkan
- Antrian bid-offer tipis
- Ada pembelian bertahap oleh broker tertentu

### Fase 2: Mark-Up (Goreng)
- Bandar mulai **menaikkan harga cepat** untuk menarik perhatian ritel
- Rumor mulai menyebar ke "ring-1 bandar" (kaki tangan)
- Volume melonjak drastis
- Harga bergerak liar dan hot
- Momen ini adalah **jebakan** bagi yang terlambat masuk

### Fase 3: Distribusi
- Bandar **melepas saham** ke investor ritel yang euforia
- Harga bergerak **sideways di atas**, sesekali naik sebentar lalu turun
- Volume masih besar tapi mulai tidak konsisten
- Berita positif sengaja disebarkan untuk menarik pembeli baru
- **Tanda bahaya:** harga tidak bisa terus naik meskipun ada berita bagus

**Strategi ritel yang benar:**
- Beli saat fase **akumulasi** (ikut bandar diam-diam)
- Jual saat **distribusi** dimulai (sebelum semua orang tahu)

---

## 4. Metode Analisis Kuantitatif vs Kualitatif (Bab 2)

| Metode | Jenis | Contoh |
|---|---|---|
| Analisis Teknikal (TA) | Kualitatif | Bollinger Band, Moving Average, Fibonacci |
| Bandarmology | **Kuantitatif** | Broker Summary, Volume, Net Buy/Sell |
| Analisis Fundamental | Kualitatif | Laporan keuangan, rasio PE, PBV |

Bandarmology **paling cocok dikombinasikan dengan analisis teknikal** — TA memberikan timing, Bandarmology memberikan konfirmasi siapa yang bergerak.

---

## 5. Creating Bandarmology — 5 Langkah Praktis (Bab 8)

Ini adalah metode inti untuk membaca data Broker Summary:

### Langkah 1: Ambil Data
Ambil **Top 5 Broker Buy** dan **Top 5 Broker Sell** untuk saham yang dianalisis, dengan rentang waktu tertentu (daily, mingguan, atau bulanan).

Data bisa dilihat di:
- Platform sekuritas (OLT/online trading)
- Stockbit (fitur Broker Summary)
- RTI Business
- IDX / BEI

### Langkah 2: Olah Data
Dari data mentah, ambil:
- **Buy Volume** total dari top 5 broker pembeli
- **Sell Volume** total dari top 5 broker penjual

### Langkah 3: Hitung Net Position
```
Net Buy/Sell = Total Buy Volume - Total Sell Volume
```
- **Positif (Net Buy)** → indikasi akumulasi
- **Negatif (Net Sell)** → indikasi distribusi

### Langkah 4: Bandarmology dalam Olahan
Identifikasi apakah **broker yang sama** konsisten membeli selama beberapa hari/minggu. Jika satu-dua broker dominan di sisi beli secara konsisten → kemungkinan besar itu broker yang dipakai bandar.

### Langkah 5: Konfirmasi dengan Chart
Overlay hasil analisis broker dengan grafik harga dan volume untuk melihat kesesuaian pola akumulasi/distribusi dengan pergerakan harga.

---

## 6. Foreign Flow / NBSA (Net Buy Sell Asing)

```
NBSA = Total Buy Asing - Total Sell Asing
```

- **NBSA Positif** = asing net buy → akumulasi oleh investor asing
- **NBSA Negatif** = asing net sell → distribusi / keluarnya dana asing

**Catatan penting:**
- NBSA lebih cocok untuk **saham-saham blue chip / LQ45** yang diminati asing
- Untuk saham lapis 2-3, lebih relevan menggunakan broker summary lokal
- Data tersedia di Stockbit, RTI, atau fitur Bandarmology di platform sekuritas

---

## 7. Cara Mengenali Jejak Bandar

### Signal Akumulasi (Beli):
- Volume meningkat diam-diam tanpa berita
- Harga tidak jatuh meski ada tekanan jual
- Broker tertentu konsisten di sisi beli selama beberapa hari
- Antrian bid (beli) lebih tebal dari offer (jual) → **"hajar kanan"**
- NBSA / Net Buy positif dan meningkat

### Signal Distribusi (Waspada/Jual):
- Volume besar tapi harga tidak naik signifikan
- Berita positif bertebaran → momentum distribusi bandar
- Broker yang sebelumnya beli, kini mulai pindah ke sisi jual
- Net sell meningkat
- Harga stagnan di level tinggi (fase distribusi sideways)

### Signal "Saham Dicuekin" (Hindari):
- Volume sangat kecil, tipis
- Harga turun perlahan (ritel yang cut loss, tidak ada yang nampung)
- Tidak ada broker dominan di sisi beli maupun jual

---

## 8. Think and Act Like Bandarmology (Bab 7)

Filosofi berpikir seperti bandar:

1. **Akumulasi diam-diam** — jangan umbar posisi beli ke publik
2. **Lakukan, jangan dikatakan** — bandar tidak pernah bilang mau beli
3. **Ikuti alur harga** — beli saat tidak ada yang mau, jual saat semua orang mau
4. **Pemeliharaan harga** — saat akumulasi, pastikan harga tetap wajar agar tidak menarik perhatian berlebih
5. **Patience is power** — bandar tidak terburu-buru; proses akumulasi bisa berbulan-bulan

**Mentalitas yang harus dihindari ritel:**
- FOMO (Fear of Missing Out) saat harga sudah naik tinggi
- Ikut rumor tanpa cek data broker summary
- Terlena berita bagus saat saham sudah di puncak distribusi

---

## 9. Indikator Bandarmology di Platform Modern

| Indikator | Fungsi |
|---|---|
| Broker Summary | Lihat broker mana net buy / net sell |
| Bandar Volume | Volume transaksi bandar per periode |
| Bandar Value | Nilai rupiah transaksi bandar |
| Bandar Movement | Arah pergerakan bandar (akumulasi/distribusi) |
| Foreign Flow / NBSA | Arus dana asing masuk/keluar |
| Bandar Detector (Stockbit) | Algoritma otomatis deteksi pola broker bandar |

---

## 10. Prinsip-Prinsip Penting & Peringatan

- Bandarmology **bukan jurus sakti** — ada delay 2–5 hari antara sinyal dan pergerakan harga
- **Jangan ikut saham yang bandarnya tunggal** (monopoli satu bandar) — sangat mudah dimanipulasi, data broker summary pun bisa di-*game*
- Bandar bisa pakai **lebih dari 1 broker** → gunakan rentang waktu cukup panjang untuk analisis
- Kombinasikan dengan **analisis teknikal** untuk timing entry/exit yang lebih presisi
- Selalu gunakan **stop loss** — bandar pun bisa salah arah
- Saham lapis 2-3 tanpa bandar aktif: **hindari**, ciri-cirinya volume kecil, harga datar/turun pelan

---

## 11. Struktur Bab Buku (Referensi Cepat)

| Bab | Topik |
|---|---|
| Bab 1 | Proses IPO / Perusahaan Melantai di Bursa |
| Bab 2 | Analisis Kuantitatif vs Kualitatif |
| Bab 3 | Proses Perubahan Harga (Volume sebagai Support/Resistance) |
| Bab 4 | Pelaku Pasar Modal (Domestik & Asing) |
| Bab 5 | Kumpulkan dan Sebarkan (Akumulasi & Distribusi) |
| Bab 6 | Who Is The Bandar? |
| Bab 7 | Think and Act Like Bandarmology |
| Bab 8 | Creating Bandarmology (5 Langkah) |
| Bab 9 | Contoh Kasus (BBTN, dll.) |

---

## Cara Menggunakan Skill Ini

Ketika pengguna bertanya tentang Bandarmology, gunakan kerangka ini untuk:

1. **Menjelaskan konsep** → acu ke bagian Filosofi & Siklus (§2–§3)
2. **Menganalisis saham spesifik** → gunakan kerangka 5 Langkah (§5) dan sinyal (§7)
3. **Menjawab pertanyaan teknis** → acu ke indikator (§9) dan NBSA (§6)
4. **Membantu strategi trading** → acu ke Think and Act (§8) dan Peringatan (§10)
5. **Menjawab "apakah saham X sedang diakumulasi?"** → minta data broker summary / NBSA, lalu analisis dengan framework §5

Selalu ingatkan pengguna bahwa ini adalah alat bantu analisis, bukan sinyal beli/jual yang pasti. Kombinasi dengan analisis teknikal dan manajemen risiko adalah kunci.
