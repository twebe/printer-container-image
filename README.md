# Printer Container Image 🖨️

A small container image running CUPS to support the old Panasonic KX-MB2000 printer that no longer works on current Linux distributions or MacOS. 🧾

## Prerequisites ✅

- 🐳 Podman (or Docker)
- 🔑 root or sudo access to add printers on the host when needed

## Build 🚀

Build the image with podman:

```bash
podman build . --tag printer-image
```

## Run (manual) ▶️

Run the container and map container CUPS port 631 to host port 6310 to avoid conflicts with a host CUPS:

```bash
podman run -d --name printer-server -p 6310:631 printer-image
```

This exposes CUPS inside the container on ipp://localhost:6310.

## Add the PostScript printer to the host ➕

On the host, register the container-hosted printer as a PostScript printer (adjust the PPD path if needed):

```bash
sudo lpadmin -p Panasonic_KX_MB2000 -E \
  -v ipp://localhost:6310/printers/panasonic-printer \
  -P ./ppd/L_Panasonic-MB2000-postscript.ppd \
  -o media=A4
```

Optional: make it the default printer:

```bash
sudo lpadmin -d Panasonic_KX_MB2000
```

## Start as a user service (Quadlets / podman systemd) ⚙️

Copy the quadlet file to the user systemd folder and reload:

```bash
cp ./printer-server.container ~/.config/containers/systemd/
systemctl --user daemon-reload
systemctl --user enable --now printer-server.container
```

(Adjust unit name if different.)

## Testing and troubleshooting 🔍

- 📋 List printers and status:
  lpstat -p -d

- 🖨️ Print a test file:
  lp -d Panasonic_KX_MB2000 /path/to/test.pdf

- 🔧 Set or confirm printer options:
  lpoptions -p Panasonic_KX_MB2000 -l
  lpoptions -p Panasonic_KX_MB2000 -o PageSize=A4

- If jobs fail, check CUPS logs inside the container (example):
  podman exec -it printer-server cat /var/log/cups/error_log

- 🔁 Restart the container if needed:
  podman restart printer-server

## Notes 📝

- The container exposes CUPS on host port 6310; ensure that port is free and accessible.
- Update the PPD path in the lpadmin command to where you stored the PPD on the host.
