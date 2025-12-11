# Eratani Data Pipeline - Agriculture Metrics Project

## Deskripsi Proyek
Proyek ini membangun sebuah pipeline end-to-end menggunakan **Apache Airflow** untuk orkestrasi, **dbt** untuk transformasi data, dan **PostgreSQL** sebagai data warehouse. Pipeline melakukan ingestion dari file CSV, membuat tabel staging, fact, dan menghasilkan tabel metrics harian (`agriculture_metrics_daily`) yang dapat digunakan untuk analisis performa pertanian.

---

## Tujuan
- Mengambil data mentah dari file `agriculture_dataset.csv` ke dalam Data Warehouse.
- Membersihkan dan memodelkan data menggunakan dbt.
- Menghasilkan metrik performa pertanian seperti Yield, Efisiensi Pupuk, dan Produktivitas Air.
- Menjalankan pipeline setiap hari pada pukul **06:00 UTC** menggunakan Airflow.
- Menyimpan hasil akhir di tabel `agriculture_metrics_daily`.

---

## Toolkit
- **Apache Airflow** – untuk orkestrasi pipeline
- **dbt** – untuk transformasi dan modelling data
- **PostgreSQL** – sebagai Data Warehouse
- **Docker & Docker Compose** – untuk menjalankan seluruh service dalam satu perintah
- **Python** (Pandas, psycopg2) – untuk ingestion

---

## Struktur Project
```
eratani-data-engineer
├── dags/
│   └── eratani_pipeline.py                # Airflow DAG untuk ingest & load data
│
├── dbt_project/
│   ├── models/
│   │   ├── staging/                       # Staging models (membersihkan & standarisasi data)
│   │   │   └── stg_agriculture.sql        # Model staging untuk tabel pertanian
│   │   │
│   │   ├── fact/                          # Fact models (tabel fakta untuk analisis)
│   │   │   └── fact_farm_production.sql   # Model fact berisi agregasi produksi
│   │   │
│   │   ├── metrics/                       # Metrics models (perhitungan KPI / indikator)
│   │   │    └── agriculture_metrics.sql   # Contoh metrik: yield, efisiensi air, dll.
│   │   │
│   │   └── sources.yml                    # Deklarasi sumber data untuk dbt (Postgres)
│   └── dbt_project.yml                    # Konfigurasi utama dbt project
│  
├── data/
│   └── agriculture_dataset.csv            # Raw CSV input untuk Airflow ingestion
│
├── docker-compose.yml                     # Orkestrasi Docker (Postgres, Airflow)
├── requirements.txt                       # Dependency Python untuk Airflow & scripts
├── Dockerfile                             # Custom image Airflow (opsional, jika digunakan)
├── README.md                              # Dokumentasi project
└── .gitignore                             # File/folder yang diabaikan Git
```

---

## Cara Menjalankan Project

### 1. Jalankan Docker
```
bash
docker-compose up --build
```
### 2. Akses Airflow UI
```
http://localhost:8081 # karena port 8080 bentrok diubah ke 8081
Login default:
User: airflow
Password: airflow
```
### 3. Aktifkan dan jalankan DAG
```
Cari DAG bernama:
eratani_pipeline
1. Toggle ON
2. Klik ▶ Run untuk eksekusi pertama
Pipeline otomatis berjalan setiap 06:00 UTC.
```
### 4. Jalankan seluruh model dbt (staging + fact)
```
dbt run
```
### 5. Melihat Tabel Hasil Transformasi dbt
##### 1. Masuk ke container PostgreSQL
```
docker exec -it eratani_data_engineer-postgres-1 bash
```
##### 2. Login ke PostgreSQL
```
psql -U airflow -d eratani
```
##### 3. Lihat tabel staging
```
SELECT * FROM stg_agriculture;
```
##### 4. Lihat tabel fact
```
SELECT * FROM fact_farm_production;
```
##### 5. Lihat tabel metrics
```
SELECT * FROM agriculture_metrics_daily;
```
### 5. Melihat Tabel Hasil di pgAdmin
```
Tabel Hasil juga dapat dilihat di pgAdmin dengan konfigurasi:
**Host name/address** : localhost
**Port** : 5434
**Database** : eratani
**Username** : airflow
**Password** : airflow
```
