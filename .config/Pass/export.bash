    #!/usr/bin/env bash
# pass export - Password Store Extension (https://www.passwordstore.org/)
# Copyright (C) 2017 Dimitrij Vogt <divogt@dima23.de>.
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

readonly VERSION="1.1"
PASSWORD_STORE=${PASSWORD_STORE:-$HOME/.password-store}
SEPERATOR=","
OTP_PAT='.*secret=(.*)&'
LOGIN='login: (.*)'
URL='url: (.*)'

die() { echo "$*" 1>&2 ; exit 1; }

cmd_file_version() {
    cat <<-_EOF
$PROGRAM $COMMAND $VERSION - A pass extension that exports (all/given) passwords in csv format
_EOF
}
        
cmd_file_usage() {
    cmd_file_version
    echo
    cat <<-_EOF
    Usage:
        $PROGRAM $COMMAND [a | all] [b | bitwarden] [<pass-name> | <pass-dir>] [-v | --version] [-h | --help]
            Provide a command to export passwords in csv format

        Options:
            a, all           Export all passwords
            b, bitwarden     Export in bitwarden CSV format
            -v, --version    Show version information.
            -h, --help       Print this help message and exit.

    More information may be found in the pass-export(1) man page.
_EOF
}

_get_entries_from_dir() {
    _PS_LENGTH=${#PASSWORD_STORE}
    for ENTRY in $(find "${PASSWORD_STORE}/${1}" -type f -name "*.gpg")
    do
        _NAME="${ENTRY:_PS_LENGTH + 1}"
        cmd_export "${_NAME/.gpg/}"
    done
}

# export all
cmd_export_all() {
    _PS_LENGTH=${#PASSWORD_STORE}
    for ENTRY in $(find "${PASSWORD_STORE}/" -type f -name "*.gpg")
    do
        _NAME="${ENTRY:_PS_LENGTH + 1}"
        cmd_export "$@" "${_NAME/.gpg/}"
    done

    exit 0;
}

check_bw() {
    _BW=($*)
    if [ "${_BW}" == "b" ]; then
        unset _BW[0]
        set -- "${_BW[@]}"
    fi
    echo $@
}
# folder,favorite,type,name,notes,fields,login_uri,login_username,login_password,login_totp

# $@ names to export
# export format: path;name;password;otp-secret;note
cmd_export() {
    [ $# -eq 0 ] && die "Usage: $PROGRAM $COMMAND [a | --all] [<pass-name> | <pass-dir>] [-v] [-h]"


    _BW=$1
    _PARAMS="$(check_bw $@)"
    # check if argument is a directory
    # print csv headers
    # echo "path${SEPERATOR}name${SEPERATOR}password${SEPERATOR}otp-secret{SEPERATOR}note"
    for var in $_PARAMS
    do
        if [[ -d "${PASSWORD_STORE}/${var}" ]]; then
            _get_entries_from_dir "${var}"
            continue
        fi
        [[ ! -f "${PASSWORD_STORE}" ]] || die "Pass name not exists!"
        _PASSNAME=$(basename $var)
        _PATHNAME=$(dirname $var)
        _DATA=$(pass show $var)
        _PW="$(head -n 1 <<<$_DATA)"
        _PW="$(sed 's/\\/\\\\/g' <<<$_PW )"
        _PW="\"$(sed 's/"/\\"/g' <<<$_PW )\""
        _NOTELINES=$(tail -n +2 <<<$_DATA)
        _NOTE=""
        _OTP=""
        _LOGIN=""
        _URL=""
        while IFS= read -r line; do
            if [[ "$line" =~ $OTP_PAT ]]; then
                _OTP="${BASH_REMATCH[1]}"
                continue;
            fi
            if [[ "$line" =~ $LOGIN ]]; then
                _LOGIN="${BASH_REMATCH[1]}"
                continue;
            fi
            if [[ "$line" =~ $URL ]]; then
                _URL="${BASH_REMATCH[1]}"
                continue;
            fi
            _NOTE="${_NOTE}${line/$'\n'/} - "
        done <<< "$_NOTELINES"
        # [ -z "${_NOTE}" ] && _NOTE="${_NOTE::-3}" # TODO check this line xD
        if [ "${_BW}" == "b" ]; then
            print_bitwarden "${_PASSNAME}" "${_PATHNAME}" "${_PW}" "${_NOTE}" "${_OTP}"
        else
            print_default "${_PASSNAME}" "${_PATHNAME}" "$_LOGIN" "${_PW}" "${_URL}" "${_NOTES}" "${_OTP}"
        fi
    done
}

print_default() {
    echo "${2}${SEPERATOR}${1}${SEPERATOR}${3}${SEPERATOR}${4}${SEPERATOR}${5}${SEPERATOR}${6}${SEPERATOR}${7}"
}

print_bitwarden() {
    echo "${SEPERATOR}${SEPERATOR}login${SEPERATOR}${2}${SEPERATOR}${4}${SEPERATOR}${SEPERATOR}${SEPERATOR}${1}${SEPERATOR}${3}${SEPERATOR}${5}"
}

# Getopt options
while true; do case $1 in
    a|all) shift; cmd_export_all "$@" ;;
    -h|--help) shift; cmd_file_usage; exit 0 ;;
    -v|--version) shift; cmd_file_version; exit 0 ;;
    *) cmd_export "$@"; exit 0 ;;
esac done
