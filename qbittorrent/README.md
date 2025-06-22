# Home Assistant Community Add-on: qBittorrent with Flood UI

[![Release][release-shield]][release] ![Project Stage][project-stage-shield] ![Project Maintenance][maintenance-shield]

[![Discord][discord-shield]][discord] [![Community Forum][forum-shield]][forum]

qBittorrent with Flood UI add-on for Home Assistant.

## About

This add-on provides qBittorrent, a free and reliable P2P BitTorrent client, with the Flood web UI for enhanced management.

- Based on the Home Assistant add-on template structure
- Uses s6-overlay for process supervision
- Exposes both qBittorrent and Flood web UIs
- Supports configuration via Home Assistant add-on options

## Usage

- Web UI (qBittorrent): http://[HOST]:[PORT:8080]
- Web UI (Flood): http://[HOST]:[PORT:3000]

## Configuration

No configuration required.

## Volumes

- `/config` - qBittorrent and Flood config
- `/media` - Media files
- `/share` - Shared files
- `/addons` - Addon data
- `/backup` - Backups
- `/ssl` - SSL certificates

[discord-shield]: https://img.shields.io/discord/478094546522079232.svg
[discord]: https://discord.me/hassioaddons
[forum-shield]: https://img.shields.io/badge/community-forum-brightgreen.svg
[forum]: https://community.home-assistant.io?u=frenck
[maintenance-shield]: https://img.shields.io/maintenance/yes/2025.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production%20ready-brightgreen.svg

[release-shield]: https://img.shields.io/badge/version-{{ version }}-blue.svg
[release]: {{ repo }}/tree/{{ version }}
