#!/bin/bash

#
# this file is used to build out our virtual environment
# and add any environment variables needed to our run.sh
# script
#
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

#
# setup of virtual environment if it does not already exist
#
if [[ ! -f ${SCRIPT_DIR}/venv/bin/python ]]; then
  echo "[INFO] Attempting to setup python environment"
  python3 -m venv ${SCRIPT_DIR}/venv &> /dev/null
  if [[ $? -ne 0 ]]; then
    echo "[ERROR] problem setting up virtual environment cannot continue (please review error logs)"
    exit 1
  fi
  "${SCRIPT_DIR}"/venv/bin/python -m pip install -r "${SCRIPT_DIR}"/requirements.txt &> /dev/null
  if [[ $? -ne 0 ]]; then
    echo "[ERROR] problem installing requirements, cannot continue (please review error logs)"
    exit 1
  fi
fi

# SO for sick lidar
SICK_LIDAR_SO=$()
# viam tools needed for utils.py
RUST_UTILS_SO=$(find "${SCRIPT_DIR}" -name libviam_rust_utils.so -printf '%h')

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${RUST_UTILS_SO}:${SICK_LIDAR_SO}

# execute script
exec "${SCRIPT_DIR}"/venv/bin/python3 "${SCRIPT_DIR}"/main.py "$@"
