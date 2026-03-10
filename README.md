<div align='center'>

<img src=gear.png alt="logo" width=150 height=150 />
<br>


<h1>Daemonize</h1>
<p>Easily create linux systemd services</p>
<a href="./LICENSE"><img src="https://img.shields.io/badge/License-AGPL_v3.0-blue?style=for-the-badge"/></a>


</div>

## Installation
Simply run :
```bash
curl -fsSL https://raw.githubusercontent.com/noodlelover1/daemonize/refs/heads/main/install.sh | sudo bash
```

## Usage
```help
USAGE:
    daemonize --name <name> --cmd <command> [--workdir <directory>]

DESCRIPTION:
    daemonize creates a systemd service unit file and starts the service.
    It simplifies the process of daemonizing any command as a background
    service managed by systemd.

OPTIONS:
    --name <name>
        Required. The name of the service. This will be used as the
        systemd service file name (e.g., myapp.service).

    --cmd <command>
        Required. The full command to execute as the daemon. This should
        be the absolute path to the executable, or a command with its
        full path.

    --workdir <directory>
        Optional. The working directory for the service process. If not
        specified, the service will run in the root directory (/).

EXAMPLES:
    # Create a service for a Node.js application
    daemonize --name myapp --cmd "/usr/bin/node /opt/myapp/server.js" --workdir "/opt/myapp"

    # Create a service for a Python script
    daemonize --name flask-app --cmd "/usr/bin/python3 /opt/app/main.py" --workdir "/opt/app"

    # Create a service without specifying workdir
    daemonize --name background-task --cmd "/usr/bin/some-daemon"

FILES:
    Service file: /etc/systemd/system/<name>.service

SEE ALSO:
    systemctl(1), systemd.service(5)
```

## License

AGPL-v3.0

