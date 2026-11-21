# ROCm vs. Vulkan for llama.cpp on RDNA4 (RX 9070)

Research date: November 2026.

Question: does the ROCm (HIP) backend or the Vulkan (RADV) backend run small LLM models
faster on the target hardware (AMD Radeon RX 9070, RDNA4, gfx1201, 16 GB VRAM, 640 GB/s
nominal bandwidth)?

Software stack in this flake (from `flake.lock` nixpkgs): Linux 7.3.4, Mesa 26.3.0, ROCm
7.2.4, llama.cpp 1.0.0.

## Findings

### Zenn article, measured 18-19 September 2026 (closest match)

Source: <https://zenn.dev/c4n4242/articles/75659aebdd62d4>

RX 9070 XT on CachyOS (kernel 7.x, Mesa 26.x), llama.cpp pinned to one commit for both
backends, ROCm 7.2.4 (same version as this flake). Method: `llama-bench -p 512 -n 128
-ngl 99 -r 3`, model Qwen3.5-9B Q4_K_M.

| Backend (RX 9070 XT) | pp512 (t/s) | tg128 (t/s) |
| -------------------- | ----------: | ----------: |
| Vulkan (RADV)        |        3822 |        91.4 |
| ROCm 7.2.4           |        2729 |        84.7 |

Vulkan was 40% faster for prompt processing and 8% faster for token generation. It
reached 518 GB/s effective bandwidth, 81% of nominal.

### Phoronix, Lemonade local AI server, 5 October 2026

Source: <https://www.phoronix.com/review/lemonade-vulkan-rocm>

llama.cpp b10825. Two systems: Radeon AI PRO R9700 (RDNA4) and Strix Halo iGPU, each on
a recent Ubuntu kernel.

- Vulkan gave consistently higher tokens per second than ROCm on both systems.
- ROCm gave consistently lower time to first token. For this project this matters
  little: the llama-server loads the model at boot and stays resident, so the latency
  cost is paid once per boot, not per chat.

### Phoronix, ROCm 7.0.0 vs 7.2.3, 14 May 2026

Source: <https://www.phoronix.com/review/amd-rocm7-723>

ROCm user-space upgrades from 7.0.0 to 7.2.3 gave only small gains. The gap to Vulkan
did not close with ROCm releases up to 7.2.x.

## Why Vulkan wins

Mesa's RADV driver compiles native gfx1201 shaders. ROCm's RDNA4 code generation for
llama.cpp kernels reaches less effective memory bandwidth. Token generation is
bandwidth-bound, so the gap converts directly into tokens per second.

Prompt processing on ROCm wins on some models, but this project serves chat traffic,
where token generation dominates.

## Conclusion

Benchmarks on software versions equal to this flake show Vulkan ahead of ROCm on RDNA4:
up to +40% prompt processing and +8% to +9% token generation. Use the Vulkan backend.
Applied in `hosts/boot2inference/configuration.nix` as `services.llama-cpp.package =
pkgs.llama-cpp-vulkan;`. The switch also removes the multi-GB ROCm runtime from the ISO
closure.

Phoronix reports that Linux 7.4 brings 18-23% gains for some AMD AI paths. Both backends
are still moving, so re-measure after large Mesa or llama.cpp upgrades.
