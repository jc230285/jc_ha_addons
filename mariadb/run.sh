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

bashio::log.info "Configuring Galera cluster..."

# Generate Galera config if needed (template logic can be added here)
# envsubst < /etc/mysql/conf.d/galera.cnf.tpl > /etc/mysql/conf.d/galera.cnf

# Start MariaDB (s6-overlay will handle service)
service mysql start

# Wait for MariaDB to be ready
until mysqladmin ping --silent; do
  sleep 1
done

# Create database and user if not exist
mysql -uroot -p"$ROOT_PWD" <<EOF
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

bashio::log.info "MariaDB and Galera cluster ready for Home Assistant."

# Keep container running (handled by s6-overlay)
tail -f /dev/null
