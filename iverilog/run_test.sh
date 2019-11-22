#!/bin/bash

set -e
set +x

$PREFIX/bin/iverilog -V
$PREFIX/bin/iverilog -h || true

cd test

# Hello world test
echo
echo
echo "Hello World Test ====="
echo $PREFIX/bin/iverilog -v hello_world.v -o hello_world
$PREFIX/bin/iverilog -v hello_world.v -o hello_world
echo "----------------------"
cat hello_world
echo "----------------------"
./hello_world | tee output.log
echo "----------------------"
grep -q 'Hello, World' output.log
echo "----------------------"

# Counter
echo
echo
echo "Counter Test ========="
echo iverilog -o test_counter counter_tb.v counter.v
iverilog -o test_counter counter_tb.v counter.v
echo "----------------------"
cat test_counter
echo "- - - - - - - - - - --"
echo vvp -n test_counter
vvp -n test_counter
echo "----------------------"
echo iverilog -o test_counter -c counter_list.txt
iverilog -o test_counter -c counter_list.txt
echo "- - - - - - - - - - --"
echo vvp -n test_counter
vvp -n test_counter
echo "----------------------"

# More advanced test
echo
echo
echo "FSM Test ============="
echo iverilog -o test_fsm fsm.v
iverilog -o test_fsm fsm.v
echo "----------------------"
cat test_fsm
echo "----------------------"
./test_fsm
echo "----------------------"
