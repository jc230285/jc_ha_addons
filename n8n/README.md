# Home Assistant Add-on: n8n

Workflow automation for technical people with a visual editor

![n8n Logo](logo.png)

## About

n8n is a free and open workflow automation tool. It's a visual workflow editor that helps you connect different services and automate tasks. This add-on provides n8n for Home Assistant, allowing you to create powerful automation workflows that can integrate with Home Assistant and hundreds of other services.

You can use n8n to:

- Create complex automation workflows with a visual editor
- Connect to 400+ different services and APIs
- Automate data processing and synchronization
- Create webhooks and HTTP endpoints
- Schedule workflows and trigger them based on events
- Transform and manipulate data between services

## Installation

Follow these steps to install the add-on:

1. Add this repository to your Home Assistant add-on store.
2. Install the "n8n" add-on.
3. Start the add-on.
4. Check the logs of the add-on to see if everything went well.
5. Click the "OPEN WEB UI" button to open the n8n interface.
6. Complete the initial setup wizard to create your admin user.

## Configuration

The add-on allows you to configure several options:

### Option: `timezone`

Set the timezone for n8n. This affects scheduled workflows and time-based operations.

### Option: `webhook_url`

Set a custom webhook URL if you're accessing n8n from a different domain or through a reverse proxy.

### Option: `encryption_key`

Set an encryption key for n8n to encrypt sensitive data in workflows. This is highly recommended for production use.

## Documentation

Full documentation for this add-on is available in the [DOCS.md](DOCS.md) file.

## License

MIT License

Copyright (c) 2023 James Criswell

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
