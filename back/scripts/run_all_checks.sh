#!/usr/bin/env bash

set -xe

export LOGS_EXTERNAL_ENABLED=false

. scripts/identify.sh "origin/master...HEAD"

bash scripts/check_commits.sh "origin/master...HEAD"
bash scripts/check_big_files.sh "origin/master...HEAD"
bash scripts/check_gomod.sh


if [[ $HAS_GO == "yes" ]]
then
    scripts/check_format.sh "origin/master...HEAD"
    scripts/check_errors.sh "origin/master...HEAD"
    scripts/check_complexity.sh "origin/master...HEAD"
    scripts/check_code.sh "origin/master...HEAD"
    scripts/check_security.sh "origin/master...HEAD"
    scripts/check_coverage.sh "origin/master...HEAD"
    scripts/check_benchmarks.sh "origin/master...HEAD"
fi

if [[ $HAS_TF == "yes" ]]
then
    scripts/check_terraform.sh "origin/master...HEAD"
fi

if [[ $HAS_YAML == "yes" ]]
then
    scripts/check_yaml.sh "origin/master...HEAD"
    scripts/check_truora_collector.sh "origin/master...HEAD"
fi

if [[ $HAS_PY == "yes" ]]; then
    bash scripts/check_python_code.sh "origin/master...HEAD"
fi

if [[ $HAS_JS == "yes" ]]; then
    scripts/check_javascript.sh "origin/master...HEAD"
    scripts/check_consumer_check_javascript.sh "origin/master...HEAD"
    scripts/check_certificates_javascript.sh "origin/master...HEAD"
    scripts/check_digital_identity_javascript.sh "origin/master...HEAD"
    scripts/check_end_to_end.sh "origin/master...HEAD"
    scripts/check_consumer_check_end_to_end.sh "origin/master...HEAD"
    scripts/check_digital_identity_end_to_end.sh "origin/master...HEAD"
fi
