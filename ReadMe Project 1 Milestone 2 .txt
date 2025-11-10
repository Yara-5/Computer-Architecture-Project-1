RISC-V Single-Cycle CPU Project
--------------------------------

Student Names:
- [Yara Ahmed ]
- [Ahmed Bamadhaf]

--------------------------------

Overview:
We designed and implemented a single-cycle RISC-V processor using Verilog modules created in the lab. The processor executes instructions in one clock cycle and supports arithmetic, logic, load/store, and branch operations.

Main Modules:
- PC (Program Counter): Holds the address of the current instruction.
- Instruction Memory: Stores up to 64 instructions for testing.
- Control Unit: Generates control signals (Branch, MemRead, MemWrite, RegWrite, ALUSrc, MemToReg, ALUOp, auipc, lui, jalr, writePC).
- Register File: Contains 32 registers (x0–x31) with two read ports and one write port.
- Data Memory: Handles load and store instructions.
- ALU: Performs arithmetic, logic, shift, and comparison operations and generates status flags (Z, C, V, S).
- ALU Control: Determines which ALU operation to perform based on ALUOp, funct3, and funct7.
- Immediate Generator: Extracts and sign-extends immediate values.
- Branch Unit: Decides whether a branch should be taken.

--------------------------------
Assumptions:
- All instructions are word-aligned (4 bytes each).
- Instruction Memory is preloaded manually with test instructions.
- The CPU runs in a single-cycle model (no pipelining).
- Only basic RISC-V RV32I instructions are implemented.

--------------------------------
What Works:
- Most arithmetic, logical, and shift operations (ADD, SUB, AND, OR, XOR, SLT, SLTU, SLL, SRL, SRA).
- Immediate operations (ADDI, ANDI, ORI, etc.) except where noted.
- Load and store instructions (LW, SW).
- Branch instructions (BEQ, BNE, BLT, BGE, BLTU, BGEU).
- Correct PC update and instruction sequencing.

--------------------------------
What Does Not Work / Known Issues:
- ADDI instruction does not handle negative immediate values correctly.
- Minor calculation errors were found during early debugging (fixed).
- No support for pipelining or hazards (single-cycle only).
- fence

--------------------------------
Debugging Summary:
- Early errors in ALU_Control caused incorrect results for ADD, AND, SUB, and OR.
- After correcting ALU selection logic, these instructions worked properly.
- Added missing system instructions and verified control signal generation.

--------------------------------
Conclusion:
The CPU successfully executes most RISC-V instructions in a single cycle. Debugging and testing improved our understanding of control logic, instruction decoding, and datapath design.
