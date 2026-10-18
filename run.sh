#!/bin/sh
set -eu
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
(cd "$HERE/build" && "$HERE/build/obj_dir/Vtb_top" +UVM_TESTNAME=counter_test > run.log 2>&1)
cat "$HERE/build/run.log"
