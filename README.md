# NixOS impermanence issue

when trying to persist /etc/ssh keys (which are generated on first boot), it becomes impossible to provision a new node with nixos-anywhere

commenting out the following lines allows provisioning:

```
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
```

provisioning with:

```
nix run github:nix-community/nixos-anywhere -- --flake .#x86_machine root@<ip>
```
