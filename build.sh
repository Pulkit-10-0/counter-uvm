#!/bin/sh
set -eu
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
UVM_SRC=${UVM_SRC:-$HERE/../learn_uvm2017_sv_verilator/tools/uvm-2017/1800.2-2017-1.0/src}
RTL=${COUNTER_RTL:-$HERE/rtl/counter.v}
if [ ! -f "$UVM_SRC/uvm_pkg.sv" ]; then
  printf 'UVM source not found. Set UVM_SRC to the directory containing uvm_pkg.sv.\n' >&2
  exit 1
fi
mkdir -p "$HERE/build"
verilator --binary --timing --coverage -Wno-fatal -j 4 --top-module tb_top \
  --Mdir "$HERE/build/obj_dir" +define+UVM_NO_DPI \
  "+incdir+$UVM_SRC" "+incdir+$HERE" \
  "$UVM_SRC/uvm_pkg.sv" "$RTL" "$HERE/counter_if.sv" \
  "$HERE/counter_pkg.sv" "$HERE/tb_top.sv" \
  > "$HERE/build/compile.log" 2>&1
printf 'Built %s\n' "$HERE/build/obj_dir/Vtb_top"
