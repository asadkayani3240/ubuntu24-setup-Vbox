#!/bin/bash

# Update and upgrade the system
echo "Updating and upgrading the system..."
if sudo apt update && sudo apt upgrade -y; then
    echo "System updated and upgraded successfully."
else
    echo "Failed to update and upgrade the system." >&2
    exit 1
fi

# Install linux-headers
echo "Installing linux-headers..."
if sudo apt install -y linux-headers-$(uname -r); then
    echo "linux-headers installed successfully."
else
    echo "Failed to install linux-headers." >&2
    exit 1
fi

# Install build-essential (includes gcc, make, etc.)
echo "Installing build-essential..."
if sudo apt install -y build-essential; then
    echo "build-essential installed successfully."
else
    echo "Failed to install build-essential." >&2
    exit 1
fi

# Verify VBoxLinuxAdditions.run exists
echo "Verifying VBoxLinuxAdditions.run exists..."
if [ -f VBoxLinuxAdditions.run ]; then
    echo "VBoxLinuxAdditions.run found."
else
    echo "VBoxLinuxAdditions.run not found." >&2
    exit 1
fi

# Make VBoxLinuxAdditions.run executable
echo "Making VBoxLinuxAdditions.run executable..."
if chmod +x VBoxLinuxAdditions.run; then
    echo "VBoxLinuxAdditions.run is now executable."
else
    echo "Failed to make VBoxLinuxAdditions.run executable." >&2
    exit 1
fi

# Install bzip2 and tar
echo "Installing bzip2 and tar..."
if sudo apt install -y bzip2 tar; then
    echo "bzip2 and tar installed successfully."
else
    echo "Failed to install bzip2 and tar." >&2
    exit 1
fi

# Run VBoxLinuxAdditions.run
echo "Running VBoxLinuxAdditions.run..."
if sudo ./VBoxLinuxAdditions.run; then
    echo "VBoxLinuxAdditions.run executed successfully."
else
    echo "VBoxLinuxAdditions.run failed to execute." >&2

    # Check the log file for details
    if [ -f /var/log/vboxadd-setup.log ]; then
        echo "Log file contents:"
        cat /var/log/vboxadd-setup.log
    else
        echo "Log file /var/log/vboxadd-setup.log does not exist." >&2
    fi

    # Attempt to manually rebuild the kernel modules
    echo "Attempting to manually rebuild the VirtualBox Guest Additions kernel modules..."
    if sudo /sbin/rcvboxadd quicksetup all; then
        echo "Kernel modules rebuilt successfully. Please restart your system."
    else
        echo "Failed to rebuild the kernel modules." >&2
        exit 1
    fi
fi

# Install net-tools
echo "Installing net-tools..."
if sudo apt install -y net-tools; then
    echo "net-tools installed successfully."
else
    echo "Failed to install net-tools." >&2
    exit 1
fi

# Install additional tools
echo "Installing additional tools..."
if sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common; then
    echo "Additional tools installed successfully."
else
    echo "Failed to install additional tools." >&2
    exit 1
fi

echo "All tasks completed successfully."

