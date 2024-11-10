#!/usr/bin/env bash
# pass vault - Password Store Extension (https://www.passwordstore.org/)
# Copyright (C) 2019
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
# []

VERSION="1.0"
PASSWORD_STORE_VAULT_DEBUG=false                    # true or false, prints debugging messages
PASSWORD_STORE_VAULT_DIR="$HOME/.config/LegionX/assets"                   # default directory is $PASSWORD_STORE_VAULT_DIR; $PASSWORD_STORE_DIR/$PASSWORD_STORE_VAULT_DIR
PASSWORD_STORE_VAULT_BASENAME="$(basename $(ls $PASSWORD_STORE_VAULT_DIR | grep gpg) .gpg)" # Name of the encrypted file
PASSWORD_STORE_COMMIT="$(cat ~/.password-store/.lastcommit)" # Name of the encrypted file
TAR=$(which tar)

cmd_vault_open() {
  PASSWORD_STORE_VAULT_PATH="$PASSWORD_STORE_VAULT_DIR/${PASSWORD_STORE_VAULT_BASENAME}.gpg" # path includes filename
  $PASSWORD_STORE_VAULT_DEBUG && echo "Setting vault directory to $PASSWORD_STORE_VAULT_DIR"
  $PASSWORD_STORE_VAULT_DEBUG && echo "Setting vault file to $PASSWORD_STORE_VAULT_PATH"

  if [ -z "$PASSWORD_STORE_DIR" ]; then # var is empty
    PASSWORD_STORE_DIR="${HOME}/.password-store"
  fi
  $PASSWORD_STORE_VAULT_DEBUG && echo "Password storage directory is $PASSWORD_STORE_DIR"
  pushd "${PASSWORD_STORE_DIR}" >/dev/null || die "Could not cd into directory $PASSWORD_STORE_DIR. Aborting."

  # does the vault already exist?
  [[ ! -z "$(ls ~/.password-store)" ]] && {
    echo "The vault has already been opened!"
    die "Aborting."
  }

  # file does exist
  mkdir -p "${PASSWORD_STORE_VAULT_DIR}" >/dev/null || die "Could not create directory $PASSWORD_STORE_VAULT_DIR. Aborting."
  $PASSWORD_STORE_VAULT_DEBUG && echo $GPG -d "${GPG_OPTS[@]}" "$PASSWORD_STORE_VAULT_PATH" \| tar xj
  $GPG -d "${GPG_OPTS[@]}" "$PASSWORD_STORE_VAULT_PATH" | tar xj || die "Could not decrypt or untar vault $PASSWORD_STORE_VAULT_PATH. Aborting."
  # rm -f "$PASSWORD_STORE_VAULT_PATH" || die "Could not remove vault $PASSWORD_STORE_VAULT_PATH. Please remove manually. Aborting."
  echo "Passwords restored from: \"${PASSWORD_STORE_VAULT_PATH}\" successfully."
  popd >/dev/null || die "Could not change directory. Aborting."
  cd ~/.password-store
  exec zsh
  ls  --color=auto ~/.password-store
}

cmd_vault_close() {
[[ -n "$(ls ~/.password-store)" ]] && {
pass git log --pretty=format:"%H" -1 > ~/.password-store/.lastcommit
PASSWORD_STORE_COMMIT="$(cat ~/.password-store/.lastcommit)"
if [ "$PASSWORD_STORE_VAULT_BASENAME" != "$PASSWORD_STORE_COMMIT" ]; then
  /nix/store/pmrq09ip8yx2r0288cf0l1gnkfx86r7n-trash-cli-0.24.4.17/bin/trash-put ~/.password-store/.backups/*.gpg
  mv -f $PASSWORD_STORE_VAULT_DIR/*.gpg ~/.password-store/.backups/
fi
}

  PASSWORD_STORE_VAULT_PATH="$PASSWORD_STORE_VAULT_DIR/${PASSWORD_STORE_COMMIT}.gpg" # path includes filename
  $PASSWORD_STORE_VAULT_DEBUG && echo "Setting vault directory to $PASSWORD_STORE_VAULT_DIR"
  $PASSWORD_STORE_VAULT_DEBUG && echo "Setting vault file to $PASSWORD_STORE_VAULT_PATH"

  if [ -z "$PASSWORD_STORE_DIR" ]; then # var is empty
    PASSWORD_STORE_DIR="${HOME}/.password-store"
  fi
  $PASSWORD_STORE_VAULT_DEBUG && echo "Password storage directory is $PASSWORD_STORE_DIR"
  pushd "${PASSWORD_STORE_DIR}" >/dev/null || die "Could not cd into directory $PASSWORD_STORE_DIR. Aborting."

  [[ -z "$(ls ~/.password-store)" ]] && {
    echo "The Vault has already been closed!"
    die "Aborting."
  }

if [ "$PASSWORD_STORE_VAULT_BASENAME" != "$PASSWORD_STORE_COMMIT" ]; then
  mkdir -p "${PASSWORD_STORE_VAULT_DIR}" >/dev/null || die "Could not create directory $PASSWORD_STORE_VAULT_DIR. Aborting."
  set_gpg_recipients "$(dirname "$PASSWORD_STORE_DIR")"
  $PASSWORD_STORE_VAULT_DEBUG && echo tar --exclude ".gpg-id" --exclude=".lastcommit" --exclude=".backups" --exclude=".bash-completions" -cj . \| $GPG -e "${GPG_RECIPIENT_ARGS[@]}" -o "$PASSWORD_STORE_VAULT_PATH" "${GPG_OPTS[@]}"
  tar --exclude ".gpg-id" --exclude="${PASSWORD_STORE_VAULT_DIR}" --exclude=".lastcommit" --exclude=".backups" --exclude=".bash-completions" -cj . | $GPG -e "${GPG_RECIPIENT_ARGS[@]}" -o "$PASSWORD_STORE_VAULT_PATH" "${GPG_OPTS[@]}" || die "Creating encrypted vault failed. Aborting." # add v for debugging if need be
  chmod 400 "${PASSWORD_STORE_VAULT_PATH}" >/dev/null || die "Could not change permissions to read-only on file $PASSWORD_STORE_VAULT_PATH. Aborting."
  BZ2SIZE=$(wc -c <"${PASSWORD_STORE_VAULT_PATH}") # returns size in bytes
  echo "Created vault file \"${PASSWORD_STORE_VAULT_PATH}\" of size ${BZ2SIZE} bytes."
  find . ! -name '.gpg-id' ! -name '.lastcommit' ! -name '.' ! -name '..' ! -path "./${PASSWORD_STORE_VAULT_DIR}" ! -path "./${PASSWORD_STORE_VAULT_DIR}/*" ! -path './.extensions' ! -path './.extensions/*' ! -path './.backups' ! -path './.backups/*' ! -path './.bash-completions' ! -path './.bash-completions/*' -exec rm -rf {} + || die "Removing password store after having created vault failed. Aborting."
  popd >/dev/null || die "Could not change directory. Aborting."
else
  rm -r ~/.password-store/*/
  rm -r ~/.password-store/.gitattributes
  rm -rf ~/.password-store/.git
fi
}
