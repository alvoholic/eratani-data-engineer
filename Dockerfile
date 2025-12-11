FROM apache/airflow:2.7.1-python3.10

# Instal driver PostgreSQL (psycopg2) yang diperlukan oleh SQLAlchemy
RUN pip install "apache-airflow[postgres]"