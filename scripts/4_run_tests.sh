#!/bin/bash

set -ev

utPLSQL-cli/bin/utplsql run project_duong_reisinger/project_duong_reisinger@//127.0.0.1:1521/XE \
  -source_path=source -test_path=test \
  -f=ut_documentation_reporter -c \
  --failure-exit-code=1 -D
