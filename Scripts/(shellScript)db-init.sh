
#!/bin/bash

set -e

echo "🔧 Starting database initialization..."

if [[ "$DB_TYPE" == "mysql" ]]; then
  echo "⚙️  Initializing MySQL database..."
  mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

elif [[ "$DB_TYPE" == "mongodb" ]]; then
  echo "⚙️  Initializing MongoDB database..."
  mongosh "$MONGO_URI" --eval "
    db = db.getSiblingDB('$MONGO_DB');
    db.createUser({
      user: '$MONGO_USER',
      pwd: '$MONGO_PASSWORD',
      roles: [{ role: 'readWrite', db: '$MONGO_DB' }]
    });
  "
else
  echo "❌ Unsupported DB_TYPE: $DB_TYPE"
  exit 1
fi

echo "✅ Database initialization complete!"
