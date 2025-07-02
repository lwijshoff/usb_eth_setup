# USB Ethernet Adapter Setup Script

This repository contains a script to automatically set up your USB Ethernet adapter on a fresh Ubuntu system. The script copies your local `udev` rule and `systemd` service files to the correct locations, installs the necessary dependencies, and reloads the system configurations.

## Prerequisites

* The script assumes that your `10-local-net.rules` and `eth_startup.service` files are located **in the same directory** as the script itself.
* The system should have **Ubuntu** installed (or any Debian-based system), and you should have **root** privileges to execute the script.

## Setup

### 1. Clone the repository

First, clone the repository or download the files to your machine:

```bash
git clone https://github.com/lwijshoff/usb-ethernet-setup.git
cd usb-ethernet-setup
```

### 2. Ensure Local Files Are Present

Make sure your `10-local-net.rules` and `eth_startup.service` files are in the same directory as the script. The directory should look like this:

```text
usb-ethernet-setup/
├── main.sh
├── 10-local-net.rules
└── eth_startup.service
```

### 3. Make the Script Executable

Before running the script, you need to make it executable:

```bash
chmod +x main.sh
```

### 4. Run the Script

Run the script with `sudo` to ensure it has the necessary privileges to copy the files and install dependencies:

```bash
sudo ./main.sh
```

### What the Script Does:

* **Copies your local files**: It copies `10-local-net.rules` to `/etc/udev/rules.d/` and `eth_startup.service` to `/etc/systemd/system/`.
* **Installs dependencies**: It installs `dhclient` (for obtaining an IP address) and ensures `systemd` is available.
* **Reloads system configurations**: It reloads `udev` rules and `systemd` services to apply the new configurations.
* **Enables the systemd service**: It enables and starts the `eth_startup.service` so that your USB Ethernet adapter is automatically brought up and receives an IP address on boot.

### 5. Verify the Setup

After running the script, you can verify that everything is working:

* **Check the renamed interface**:

  ```bash
  ip a
  ```

  Your USB Ethernet adapter should now be named `eth1`.

* **Check the systemd service status**:

  ```bash
  systemctl status eth_startup.service
  ```

  The service should be **active** and running.

### 6. Reboot (Optional)

If you'd like to test the setup after a reboot, you can reboot the system:

```bash
sudo reboot
```

The adapter should automatically be brought up and assigned an IP address using `dhclient` upon boot.

---

## Troubleshooting

* If the USB Ethernet adapter doesn't show up as `eth1`, make sure the MAC address in your `10-local-net.rules` file matches the actual MAC address of your USB Ethernet adapter.

  * You can find the MAC address by running `ifconfig` or `ip a` and locating your `enx...` interface.

* If the systemd service fails, check the logs:

  ```bash
  journalctl -u eth_startup.service
  ```

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.