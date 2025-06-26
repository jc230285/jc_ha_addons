#!/usr/bin/with-contenv bashio

# Read options from Home Assistant add-on config
ROOT_PWD=$(bashio::config 'root_password')
DB_NAME=$(bashio::config 'database')
DB_USER=$(bashio::config 'user')
DB_PASS=$(bashio::config 'user_password')
REPL_IP=$(bashio::config 'replicate_from_ip')
REPL_USER=$(bashio::config 'replicate_user')
REPL_PASS=$(bashio::config 'replicate_password')
NODE_NAME=$(bashio::config 'node_name')
NODE_IP=$(bashio::config 'node_address')
CLUSTER_NAME=$(bashio::config 'cluster_name')

bashio::log.info "Configuring MariaDB Galera cluster..."

# Create Galera configuration
cat > /etc/mysql/mariadb.conf.d/60-galera.cnf << EOF
[galera]
wsrep_on=ON
wsrep_provider=/usr/lib/galera/libgalera_smm.so
wsrep_cluster_address="gcomm://${REPL_IP}"
wsrep_cluster_name="${CLUSTER_NAME}"
wsrep_node_address="${NODE_IP}"
wsrep_node_name="${NODE_NAME}"
wsrep_sst_method=rsync
wsrep_sst_auth="${REPL_USER}:${REPL_PASS}"
binlog_format=row
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0
EOF

# Initialize MariaDB if not already done
if [ ! -d "/var/lib/mysql/mysql" ]; then
    bashio::log.info "Initializing MariaDB database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal
fi

# Start MariaDB with Galera
bashio::log.info "Starting MariaDB with Galera cluster support..."
mysqld_safe --wsrep-new-cluster &

# Wait for MariaDB to be ready
until mysqladmin ping --silent; do
  sleep 1
done

# Set root password if provided
if [ -n "$ROOT_PWD" ]; then
    mysql -uroot <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PWD';
FLUSH PRIVILEGES;
EOF
fi

# Create database and user if not exist
mysql -uroot -p"$ROOT_PWD" <<EOF
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
CREATE USER IF NOT EXISTS '$REPL_USER'@'%' IDENTIFIED BY '$REPL_PASS';
GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT ON *.* TO '$REPL_USER'@'%';
FLUSH PRIVILEGES;
EOF

bashio::log.info "MariaDB Galera cluster ready for Home Assistant."

# Keep container running (handled by s6-overlay)
wait
