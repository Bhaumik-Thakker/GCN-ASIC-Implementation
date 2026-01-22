# Lab 4 – GCN (RTL → Synthesis → P&R → Layout Evidence)

This repository contains artifacts for a **Graph Convolution Network (GCN)** hardware design implemented in **SystemVerilog**, along with supporting evidence from a typical digital ASIC flow (RTL simulation, synthesis, place-and-route, and layout verification).

> Notes:
> - Technology/PDK libraries are **not** included in this repo.
> - Testbenches expect external input vectors (see **Running simulation**).

---

## Repository structure (Lab3-style)

- **RTL/** — SystemVerilog RTL for the GCN design (top-level + sub-blocks)
- **Verify/** — testbenches and simulation evidence screenshots
- **DC/** — synthesis outputs (netlist / SDC / reports)
- **Innovus/** — place-and-route outputs (APR netlist, GDS)
- **Innovus_Reports/** — P&R reports / summaries (timing, clock tree, power, etc.)
- **Virtuoso_layout/** — layout + DRC/LVS evidence (screenshots and report files)
- **APR_Layout/** — final Innovus layout screenshot(s)
- **Documents/** — milestone reports (PDF)

---

## Design summary

- Top module: `GCN` (see `RTL/GCN.sv`)
- The design is parameterized (feature/weight dimensions, bit-widths, address widths).
- Major stages implemented in RTL:
  - **Transformation** (feature × weight)
  - **Combination/Aggregation** (graph/COO-based accumulation)
  - **Max/Argmax** post-processing (module depends on milestone version)

---

## Evidence screenshots (quick links)

- Post-syn/APR simulation proof (console output):  
  ![Simulation proof](<Verify/Finish_Vsim.jpg>)

- Final layout view (Virtuoso screenshot):  
  ![Virtuoso layout](<Virtuoso_layout/Layout.jpg>)

- DRC screenshot:  
  ![DRC report](<Virtuoso_layout/DRC_Report.jpg>)

- LVS screenshot:  
  ![LVS report](<Virtuoso_layout/LVS_Report.jpg>)

---

## Running simulation

### Input vectors
The provided testbenches read these files from a local `data/` directory by default:

- `feature_data.txt`
- `weight_data.txt`
- `coo_data.txt`
- `gold_address.txt`

These data files are **not included** in this repository. Place them under:

```
data/
  feature_data.txt
  weight_data.txt
  coo_data.txt
  gold_address.txt
```

### Testbench path configuration
Testbenches in `Verify/` support a plusarg override:

- Default: `data/`
- Override example: `+DATA_DIR=/path/to/data`

### Questa/ModelSim example
From the repo root:

```sh
vlib work
vlog -sv RTL/*.sv Verify/GCN_TB.sv
vsim -c GCN_TB +DATA_DIR=./data -do "run -all; quit"
```

For gate-level / post-APR simulation, compile the appropriate netlist and use the post-syn/APR TB:

```sh
vlib work
vlog -sv Innovus/GCN.apr.v Verify/GCN_TB_post_syn_apr.sv
vsim -c GCN_TB +DATA_DIR=./data -do "run -all; quit"
```

---

## Re-running the flow (high level)

Tool commands vary by lab environment and licenses. The included netlists/reports are provided as **evidence outputs**.

1. **RTL simulation**
   - Compile `RTL/*.sv` with a testbench in `Verify/`.

2. **Synthesis (Design Compiler)**
   - Use your lab’s DC scripts/flow to generate:
     - `DC/*.syn.v`, `DC/*.syn.sdc`, and timing/area/power reports.

3. **Place & Route (Innovus)**
   - Use lab Innovus flow to generate:
     - `Innovus/GCN.apr.v`, `Innovus/GCN.gds`
     - summaries/reports under `Innovus_Reports/`

4. **DRC/LVS (Virtuoso/Calibre)**
   - Evidence outputs are kept under `Virtuoso_layout/`.

---

## Documents

- Milestone 1 report: `Documents/LAB4_M1_1233701211_Bhaumik.pdf`
- Milestone 2 report: `Documents/1233701211_MS2_Report.pdf`
