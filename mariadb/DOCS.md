# Home Assistant Add-on: MariaDB

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to **Settings** -> **Add-ons** -> **Add-on store**.
2. Find the "MariaDB" add-on and click it.
3. Click on the "INSTALL" button.

## How to use

1. Set the `logins` -> `password` field to something strong and unique.
2. Start the add-on.
3. Check the add-on log output to see the result.
4. Add the `recorder` integration to your Home Assistant configuration.

## Add-on Configuration

The MariaDB server add-on can be tweaked to your likings. This section
describes each of the add-on configuration options.

Example add-on configuration:

```yaml
databases:
  - homeassistant
logins:
  - username: homeassistant
    password: PASSWORD
  - username: read_only_user
    password: PASSWORD
rights:
  - username: homeassistant
    database: homeassistant
  - username: read_only_user
    database: homeassistant
    privileges:
      - SELECT
# Galera cluster configuration (optional)
galera_enabled: true
cluster_name: "homeassistant_cluster"
node_name: "node1"
node_address: "192.168.1.100"
cluster_address: "192.168.1.100,192.168.1.101,192.168.1.102"
wsrep_sst_user: "wsrep_sst"
wsrep_sst_password: "SST_PASSWORD"
```

### Option: `databases` (required)

Database name, e.g., `homeassistant`. Multiple are allowed.

### Option: `logins` (required)

This section defines a create user definition in MariaDB. [Create User][createuser] documentation.

### Option: `logins.username` (required)

Database user login, e.g., `homeassistant`. [User Name][username] documentation.

### Option: `logins.password` (required)

Password for user login. This should be strong and unique.

### Option: `rights` (required)

This section grant privileges to users in MariaDB. [Grant][grant] documentation.

### Option: `rights.username` (required)

This should be the same user name defined in `logins` -> `username`.

### Option: `rights.database` (required)

This should be the same database defined in `databases`.

### Option: `rights.privileges` (optional)

A list of privileges to grant to this user from [grant][grant] like `SELECT` and `CREATE`.
If omitted, grants `ALL PRIVILEGES` to the user. Restricting privileges of the user
that Home Assistant uses is not recommended but if you want to allow other applications
to view recorder data should create a user limited to read-only access on the database.

### Option: `mariadb_server_args` (optional)

Some users have experienced [errors][migration-issues] during Home Assistant schema updates on large databases.
Defining the recommended parameters can help if there is RAM available.

Example: `--innodb_buffer_pool_size=512M`

## Galera Cluster Configuration

This add-on supports MariaDB Galera Cluster for high availability and synchronous replication across multiple nodes.

### Option: `galera_enabled` (optional)

Set to `true` to enable Galera clustering. Default: `false`

### Option: `cluster_name` (optional)

Name of the Galera cluster. All nodes in the same cluster must use the same name.
Default: `"homeassistant_cluster"`

### Option: `node_name` (optional)

Unique name for this node within the cluster. Each node must have a different name.
Default: `"node1"`

### Option: `node_address` (required when galera_enabled is true)

IP address of this node that other nodes can reach. This should be the actual IP address
of the Home Assistant instance, not localhost or 127.0.0.1.

### Option: `cluster_address` (required when galera_enabled is true)

Comma-separated list of IP addresses of all nodes in the cluster. Include the current node's
address in this list as well.

Example: `"192.168.1.100,192.168.1.101,192.168.1.102"`

### Option: `wsrep_sst_user` (optional)

Username for State Snapshot Transfer (SST) authentication. This user is created automatically
with the necessary privileges. Default: `"wsrep_sst"`

### Option: `wsrep_sst_password` (required when galera_enabled is true)

Password for the SST user. This must be the same on all nodes in the cluster and should be
strong and unique.

## Setting up a Galera Cluster

### Prerequisites

1. At least 3 Home Assistant instances (recommended for quorum)
2. Reliable network connectivity between all nodes
3. Synchronized time on all nodes (use NTP)
4. Same MariaDB add-on version on all nodes

### Step-by-Step Setup

#### Step 1: Configure the First Node (Bootstrap Node)

1. Install and configure the MariaDB add-on with Galera enabled
2. Set `cluster_address` to include all planned nodes
3. Start the add-on - it will automatically bootstrap the cluster

Example configuration for the first node:

```yaml
galera_enabled: true
cluster_name: "homeassistant_cluster"
node_name: "node1"
node_address: "192.168.1.100"
cluster_address: "192.168.1.100,192.168.1.101,192.168.1.102"
wsrep_sst_user: "wsrep_sst"
wsrep_sst_password: "your_strong_sst_password"
```

#### Step 2: Add Additional Nodes

1. Configure each additional node with the same cluster settings
2. Use unique `node_name` and `node_address` for each node
3. Keep `cluster_name`, `cluster_address`, and SST credentials identical
4. Start the add-on - it will join the existing cluster

Example configuration for the second node:

