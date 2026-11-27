<div align="center">
  <img src="logo.svg" alt="boot2inference" width="320" />
</div>

<p align="center">
  <a href="https://wiki.nixos.org">
    <img src="https://img.shields.io/badge/NixOS-flake-5271AA?style=for-the-badge" alt="NixOS flake" />
  </a>
  <a href="https://github.com/ggml-org/llama.cpp">
    <img src="https://img.shields.io/badge/llama.cpp-server-16a34a?style=for-the-badge" alt="llama.cpp server" />
  </a>
  <img src="https://img.shields.io/badge/self%20hosted-yes-14B8A6?style=for-the-badge" alt="self-hosted" />
  <img src="https://img.shields.io/badge/cloud-nope%21-6B7280?style=for-the-badge" alt="no cloud" />
</p>

A specialized NixOS distribution whose only job is to start a [llama.cpp
server](https://github.com/ggml-org/llama.cpp) and then get out of the way.

## Target hardware

boot2inference is currently tuned for my gaming PC. Every decision in this repository
assumes these parts.

| Part | Spec                                                         | Notes              |
| ---- | ------------------------------------------------------------ | ------------------ |
| CPU  | AMD Ryzen 5 3600, 6 cores / 12 threads, Zen 2                |                    |
| RAM  | 16 GB, 2 × 8 GB Corsair Vengeance DDR4, rated 3200 MT/s CL16 | XMP off            |
| GPU  | ASUS Prime Radeon RX 9070 EVO OC, 16 GB VRAM                 | Runs in quiet mode |

## Included Models

- [Unsloth Gemma 4 QAT 26B A4B](https://unsloth.ai/docs/models/gemma-4/qat);
- [Unsloth Inkling 2 Mini](https://unsloth.ai/docs/models/inkling-2-mini);
- [Unsloth Muse Glimmer 30B](https://unsloth.ai/docs/models/muse-glimmer);
- [Unsloth Qwen3.8-27B Dynamic V3.1](https://unsloth.ai/docs/models/qwen3.8).

## Remote access

The ISO runs an SSH server for the `root` user. It accepts public keys only: password
and keyboard-interactive authentication are off.

The key comes from 1Password at build time. `script/build` reads the public key from
`op://Private/boot2inference-ssh/public key` and puts it in
`users.users.root.openssh.authorizedKeys`. To use another item, set `SSH_PUBKEY_REF`. To
use a key that is not in 1Password, export `SSH_PUBKEY` with the full key line.

```console
ssh root@boot2inference.local
```

The host name resolves over mDNS (avahi). Use the IP address if mDNS does not work. The
ISO keeps no state, so it generates new host keys on every boot. SSH warns about a
changed host key after each reboot.

## Monitoring

The console has tools to inspect the server state:

| Tool         | Shows                                                |
| ------------ | ---------------------------------------------------- |
| `htop`       | CPU, memory, and processes                           |
| `btop`       | CPU, memory, disks, and network, with graphs         |
| `amdgpu_top` | GPU clocks, temperature, VRAM, and per-process usage |
| `nvtop`      | GPU usage history and processes                      |
| `sensors`    | CPU and board temperatures                           |
| `lspci`      | PCI devices, including the GPU                       |
| `vulkaninfo` | Vulkan devices, to confirm that RADV works           |

The server reports its state on the HTTP endpoints of llama-server. The web UI
on port 8080 shows the same information from other machines on the network.
`curl` and `jq` are installed for the raw endpoints, for example
`curl -s localhost:8080/models | jq`.
