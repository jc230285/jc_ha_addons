#!/usr/bin/with-contenv bashio

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

bashio::log.info "Generating Galera configuration..."
envsubst < /etc/mysql/conf.d/galera.cnf.tpl > /etc/mysql/conf.d/galera.cnf

# Continue with DB startup and init logic
