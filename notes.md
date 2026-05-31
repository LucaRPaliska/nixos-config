# Dotfiles Notes

## Hardware (nixos-hardware)

**Machine:** HP ENVY x360 2-in-1 15-ey0xxx — AMD CPU, NVMe SSD

No HP ENVY x360 15-ey specific module exists in nixos-hardware, so generic AMD laptop modules are used instead.

**Modules added to `flake.nix`:**
- `common-cpu-amd` — AMD microcode and kernel params
- `common-cpu-amd-pstate` — AMD P-state driver for better power/performance scaling
- `common-pc-laptop` — enables TLP power management
- `common-pc-laptop-ssd` — enables periodic fstrim for the NVMe drive

**Gotcha:** `common-pc-laptop` sets the CPU governor to `powersave` by default, which throttles
the CPU hard (~1.7GHz) and causes noticeable slowness everywhere. Overridden in
`configuration.nix` with:
```nix
powerManagement.cpuFreqGovernor = "schedutil";
```
`schedutil` is scheduler-aware and energy-efficient but still boosts when there's real CPU load.

---

## Polkit

GUI apps that require privilege escalation (e.g. mounting drives, package managers) need a
polkit authentication agent running in the user session — otherwise they silently fail.

**Changes made:**
- `security.polkit.enable = true` in `configuration.nix`
- `polkit_gnome` added to system packages in `configuration.nix`
- Agent autostarted in `hyprland.conf`:
  ```
  exec-once = /run/current-system/sw/libexec/polkit-gnome-authentication-agent-1
  ```
  The path uses NixOS's `/run/current-system/sw/` symlink tree so it survives rebuilds.
