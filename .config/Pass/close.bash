#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2021 Ayush Agarwal <ayushnix at fastmail dot com>
#
# pass vault - Password Store Extension (https://www.passwordstore.org)
# A password store extension that hides data inside a GPG coffin
# ------------------------------------------------------------------------------

if [[ -x "${EXTENSIONS}/vault.bash" ]]; then
  source "${EXTENSIONS}/vault.bash"
elif [[ -x "${SYSTEM_EXTENSION_DIR}/vault.bash" ]]; then
  source "${SYSTEM_EXTENSION_DIR}/vault.bash"
else
  printf '%s\n' "unable to load pass vault, exiting!" >&2
  exit 1
fi

cmd_vault_close
