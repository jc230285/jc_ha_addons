# Home Assistant Add-on: MariaDB_Galera

MariaDB server with Galera cluster replication support.

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Home Assistant add-on.

1. Click the "Install" button to install the add-on.
1. Configure the add-on options (see Configuration section below).
1. Start the "MariaDB_Galera" add-on
1. Check the logs of the "MariaDB_Galera" add-on to see if everything went well.
1. Configure Home Assistant to use the database.

## Configuration

This add-on requires configuration to set up the database properly.

### Option: `root_password`

Sets the password for the MariaDB root user.

**Note**: _This option support secrets, e.g., `!secret mariadb_password`._

### Option: `database`

Database name that will be created for Home Assistant.

### Option: `user`

Username for the database user that Home Assistant will use.

### Option: `user_password`

Password for the database user that Home Assistant will use.

**Note**: _This option support secrets, e.g., `!secret mariadb_user_password`._

### Option: `replicate_from_ip`

IP address of another MariaDB server to replicate from (for Galera clustering).

### Option: `replicate_user`

Username for replication between Galera nodes.

### Option: `replicate_password`

Password for replication between Galera nodes.

**Note**: _This option support secrets, e.g., `!secret mariadb_repl_password`._

### Option: `node_name`

Name of this Galera cluster node.

### Option: `node_address`

IP address of this Galera cluster node.

### Option: `cluster_name`

Name of the Galera cluster this node belongs to.

## Features

- MariaDB server with Galera cluster support
- Automatic database and user creation for Home Assistant
- High availability through Galera clustering
- Persistent data storage

## Home Assistant Configuration

To use this add-on with Home Assistant, add the following to your `configuration.yaml`:

```yaml
recorder:
  db_url: mysql://username:password@core-mariadb-galera:3306/homeassistant?charset=utf8mb4
```

Replace `username`, `password`, and `homeassistant` with the values you configured in the add-on options.

## Changelog & Releases

This repository keeps a change log using [GitHub's releases][releases]
functionality.

Releases are based on [Semantic Versioning][semver], and use the format
of `MAJOR.MINOR.PATCH`. In a nutshell, the version will be incremented
based on the following:

- `MAJOR`: Incompatible or major changes.
- `MINOR`: Backwards-compatible new features.
- `PATCH`: Backwards-compatible bug fixes.

## Support

Got questions?

You have several options to get them answered:

- The [Home Assistant Community Add-ons Discord chat server][discord] for add-on
  support and feature requests.
- The [Home Assistant Discord chat server][discord-ha] for general Home
  Assistant discussions and questions.
- The Home Assistant [Community Forum][forum].
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]

You could also [open an issue here][issue] GitHub.

## Authors & contributors

The original setup of this repository is by [James Criswell][jc21].

For a full list of all authors and contributors,
check [the contributor's page][contributors].

## License

MIT License

Copyright (c) 2025 James Criswell

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[contributors]: https://github.com/jc21/ha_addons/graphs/contributors
[discord-ha]: https://discord.gg/c5DvZ4e
[discord]: https://discord.me/hassioaddons
[forum]: https://community.home-assistant.io?u=frenck
[issue]: https://github.com/jc21/ha_addons/issues
[jc21]: https://github.com/jc21
[reddit]: https://reddit.com/r/homeassistant
[releases]: https://github.com/jc21/ha_addons/releases
[semver]: http://semver.org/spec/v2.0.0.html
