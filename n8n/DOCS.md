# Home Assistant Add-on: n8n

Workflow automation for technical people with a visual editor

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Home Assistant add-on.

1. Click the "Install" button to install the add-on.
1. Start the "n8n" add-on
1. Check the logs of the "n8n" add-on to see if everything went well.
1. Click "OPEN WEB UI" to open the n8n interface.
1. Complete the initial setup wizard shown on screen to create your admin user.

## Configuration

### Option: `timezone` (optional)

Set the timezone for n8n. This affects scheduled workflows and time-based operations.

**Default**: `UTC`

### Option: `webhook_url` (optional)

Set a custom webhook URL if you're accessing n8n from a different domain or through a reverse proxy. This is used for webhook nodes in your workflows.

**Example**: `https://n8n.yourdomain.com/`

### Option: `encryption_key` (optional)

Set an encryption key for n8n to encrypt sensitive data in workflows. This is highly recommended for production use. The key should be a random string.

**Example**: `your-very-secure-random-encryption-key-here`

## Getting Started

After installation and first startup:

1. Open the n8n Web UI
2. Create your admin account during the initial setup
3. Start building your first workflow!

## Features

- **Visual Workflow Editor**: Drag and drop interface for building workflows
- **400+ Integrations**: Connect to popular services like Google Sheets, Slack, Discord, GitHub, and more
- **Home Assistant Integration**: Built-in Home Assistant node for seamless integration
- **Scheduled Workflows**: Run workflows on a schedule
- **Webhook Support**: Trigger workflows via HTTP requests
- **Data Transformation**: Transform and manipulate data between services
- **Conditional Logic**: Add if/then logic to your workflows
- **Error Handling**: Handle errors gracefully in your workflows

## Common Use Cases

- Automate Home Assistant based on external triggers
- Sync data between different services
- Send notifications to multiple platforms
- Process and transform data from APIs
- Create custom webhooks for Home Assistant
- Schedule recurring tasks
- Monitor services and send alerts

## Security

For production use, it's recommended to:

1. Set a strong encryption key
2. Use HTTPS if accessing from outside your network
3. Regularly backup your workflow data
4. Keep the add-on updated

## Support

For issues specific to this add-on, please use the GitHub repository.
For n8n-specific questions, refer to the [n8n documentation](https://docs.n8n.io/).

## Data Storage

All n8n data (workflows, credentials, etc.) is stored in the `/data` directory which is mapped to your Home Assistant configuration. This ensures your workflows persist across add-on restarts and updates.
