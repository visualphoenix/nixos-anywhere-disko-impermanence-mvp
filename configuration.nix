{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Disk partitioning using disko
  disko.devices = {
    disk = {
      vdb = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "10G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/nix";
              };
            };
            persist = {
              size = "10G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/persist";
              };
            };
          };
        };
      };
    };
    nodev = {
      "/" = {
        device = "none";
        fsType = "tmpfs";
        mountOptions = [
          "size=2G"
          "defaults"
          "mode=755"
        ];
      };
    };
  };
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  # Basic system configuration
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "auto";
    };
    initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    kernelParams = [
      "intel_pstate=passive"
      "split_lock_detect=off"
      "boot.shell_on_fail"
      "usb-storage.quirks=13fe:6500:u"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  # Enable all unfree hardware support.
  hardware.firmware = with pkgs; [ linux-firmware ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  networking.hostName = "x86_machine";

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "$y$j9T$waw73EosB06jnLA/crY2h1$uaJgDJm8UXZIwRGV6xL0E0h30LAMdpk4IyPsgyPHk4B";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.05";
}
