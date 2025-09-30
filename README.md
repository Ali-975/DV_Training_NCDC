# Design Verification Engineer Training – NCDC Islamabad

This repository contains all the **learning material, code samples, and resources** from my DV Engineer training at **NCDC Islamabad**.

---

## 📚 Topics Covered
- ✅ C Programming  
- ✅ Digital Logic Design (DLD)  
- ✅ Assembly Language (RISC-V)  
- ✅ RISC-V ISA & Toolchain  
- ✅ SystemVerilog (RTL + Verification)  
- ✅ Computer Architecture  
- ✅ UVM (Universal Verification Methodology)  
- ✅ Simulation Projects and Labs  

---

## 📁 Repository Structure

| Folder | Description |
|--------|-------------|
| `c_module/` | C and C++ programming exercises and concepts |
| `dld/` | Digital logic design (gates, circuits, SystemVerilog tasks) |
| `riscv/` | RISC-V related material |
| ├── `assembly/` | RISC-V assembly programs |
| └── `architecture/` | RISC-V processor designs (single-cycle, pipelined, etc.) |
| `systemverilog/` | SystemVerilog syntax, testbenches, tasks/functions |
| `computer_architecture/` | Notes and diagrams on CPU and memory organization |
| `uvm/` | UVM agents, drivers, monitors, testbenches |
| `projects/` | Combined verification projects |
| `resources/` | Books, references, and PDFs |

---

## 🔄 Cloning the Repository

This repository uses **Git submodules** (e.g., `riscv/assembly` and `riscv/architecture`).  
To clone everything (including submodules), use:

```bash
git clone --recursive https://github.com/Ali-975/DV_Training_NCDC.git
````

If you already cloned without `--recursive`, run:

```bash
cd DV_Training_NCDC
git submodule update --init --recursive
```

---

## 💼 Purpose

This repository is intended for:

* 📖 Personal reference and revision
* 🤝 Sharing my learning with others
* 💻 Building a **public portfolio** for DV Engineer roles

> ⚠️ This is a **learning repository**. Contributions, corrections, and suggestions are welcome.

