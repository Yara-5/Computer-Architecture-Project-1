===================================================================
Project: RISC-V Pipelined Processor (RV32I Subset)
Course: Computer Architecture (Project 1)
===================================================================

### Student Information

| **Yara Abdelkader** | yara2005@aucegypt.edu |
| **Ahmed Bamhdaf** | [Please Insert Ahmed's Email Here] |

---

## Release Notes (November 24, 2025)

This release represents the final, complete implementation of the 5-stage pipelined RISC-V (RV32I) processor with full hazard resolution.

### What Works (Implemented Features)

1.  **5-Stage Pipeline:** Fully implemented stages (IF, ID, EX, MEM, WB) separated by dedicated pipeline registers.
2.  **Instruction Set:** Supports the **42 user-level instructions** of the RV32I ISA.
3.  **Data Hazard Resolution:**
    * **Forwarding:** Standard data hazards (Register-Register dependencies) are resolved via the **Forwarding Unit** routing data from the EX/MEM and MEM/WB registers back to the ALU inputs in the EX stage.
    * **Load-Use Hazard:** Resolved by **stalling** for one cycle.
4.  **Structural Hazard Resolution:** The hazard created by the **Single Memory** unit (used for both instruction and data access) is resolved by **stalling** for one cycle whenever a Load or Store instruction is in the MEM stage.
5.  **Control Hazard Resolution:**
    * **Branches/Jumps (MEM Resolution):** Correctly flushes the two misfetched instructions in the IF and ID stages when a branch is taken or a jump occurs. The PC is then updated to the target address.
    * **Halting Instructions (ID Resolution):** Detects instructions like ECALL/EBREAK early in the ID stage, flushing only the instruction in the IF stage before halting.

### What Does Not Work / Known Issues

* **System Calls:** The `ECALL` and `EBREAK` instructions are currently implemented as **halting instructions** (stopping the clock) rather than executing full operating system services.
* **Misprediction:** The current implementation uses a simple **"Always Not Taken"** branch policy, meaning a taken branch will always incur the latency of a flush. Advanced branch prediction logic is not implemented.

### Key Assumptions

* **Memory Model:** It is assumed that the **Single Memory** unit is fast enough that it does not introduce additional pipeline stalls beyond the single-cycle structural hazard handled in the Verilog.
* **Reset State:** The `reset` signal correctly initializes the PC to `0x00000000` and clears all registers and pipeline latches.