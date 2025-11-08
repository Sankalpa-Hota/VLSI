PCIe Verilog Development

This repository contains a custom PCI Express (PCIe) core development project implemented in Verilog HDL, focusing on understanding, simulating, and building the fundamental layers of the PCIe protocol stack — from the physical interface up to transaction-level packet handling. The aim is to design a lightweight, educational, and synthesizable PCIe endpoint architecture for FPGA or ASIC-based systems.

🔧 Project Overview

This project walks through the modular design of a PCIe Endpoint Controller, built from the ground up in Verilog. Each layer is implemented as an independent, testable module, emphasizing protocol correctness, data integrity, and timing closure.

1. Physical Layer (PHY)

Implements the interface logic to handle 8b/10b or 128b/130b encoding, symbol alignment, and link initialization.

Supports configurable lane width (x1, x4).

Handles data serialization/deserialization and link training sequences (TS1/TS2).

2. Data Link Layer (DLL)

Manages packet framing, sequence numbering, and CRC generation.

Implements ACK/NAK protocol and retry buffer for reliable packet delivery.

Provides a clean interface to upper transaction layer for sending/receiving DLLPs and TLPs.

3. Transaction Layer (TL)

Responsible for packet generation, routing, and decoding for memory read/write, configuration, and I/O transactions.

Includes credit-based flow control and completion handling logic.

Provides AXI-Stream or custom user interface for host communication.

4. Configuration Space and BAR Management

Implements Base Address Registers (BARs) for memory mapping.

Handles configuration reads/writes from the root complex.

Supports PCIe capability registers and device/vendor identification.


🧠 Design Goals

Develop a fully synthesizable PCIe Endpoint core for FPGA prototyping.

Provide simulation testbenches for each protocol layer using Verilog testbenches or cocotb.

Emphasize modular design, making it easier to plug in third-party PHY IP or customize transaction logic.

Enable performance profiling for link training, latency, and throughput.

🧩 Features (Planned / In Progress)

✅ Link initialization and training FSM

✅ DLLP ACK/NAK management

⚙️ TLP header parser and generator

⚙️ Configuration space logic (Vendor ID, BAR registers)

⚙️ AXI-Stream bridge for user logic integration

🔄 Full testbench with BFM (Bus Functional Model)

🧪 Behavioral simulation using ModelSim / Vivado Simulator


📘 Learning Focus

This project is designed as a hands-on hardware learning initiative to deeply understand:

PCIe protocol architecture and signaling

Multi-layer protocol design in hardware

Timing closure and pipeline balancing in high-speed designs

Integration of PCIe with custom logic or DMA engines


🧰 Tools & Technologies

Language: Verilog HDL

Simulation: ModelSim, Vivado Simulator, or QuestaSim

Synthesis/Implementation: Xilinx Vivado / Intel Quartus

Optional Co-simulation: cocotb or Verilator for Python-based testing
