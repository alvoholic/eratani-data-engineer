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
http://localhost:8080
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
