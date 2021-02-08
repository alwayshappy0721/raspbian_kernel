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

echo nop > /sys/kernel/debug/tracing/current_tracer
echo 0 > /sys/kernel/debug/tracing/events/enable
sleep 1

# ftrace 로그의 버퍼 크기, 킬로바이트 단위로 더 많이 저장하고 싶을때 키우면 됨.
echo 8096 > /sys/kernel/debug/tracing/buffer_size_kb
echo "buffer size update"

# available_filter_functions은 함수 목록을 저장한 파일

echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup/enable
echo 1 > /sys/kernel/debug/tracing/events/sched/sched_switch/enable

echo 1 > /sys/kernel/debug/tracing/events/irq/irq_handler_entry/enable
echo 1 > /sys/kernel/debug/tracing/events/irq/irq_handler_exit/enable

echo 1 > /sys/kernel/debug/tracing/tracing_on
echo "tracing_on"