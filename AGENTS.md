# AGENTS.md

NixOS flake that builds a boot-only ISO which runs a llama.cpp server on one tuned
gaming PC (Ryzen 5 3600, RX 9070 16 GB). Details in `README.md`.

## Layout

numtide/blueprint flake. Convention-based:

- `hosts/boot2inference/configuration.nix` — the NixOS config (llama-cpp service, avahi,
  wifi, autologin).
- `overlays/llama-cpp-vulkan.nix` — builds `llama-cpp-vulkan` from the Unsloth tree.
- `packages/*.nix` — flake packages. `llama-models.nix` pins model GGUFs and their
  parameters; `nom.nix` wraps nix-output-monitor.
- `script/` — build and flash entry points.

## Conventions

- Hardware-specific constants (ngl, context size, model set) assume the README target
  machine. Change them only with that trade-off in mind.
- Keep model lists sorted alphabetically, not appended to the end: the model
  section in `README.md`, the models in `packages/llama-models.nix`, and any
  other model list. Insert new models at their sorted position.
- Commit messages follow Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`).
