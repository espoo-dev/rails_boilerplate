#!/bin/bash

coverage_threshold=100
coverage_report=$(tail -n 1 coverage/.last_run.json)
coverage_percent=$(echo $coverage_report | jq -r '.result.covered_percent')

if [ "$coverage_percent" -lt "$coverage_threshold" ]; then
  echo "Code coverage is below $coverage_threshold% ($coverage_percent%)"
  exit 1
fi
