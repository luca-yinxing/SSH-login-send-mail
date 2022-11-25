#!/usr/bin/bash
# =============================================================================
# Informations
# =============================================================================
# Created By : Luca Gasperini <dev@xsoftware.it>
# Created At : 2022/05/16
# Project    : Simple Admin Script
# Repository : https://github.com/luca-yinxing/SSH-login-send-mail
# Coding     : UTF-8
# =============================================================================
# License
# =============================================================================
: '
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
 
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
  
    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
'
# =============================================================================
# Description
# =============================================================================
: 'Simple send email by SMTP service'
# =============================================================================


# Email text message
MSG="SSH Login at $(date) with user ${PAM_USER} from ${PAM_RHOST} ($(geoiplookup ${PAM_RHOST}))"
# Email subject
SUBJ="SSH Login Notify"
# Recipients mail account, if more than one: 
# DEST="me1@mail.com me2@mail.com me3@mail.com"
DEST=""

# mailx implementation binary (like https://wiki.archlinux.org/title/S-nail)
MAILX="/usr/bin/s-nail"
# SMTP server password
PWD=""
# SMTP server user and sender mail account
FROM=""
# SMTP server url for example SMTP_SERVER="smtp.server.com:25"
SMTP_SERVER=""


IDENTIFIER="ssh-login-send-mail"


if [ "$PAM_TYPE" == "close_session" ]; then
    exit 0
fi

if [ -z "$DEST" ]; then
	printf "Fatal error while sending login mail: No destination" | systemd-cat -t "${IDENTIFIER}"
    exit 1
fi

if [ -z "$SMTP_SERVER" ]; then
	printf "Fatal error while sending login mail: No smtp server" | systemd-cat -t "${IDENTIFIER}"
    exit 1
fi

if [ -z "$FROM" ]; then
	printf "Fatal error while sending login mail: No smtp user" | systemd-cat -t "${IDENTIFIER}"
    exit 1
fi


printf "${MSG}" | ${MAILX} -v		\
 	-s "${SUBJ}" 					\
 	-S smtp="${SMTP_SERVER}" 		\
 	-S smtp-auth="login" 			\
 	-S from="${FROM}"				\
 	-S smtp-auth-user="${FROM}"		\
 	-S smtp-auth-password="${PWD}"	\
 	${DEST}

printf "Sent ssh login email to ${DEST}" | systemd-cat -t "${IDENTIFIER}"

exit 0
