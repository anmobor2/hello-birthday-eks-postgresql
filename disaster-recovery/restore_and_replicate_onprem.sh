#!/bin/bash
set -e

# --- Variables de Configuración (Personalizar) ---
export AWS_ACCESS_KEY_ID="TU_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="TU_SECRET_KEY"
export AWS_DEFAULT_REGION="eu-west-1"
S3_BUCKET_NAME="hello-birthday-wal-bucket-pro"
PG_DATA_DIR="/var/lib/postgresql/15/main"
PRIMARY_DB_HOST="<IP_DEL_SERVICE_DE_POSTGRES_EN_AWS>" # IP accesible vía VPN
PRIMARY_DB_PORT="5432"
REPLICATION_USER="replicator"
REPLICATION_PASSWORD="password_seguro"

echo "Paso 1: Deteniendo el servicio de PostgreSQL..."
systemctl stop postgresql

echo "Paso 2: Limpiando el directorio de datos antiguo..."
rm -rf $PG_DATA_DIR/*

echo "Paso 3: Descargando el backup base desde S3..."
# Esto asume que tienes un backup llamado 'base.tar.gz' en la raíz del bucket.
# El operador de Zalando tiene formas de automatizar la creación de este backup.
aws s3 cp s3://$S3_BUCKET_NAME/base.tar.gz /tmp/base.tar.gz
tar -xzvf /tmp/base.tar.gz -C $PG_DATA_DIR

echo "Paso 4: Creando el fichero de recuperación y replicación..."
touch $PG_DATA_DIR/standby.signal

cat > $PG_DATA_DIR/postgresql.auto.conf << EOF
# --- Configuración de Restauración y Replicación ---

# Comando para recuperar los segmentos WAL desde el archivo de S3
restore_command = 'aws s3 cp s3://$S3_BUCKET_NAME/wal-archive/%f %p'

# Información de conexión para la replicación en streaming
primary_conninfo = 'host=$PRIMARY_DB_HOST port=$PRIMARY_DB_PORT user=$REPLICATION_USER password=$REPLICATION_PASSWORD sslmode=prefer'

EOF

echo "Paso 5: Ajustando permisos y arrancando PostgreSQL..."
chown -R postgres:postgres $PG_DATA_DIR
chmod 700 $PG_DATA_DIR
systemctl start postgresql

echo "¡Hecho! El servidor ahora está restaurando desde S3 y se conectará para replicación en streaming."