#!/bin/bash

find test -type f -name "*.log" -exec sed -i 's/[0-9]\{12\}/111111111111/g' {} +
find test -type f -name "*.log" -exec sed -i 's/vpc-[a-z0-9]*/vpc-11111111/g' {} +
find test -type f -name "*.log" -exec sed -i 's/pl-[a-z0-9]*/pl-1111111111/g' {} +
find test -type f -name "*.log" -exec sed -i 's/sg-[a-z0-9]*/sg-1111111111111111/g' {} +
find test -type f -name "*.log" -exec sed -i 's/sgrule-[a-z0-9]*/sgrule-1111111111/g' {} +