```yaml
galera_enabled: true
cluster_name: "homeassistant_cluster"
node_name: "node2"
node_address: "192.168.1.101"
cluster_address: "192.168.1.100,192.168.1.101,192.168.1.102"
wsrep_sst_user: "wsrep_sst"
wsrep_sst_password: "your_strong_sst_password"
```

### Important Notes

- **Quorum**: For automatic split-brain protection, use an odd number of nodes (3, 5, 7, etc.)
- **Bootstrapping**: Only the first node bootstraps the cluster. Additional nodes join automatically
- **State Transfer**: New nodes will automatically sync data from existing nodes
- **Network**: Ensure these ports are accessible between nodes:
  - Port 3306: MySQL client connections
  - Port 4567: Galera replication traffic
  - Port 4568: Incremental State Transfer (IST)
  - Port 4444: State Snapshot Transfer (SST)
- **Consistency**: All writes are synchronously replicated to all nodes

### Monitoring Cluster Status

You can check cluster status by connecting to any node and running:

```sql
SHOW STATUS LIKE 'wsrep%';
```

Key status variables:

- `wsrep_ready`: Should be 'ON'
- `wsrep_cluster_size`: Number of nodes in cluster
- `wsrep_cluster_status`: Should be 'Primary'
- `wsrep_local_state_comment`: Should be 'Synced'

### Troubleshooting

#### Common Issues

**Split-brain**: If the cluster splits, check network connectivity and restart nodes

**SST Issues**: Verify SST user credentials are identical on all nodes

**Bootstrap Issues**: If cluster won't start, check that only one node is bootstrapping

#### Galera Port Connectivity Issues

Galera clustering requires specific ports to be accessible between nodes:

- **Port 3306**: MySQL client connections
- **Port 4567**: Galera replication traffic (gcomm)
- **Port 4568**: Incremental State Transfer (IST)
- **Port 4444**: State Snapshot Transfer (SST)

**Symptoms**: Only port 3306 is reachable, but Galera ports (4567, 4568, 4444) are not accessible.

**Causes**:

1. Host firewall blocking Galera ports
2. Network configuration issues
3. Container networking problems

**Solutions**:

1. **Check container port exposure**: The addon automatically exposes the required ports, but verify with:

   ```bash
   docker ps | grep mariadb
   ```

2. **Verify ports are listening**: Inside the MariaDB container, run:

   ```bash
   galera-debug check [node_ip_address]
   ```

3. **Check host firewall** (if using host network mode):

   ```bash
   # Ubuntu/Debian
   sudo ufw status
   sudo ufw allow 4567
   sudo ufw allow 4568
   sudo ufw allow 4444

   # CentOS/RHEL
   sudo firewall-cmd --list-ports
   sudo firewall-cmd --permanent --add-port=4567/tcp
   sudo firewall-cmd --permanent --add-port=4568/tcp
   sudo firewall-cmd --permanent --add-port=4444/tcp
   sudo firewall-cmd --reload
   ```

4. **Network connectivity test**: From one node, test connectivity to another:

   ```bash
   telnet 192.168.1.101 4567
   telnet 192.168.1.101 4568
   telnet 192.168.1.101 4444
   ```

5. **Check MariaDB Galera configuration**: Verify that Galera is properly configured:
   ```sql
   SHOW VARIABLES LIKE 'wsrep%';
   SHOW STATUS LIKE 'wsrep%';
   ```

#### Debugging Tools

The addon includes a built-in debugging tool. Inside the container, run:

```bash
galera-debug check [node_ip_address]
```

This will:

- Check if all required ports are listening
- Test local connectivity to Galera ports
- Show MariaDB process status
- Display current Galera configuration
- Show Galera cluster status

## Home Assistant Configuration

MariaDB will be used by the `recorder` and `history` components within Home Assistant. For more information about setting this up, see the [recorder integration][mariadb-ha-recorder] documentation for Home Assistant.

Example Home Assistant configuration:

```yaml
recorder:
  db_url: mysql://homeassistant:password@core-mariadb/homeassistant?charset=utf8mb4
```

## Support

Got questions?

You have several options to get them answered:

- The [Home Assistant Discord Chat Server][discord].
- The Home Assistant [Community Forum][forum].
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]

In case you've found a bug, please [open an issue on our GitHub][issue].

[createuser]: https://mariadb.com/kb/en/create-user/
[username]: https://mariadb.com/kb/en/create-user/#user-name-component
[hostname]: https://mariadb.com/kb/en/create-user/#host-name-component
[grant]: https://mariadb.com/kb/en/grant/
[migration-issues]: https://github.com/home-assistant/core/issues/125339
[mariadb-ha-recorder]: https://www.home-assistant.io/integrations/recorder/
[discord]: https://discord.gg/c5DvZ4e
[forum]: https://community.home-assistant.io
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[issue]: https://github.com/home-assistant/addons/issues
[reddit]: https://reddit.com/r/homeassistant
[repository]: https://github.com/hassio-addons/repository
