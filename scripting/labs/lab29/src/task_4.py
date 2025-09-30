#!/usr/bin/env python3

import sys
from pathlib import Path

def create_sv_template(module_name: str):

    # Resolve this script's directory first
    script_dir = Path(__file__).resolve().parent

    # Point to ../files/rtl relative to script
    rtl_dir = (script_dir / "../files/rtl").resolve()

    # Create parent directories if they don't exist
    rtl_dir.mkdir(parents=True, exist_ok=True)

    file_path = rtl_dir / f"{module_name}.sv"

    if file_path.exists():
        print(f"[WARNING] {file_path} already exists. Aborting to avoid overwrite.")
        return

    template = f"""`timescale 10ns/1ps
// Module: {module_name}
// Description: [Add module description here]
// Author: [Add author name]
// Date:
//==============================================================================

module {module_name} (
    // Port declarations
);
    // Design implementation
endmodule
"""
    file_path.write_text(template)
    print(f"[OK] Created: {file_path}")

if __name__ == "__main__":

    if len(sys.argv) != 2:
        print("Usage: python task_4_module_template.py <module_name>")
        sys.exit(1)
    create_sv_template(sys.argv[1])
