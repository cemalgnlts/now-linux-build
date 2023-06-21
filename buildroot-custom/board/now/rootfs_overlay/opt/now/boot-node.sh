#!/bin/sh

ITERATION=50
MODULES='require("assert");require("async_hooks");require("buffer");require("child_process");require("cluster");require("console");require("constants");require("crypto");require("dgram");require("diagnostics_channel");require("dns");require("domain");require("events");require("fs");require("http");require("http2");require("https");require("inspector");require("module");require("net");require("os");require("path");require("perf_hooks");require("process");require("punycode");require("querystring");require("readline");require("repl");require("stream");require("string_decoder");require("sys");require("timers");require("tls");require("trace_events");require("tty");require("url");require("util");require("v8");require("vm");require("worker_threads");require("zlib");'
echo "Node initializing..."

for i in `seq $ITERATION`
do
    time -f "[$i/$ITERATION] - %es" node -e "$MODULES" > /dev/null
done