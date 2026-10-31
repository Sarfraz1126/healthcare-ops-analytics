import pandas as pd
import getpass
from sqlalchemy import create_engine, URL

# Table name → which columns are dates
TABLES = {
    "patients": ["BIRTHDATE", "DEATHDATE"],
    "encounters": ["START", "STOP"],
    "conditions": ["START", "STOP"],
    "imaging_studies": ["DATE"],
    "organizations": [],
    "providers": [],
    "payers": [],
}

# Personal identifiers we deliberately don't load (GDPR habit)
PII_COLUMNS = ["SSN", "DRIVERS", "PASSPORT", "PREFIX", "FIRST",
               "LAST", "SUFFIX", "MAIDEN", "ADDRESS"]

password = getpass.getpass("PostgreSQL password: ")
url = URL.create("postgresql+psycopg2", username="postgres", password=password,
                 host="localhost", port=5432, database="synthea")
engine = create_engine(url)

for table, date_cols in TABLES.items():
    print(f"Loading {table}...")
    df = pd.read_csv(f"data/raw/{table}.csv", encoding="utf-8-sig")

    # Clean column names first: strip hidden spaces, make lowercase
    df.columns = [c.strip().lower() for c in df.columns]

    if table == "patients":
        df = df.drop(columns=[c.lower() for c in PII_COLUMNS], errors="ignore")

    for col in date_cols:
        col = col.lower()
        df[col] = pd.to_datetime(df[col], utc=True).dt.tz_localize(None)

    df.to_sql(table, engine, if_exists="replace", index=False, chunksize=10000)
    print(f"  {table}: {len(df):,} rows loaded")

print("Done.")