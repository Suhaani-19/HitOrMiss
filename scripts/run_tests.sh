#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
mkdir -p build results/waveforms results/simulation_logs

run_test() {
  local name="$1"
  shift
  echo "=== Running ${name} ==="
  iverilog -g2012 -Wall -s "$name" -o "build/${name}" "$@"
  vvp "build/${name}" | tee "results/simulation_logs/${name}.log"
}

run_test tb_pipeline_registers \
  rtl/pipeline_registers/if_id_register.v \
  rtl/pipeline_registers/id_ex_register.v \
  rtl/pipeline_registers/ex_mem_register.v \
  rtl/pipeline_registers/mem_wb_register.v \
  tb/tb_pipeline_registers.v

run_test tb_forwarding_unit rtl/forwarding/forwarding_unit.v tb/tb_forwarding_unit.v
run_test tb_hazard_detection rtl/hazard_detection/hazard_detection_unit.v tb/tb_hazard_detection.v
run_test tb_alu rtl/processor/alu.v tb/tb_alu.v
run_test tb_control_unit rtl/processor/control_unit.v tb/tb_control_unit.v
run_test tb_register_file rtl/processor/register_file.v tb/tb_register_file.v
run_test tb_instruction_memory rtl/memory/instruction_memory.v tb/tb_instruction_memory.v
run_test tb_data_memory rtl/memory/data_memory.v tb/tb_data_memory.v
run_test tb_performance_counters rtl/performance/performance_counters.v tb/tb_performance_counters.v

run_test tb_processor \
  rtl/pipeline_registers/if_id_register.v \
  rtl/pipeline_registers/id_ex_register.v \
  rtl/pipeline_registers/ex_mem_register.v \
  rtl/pipeline_registers/mem_wb_register.v \
  rtl/forwarding/forwarding_unit.v \
  rtl/hazard_detection/hazard_detection_unit.v \
  rtl/processor/alu.v rtl/processor/register_file.v \
  rtl/processor/control_unit.v rtl/processor/hazard_processor_top.v \
  rtl/memory/instruction_memory.v rtl/memory/data_memory.v \
  rtl/performance/performance_counters.v tb/tb_processor.v

run_test tb_load_use_processor \
  rtl/pipeline_registers/if_id_register.v \
  rtl/pipeline_registers/id_ex_register.v \
  rtl/pipeline_registers/ex_mem_register.v \
  rtl/pipeline_registers/mem_wb_register.v \
  rtl/forwarding/forwarding_unit.v \
  rtl/hazard_detection/hazard_detection_unit.v \
  rtl/processor/alu.v rtl/processor/register_file.v \
  rtl/processor/control_unit.v rtl/processor/hazard_processor_top.v \
  rtl/memory/instruction_memory.v rtl/memory/data_memory.v \
  rtl/performance/performance_counters.v tb/tb_load_use_processor.v

run_test tb_store_load_processor \
  rtl/pipeline_registers/if_id_register.v \
  rtl/pipeline_registers/id_ex_register.v \
  rtl/pipeline_registers/ex_mem_register.v \
  rtl/pipeline_registers/mem_wb_register.v \
  rtl/forwarding/forwarding_unit.v \
  rtl/hazard_detection/hazard_detection_unit.v \
  rtl/processor/alu.v rtl/processor/register_file.v \
  rtl/processor/control_unit.v rtl/processor/hazard_processor_top.v \
  rtl/memory/instruction_memory.v rtl/memory/data_memory.v \
  rtl/performance/performance_counters.v tb/tb_store_load_processor.v

echo "All 12 testbenches passed."
