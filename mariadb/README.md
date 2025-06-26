# Home Assistant Community Add-on: MariaDB_Galera

[![Release][release-shield]][release] ![Project Stage][project-stage-shield] ![Project Maintenance][maintenance-shield]

[![Discord][discord-shield]][discord] [![Community Forum][forum-shield]][forum]

MariaDB_Galera add-on for Home Assistant.

## About

This add-on provides a MariaDB server with Galera cluster replication support for Home Assistant.

- Based on the Home Assistant add-on template structure
- Uses s6-overlay for process supervision
- Supports Galera clustering
- Supports configuration via Home Assistant add-on options

## Configuration

Set the following options in the add-on configuration:

- `root_password`: MariaDB root password
- `database`: Default database name
- `user`: Database user
- `user_password`: Database user password
- `replicate_from_ip`: IP address to replicate from
- `replicate_user`: Replication user
- `replicate_password`: Replication password
- `node_name`: Galera node name
- `node_address`: Node IP address
- `cluster_name`: Galera cluster name

## Usage

- MariaDB and Galera cluster are started automatically with the add-on
- Database is accessible on port 3306

## Installation

Follow these steps to install the add-on:

1. Add this repository to your Home Assistant add-on store.
2. Install the "MariaDB_Galera" add-on.
3. Configure the add-on options.
4. Start the add-on.
5. Check the logs of the add-on to see if everything went well.

## License

MIT License

Copyright (c) 2025 James Criswell

[discord-shield]: https://img.shields.io/discord/478094546522079232.svg
[discord]: https://discord.me/hassioaddons
[forum-shield]: https://img.shields.io/badge/community-forum-brightgreen.svg
[forum]: https://community.home-assistant.io?u=frenck
[maintenance-shield]: https://img.shields.io/maintenance/yes/2025.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production%20ready-brightgreen.svg

[release-shield]: https://img.shields.io/badge/version-{{ version }}-blue.svg
[release]: {{ repo }}/tree/{{ version }}
