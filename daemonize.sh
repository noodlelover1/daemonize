#!/bin/bash

show_help() {
    cat << EOF
daemonize - Create and manage systemd services

USAGE:
    daemonize --name <name> --cmd <command> [--workdir <directory>] [--enable] [--start]

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

    --enable
        Optional. Enable the service to start on boot.

    --start
        Optional. Start the service immediately after creating it.

EXAMPLES:
    # Create a service for a Node.js application
    daemonize --name myapp --cmd "/usr/bin/node /opt/myapp/server.js" --workdir "/opt/myapp"

    # Create a service for a Python script
    daemonize --name flask-app --cmd "/usr/bin/python3 /opt/app/main.py" --workdir "/opt/app"

    # Create a service without specifying workdir
    daemonize --name background-task --cmd "/usr/bin/some-daemon"

    # Create and enable service without starting
    daemonize --name myapp --cmd "/usr/bin/node app.js" --enable

FILES:
    Service file: /etc/systemd/system/<name>.service

SEE ALSO:
    systemctl(1), systemd.service(5)

EOF
}

NAME=""
CMD=""
WORKDIR=""
ENABLE=false
START=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            show_help
            exit 0
            ;;
        --name)
            NAME="$2"
            shift 2
            ;;
        --cmd)
            CMD="$2"
            shift 2
            ;;
        --workdir)
            WORKDIR="$2"
            shift 2
            ;;
        --enable)
            ENABLE=true
            shift
            ;;
        --start)
            START=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root (use sudo)."
    exit 1
fi

if [[ -z "$NAME" || -z "$CMD" ]]; then
    echo "Usage: $0 --name <name> --cmd <cmd> [--workdir <workdir>]"
    exit 1
fi

if [[ "$CMD" != */* ]]; then
    echo "Warning: Command '$CMD' does not contain a path. Adding '/usr/bin/' prefix."
    CMD="/usr/bin/$CMD"
fi

SERVICE_FILE="/etc/systemd/system/${NAME}.service"

if [[ -n "$WORKDIR" ]]; then
    WORKDIR_LINE="WorkingDirectory=${WORKDIR}"
else
    WORKDIR_LINE="# WorkingDirectory not specified"
fi

cat > "$SERVICE_FILE" << EOF
[Unit]
Description=${NAME} service

[Service]
Type=forking
ExecStart=${CMD}
${WORKDIR_LINE}
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

if [[ "$ENABLE" == true ]]; then
    systemctl enable "$NAME" 2>/dev/null
    echo "Service '$NAME' enabled."
fi

if [[ "$START" == true ]]; then
    systemctl start "$NAME"
    echo "Service '$NAME' started."
fi

echo "Service file created at: $SERVICE_FILE"
