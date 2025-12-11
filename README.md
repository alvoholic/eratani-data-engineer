# Eratani Data Pipeline - Agriculture Metrics Project 🌾

## 📌 Deskripsi Proyek
Proyek ini membangun sebuah pipeline end-to-end menggunakan **Apache Airflow** untuk orkestrasi, **dbt** untuk transformasi data, dan **PostgreSQL** sebagai data warehouse. Pipeline melakukan ingestion dari file CSV, membuat tabel staging, fact, dan menghasilkan tabel metrics harian (`agriculture_metrics_daily`) yang dapat digunakan untuk analisis performa pertanian.

---

## 🎯 Tujuan
- Mengambil data mentah dari file `agriculture_dataset.csv` ke dalam Data Warehouse.
- Membersihkan dan memodelkan data menggunakan dbt.
- Menghasilkan metrik performa pertanian seperti Yield, Efisiensi Pupuk, dan Produktivitas Air.
- Menjalankan pipeline setiap hari pada pukul **06:00 UTC** menggunakan Airflow.
- Menyimpan hasil akhir di tabel `agriculture_metrics_daily`.

---

## 🧰 Toolkit
- **Apache Airflow** – untuk orkestrasi pipeline
- **dbt** – untuk transformasi dan modelling data
- **PostgreSQL** – sebagai Data Warehouse
- **Docker & Docker Compose** – untuk menjalankan seluruh service dalam satu perintah
- **Python** (Pandas, psycopg2) – untuk ingestion

---

## 📂 Struktur Project
```
.
├── dags/
│   └── eratani_pipeline.py        # Airflow DAG
├── dbt_project/
│   ├── models/
│   │   ├── staging/               # Staging models
│   │   ├── fact/                  # Fact models
│   │   └── metrics/               # Metrics models
│   └── dbt_project.yml
├── data/
│   └── agriculture_dataset.csv    # Raw CSV input
├── docker-compose.yml             # Container orchestration
├── requirements.txt               # Python dependencies
├── README.md                      # Documentation
└── .gitignore                     # Ignored files
```


---

## 🚀 Cara Menjalankan Project

### 1. Jalankan Docker
```bash
docker-compose up --build
2. Akses Airflow UI
http://localhost:8080
Login default:
User: airflow
Password: airflow
3. Aktifkan dan jalankan DAG
Cari DAG bernama:
eratani_pipeline
👉 Toggle ON
👉 Klik ▶ Run untuk eksekusi pertama
Pipeline otomatis berjalan setiap 06:00 UTC.
