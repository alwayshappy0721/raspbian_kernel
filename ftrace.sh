#!/bin/bash

:<<'End'
ftrace는 nop, function, function_graph 트레이서 제공
- nop : 기본 트레이스 ftrace 이벤트만
- function : 함수 트레이서로 set_ftrace_filter로 지정한 함수를 누가 호출하는지 알려줌
- function_graph : 함수 실행시간과 세부 호출 정보를 그래프 포맷으로 출력

End

echo 0 > /sys/kernel/debug/tracing/tracing_on
sleep 1
echo "tracing_off"

# 이벤트 설정 -> 커널 서브시스템과 기능별로 세부동작을 출력하는 기능을 지원
# ftrace 모든 이벤트 비활성화함.
echo 0 > /sys/kernel/debug/tracing/events/enable
sleep 1
echo "events disabled"

# set_frace_filter는 현재 트레이서를 function_graph와 function로 설정할 경우 작동
# 파일에 트레이싱하고 싶은 함수 이름 지정 (available_filter_function만 가능)
echo  secondary_start_kernel  > /sys/kernel/debug/tracing/set_ftrace_filter	
sleep 1
echo "set_ftrace_filter init"

# 트레이서를 설정 가능 
echo function > /sys/kernel/debug/tracing/current_tracer
sleep 1
echo "function tracer enabled"

echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup/enable
echo 1 > /sys/kernel/debug/tracing/events/sched/sched_switch/enable

echo 1 > /sys/kernel/debug/tracing/events/irq/irq_handler_entry/enable
echo 1 > /sys/kernel/debug/tracing/events/irq/irq_handler_exit/enable

echo 1 > /sys/kernel/debug/tracing/events/raw_syscalls/enable
sleep 1
echo "event enabled"

echo  schedule ttwu_do_wakeup > /sys/kernel/debug/tracing/set_ftrace_filter

sleep 1
echo "set_ftrace_filter enabled"

# 콜스택 확인
echo 1 > /sys/kernel/debug/tracing/options/func_stack_trace
# 심벌 오프셋 확인
echo 1 > /sys/kernel/debug/tracing/options/sym-offset
echo "function stack trace enabled"

echo 1 > /sys/kernel/debug/tracing/tracing_on
echo "tracing_on"