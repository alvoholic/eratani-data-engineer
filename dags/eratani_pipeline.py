from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime
import pandas as pd
import psycopg2

def ingest_csv():
    # Koneksi ke PostgreSQL. Host "postgres" bekerja karena berada di jaringan Docker Compose yang sama.
    conn = psycopg2.connect(
        host="postgres",
        database="eratani",
        user="airflow",
        password="airflow"
    )
    cursor = conn.cursor()

    # Lokasi file CSV di dalam environment kontainer Airflow
    df = pd.read_csv("/opt/airflow/data/agriculture_dataset.csv")

    cursor.execute("TRUNCATE TABLE stg_agriculture_raw;")

    for _, row in df.iterrows():
        cursor.execute("""
            INSERT INTO stg_agriculture_raw
            (farm_id, crop_type, farm_area, irrigation_type, fertilizer_used, pesticide_used,
             yield, soil_type, season, water_usage)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """, tuple(row))

    conn.commit()
    print(f"Row count inserted: {len(df)}")
    conn.close()

CREATE_TABLE_SQL = """
CREATE TABLE IF NOT EXISTS stg_agriculture_raw (
    farm_id VARCHAR(50),
    crop_type VARCHAR(100),
    farm_area NUMERIC,
    irrigation_type VARCHAR(50),
    fertilizer_used VARCHAR(50),
    pesticide_used VARCHAR(50),
    yield NUMERIC,
    soil_type VARCHAR(50),
    season VARCHAR(50),
    water_usage NUMERIC
);
"""

with DAG(
    dag_id="eratani_pipeline",
    start_date=datetime(2025, 1, 1),
    schedule_interval="@daily",
    catchup=False
) as dag:

    create_table_task = PostgresOperator(
        task_id='create_stg_table',
        postgres_conn_id='postgres_default',
        sql=CREATE_TABLE_SQL,
    )

    ingest_task = PythonOperator(
        task_id="ingest_raw_csv",
        python_callable=ingest_csv
    )

    create_table_task >> ingest_task
