
#!/usr/bin/env python3

import os
import pymysql
from pymongo import MongoClient
from pymongo.errors import OperationFailure

db_type = os.getenv("DB_TYPE", "mysql")

if db_type == "mysql":
    try:
        print("🔧 Connecting to MySQL...")
        conn = pymysql.connect(
            host=os.getenv("MYSQL_HOST"),
            user=os.getenv("MYSQL_USER"),
            password=os.getenv("MYSQL_PASSWORD"),
            charset='utf8mb4'
        )
        with conn.cursor() as cursor:
            db_name = os.getenv("MYSQL_DATABASE")
            cursor.execute(f"CREATE DATABASE IF NOT EXISTS {db_name};")
            print(f"✅ MySQL database '{db_name}' initialized.")
        conn.commit()
        conn.close()
    except Exception as e:
        print(f"❌ MySQL init failed: {e}")

elif db_type == "mongodb":
    try:
        print("🔧 Connecting to MongoDB...")
        client = MongoClient(os.getenv("MONGO_URI"))
        db = client[os.getenv("MONGO_DB")]
        db.command("createUser", os.getenv("MONGO_USER"), pwd=os.getenv("MONGO_PASSWORD"),
                   roles=[{"role": "readWrite", "db": os.getenv("MONGO_DB")}])
        print(f"✅ MongoDB database '{os.getenv('MONGO_DB')}' initialized.")
    except OperationFailure as e:
        print(f"❌ MongoDB user already exists or error: {e}")
    except Exception as e:
        print(f"❌ MongoDB init failed: {e}")
else:
    print(f"❌ Unsupported DB_TYPE: {db_type}")
