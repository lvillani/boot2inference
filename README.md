# boot2inference

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
