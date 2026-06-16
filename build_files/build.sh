#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Use a COPR Example:
dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release terra-gpg-keys
dnf5 -y copr enable brycensranch/gpu-screen-recorder-git
dnf5 -y copr enable yalter/niri
dnf5 -y copr enable wezfurlong/wezterm-nightly
dnf5 -y copr enable jdxcode/mise
dnf5 -y copr enable ulysg/xwayland-satellite
dnf5 -y copr enable lionheartp/Hyprland

dnf5 -y install \
  libicu-devel \
  google-roboto-fonts \
  rsms-inter-fonts \
  material-icons-fonts \
  gpu-screen-recorder-ui \
  brightnessctl \
  ddcutil \
  cava \
  wlsunset \
  fuzzel \
  waybar \
  swaybg \
  mako \
  swayidle \
  xwayland-satellite \
  xdg-desktop-portal \
  xdg-desktop-portal-gnome \
  wezterm \
  mise \
  NetworkManager-tui \
  libudev-devel \
  polkit-kde \
  btrfs-assistant \
  noctalia-git \
  noctalia-greeter

# Install niri without alacritty
dnf5 -y install niri --setopt=install_weak_deps=False

# Disable COPRs so they don't end up enabled on the final image:
dnf5 -y copr disable brycensranch/gpu-screen-recorder-git
dnf5 -y copr disable yalter/niri
dnf5 -y copr disable wezfurlong/wezterm-nightly
dnf5 -y copr disable jdxcode/mise
dnf5 -y copr disable ulysg/xwayland-satellite

cp /ctx/com.bitwarden.Bitwarden.policy /usr/share/polkit-1/actions/com.bitwarden.Bitwarden.policy
chown root:root /usr/share/polkit-1/actions/com.bitwarden.Bitwarden.policy
# chcon system_u:object_r:usr_t:s0 /usr/share/polkit-1/actions/com.bitwarden.Bitwarden.policy

# Set Global Environment Variables
sed -i '/^TERMINAL=/d' /etc/environment && echo 'TERMINAL=/usr/bin/wezterm' >>/etc/environment
