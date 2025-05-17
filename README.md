# Printer Container Image
Container Image with Cups Printer Server to continue using a very old printer which isn't working anymore with current Linux Distributions.

# Build the Container Image

The image can be build via podman using:

`podman build . --tag printer-image`

# Start the Container manually

The container can be started by:

`podman run -d --name printer-server -p 6310:631 printer-image`

This will map the exposed port 631 of cups running in the container to the outsie port 6310. This will prevent a conflict with a potentially running cups server on the host system.

# Start the Container automatically as Service using Quadlets

Copy the file *printer-server.container* to *~/.config/containers/systemd*:

`cp ./printer-server.container ~/.config/containers/systemd`

Reload *systemd*:

`systemctl --user daemon-reload`
