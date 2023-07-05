#!/bin/sh

HOMEDIRECTORYNAME="${1}"

cut -f 1 -d : | while read localusername
do
	last "${localusername}" | awk '{print $1 " " $3}' | sort | uniq | egrep "\.(.*)\." | while read localauthdusername remoteauthdhostname
	do
		( printf "$(hostname)\n"; ifconfig -a | egrep "inet |inet6 " | awk '{print $2}' | egrep -v "^127\.0\.0\.1|^fe80:|^::1" | cut -f 1 -d "/" ) | while read localhostname
		do
			# we know something connected in to this username and hostname
			#printf "*@${remoteauthdhostname};${localauthdusername}@${localhostname}\n"
			printf "*@${remoteauthdhostname};*@${localhostname}\n"
			if [ -f "${HOMEDIRECTORYNAME}/${localauthdusername}/.ssh/known_hosts" ]
			then
				if [ -n "$(grep "${remoteauthdhostname}" "${HOMEDIRECTORYNAME}/${localauthdusername}/.ssh/known_hosts" 2>/dev/null)" ]
				then
					# it looks like this username and hostname also connected to the remote host
					#printf "${localauthdusername}@${localhostname};*@${remoteauthdhostname}\n"
					printf "*@${localhostname};*@${remoteauthdhostname}\n"
				fi
			fi
			if [ -f "${HOMEDIRECTORYNAME}/${localauthdusername}/.ssh/authorized_keys" ]
			then
				if [ -n "$(grep "@${remoteauthdhostname}" "${HOMEDIRECTORYNAME}/${localauthdusername}/.ssh/authorized_keys" 2>/dev/null)" ]
				then
					# the remote host is in the authorized keys for this username and hostname
					printf "*@${remoteauthdhostname};${localauthdusername}@${localhostname}\n"
					printf "*@${remoteauthdhostname};*@${localhostname}\n"
				fi
				cat "${HOMEDIRECTORYNAME}/${localauthdusername}/.ssh/authorized_keys" | awk '{print $3}' | tr "@" " " | while read remotekeydusername remotekeydhostname
				do
					# there is a username and hostname in this username's authorized keys
					#printf "${remotekeydusername}@${remotekeydhostname};${localauthdusername}@${localhostname}}\n"
					printf "*@${remotekeydhostname};*@${localhostname}}\n"
					if [ -f "${HOMEDIRECTORYNAME}/${localauthdusername}/.ssh/known_hosts" ]
					then
						cat "${HOMEDIRECTORYNAME}/${localauthdusername}/.ssh/known_hosts" | grep "${remotekeydhostname}" | tr -d "[]" | tr "," "\n" | cut -f 1 -d ":" | grep -v "=" | while read remoteknownkeydhostname _
						do
							# this username has connected to a hostname that is found in the authorized keys
							#printf "${localauthdusername}@${localhostname};${remotekeydusername}?@${remoteknownkeydhostname}\n"
							printf "*@${localhostname};*@${remoteknownkeydhostname}\n"
						done
					fi
				done
			fi
		done
	done
	if [ -f "${HOMEDIRECTORYNAME}/${localusername}/.ssh/known_hosts" ]
	then
		cat "${HOMEDIRECTORYNAME}/${localusername}/.ssh/known_hosts" | tr -d "[]" | tr "," "\n" | cut -f 1 -d ":" | grep -v "=" | while read remoteknownhostname _
		do
			( printf "$(hostname)\n"; ifconfig -a | egrep "inet |inet6 " | awk '{print $2}' | egrep -v "^127\.0\.0\.1|^fe80:|^::1" | cut -f 1 -d "/" ) | while read localhostname
			do
				# this username has connected to a hostname
				#printf "${localusername}@${localhostname};*@${remoteknownhostname}\n"
				printf "*@${localhostname};*@${remoteknownhostname}\n"
			done
		done
	fi
	if [ -f "${HOMEDIRECTORYNAME}/${localusername}/.ssh/authorized_keys" ]
	then
		cat "${HOMEDIRECTORYNAME}/${localusername}/.ssh/authorized_keys" | awk '{print $3}' | tr "@" " " | while read remotekeydusername remotekeydhostname
		do
			( printf "$(hostname)\n"; ifconfig -a | egrep "inet |inet6 " | awk '{print $2}' | egrep -v "^127\.0\.0\.1|^fe80:|^::1" | cut -f 1 -d "/" ) | while read localhostname
			do
				# there is a username and hostname in this username's authorized keys
				#printf "${remotekeydusername}@${remotekeydhostname};${localusername}@${localhostname}}\n"
				printf "*@${remotekeydhostname};*@${localhostname}}\n"
				if [ -f "${HOMEDIRECTORYNAME}/${localusername}/.ssh/known_hosts" ]
				then
					cat "${HOMEDIRECTORYNAME}/${localusername}/.ssh/known_hosts" | grep "${remotekeydhostname}" | tr -d "[]" | tr "," "\n" | cut -f 1 -d ":" | grep -v "=" | while read remoteknownkeydhostname _
					do
						# this username has connected to a hostname that is found in the authorized keys
						#printf "${localusername}@${localhostname};*@${remoteknownkeydhostname}\n"
						printf "*@${localhostname};*@${remoteknownkeydhostname}\n"
					done
				fi
			done
		done
	fi
done
last | grep "@" | awk '{print $1 " " $3}' | sort | uniq | egrep "\.(.*)\." | while read localauthdusername remoteauthdhostname
do
	( printf "$(hostname --fqdn)\n"; ifconfig -a | egrep "inet |inet6 " | awk '{print $2}' | egrep -v "^127\.0\.0\.1|^fe80:|^::1" | cut -f 1 -d "/" ) | while read localhostname
	do
		# we know something connected in to this username and hostname
		#printf "*@${remoteauthdhostname};${localauthdusername}@${localhostname}\n"
		printf "*@${remoteauthdhostname};*@${localhostname}\n"
		if [ -f "${HOMEDIRECTORYNAME}/${localauthdusername}/.ssh/known_hosts" ]
		then
			if [ -n "$(grep "${remoteauthdhostname}" "${HOMEDIRECTORYNAME}/${localauthdusername}/.ssh/known_hosts" 2>/dev/null)" ]
			then
				# it looks like this username and hostname also connected to the remote host
				#printf "${localauthdusername}@${localhostname};*@${remoteauthdhostname}\n"
				printf "*${localhostname};*@${remoteauthdhostname}\n"
			fi
		fi
		if [ -f "${HOMEDIRECTORYNAME}/${localauthdusername}/.ssh/authorized_keys" ]
		then
			if [ -n "$(grep "@${remoteauthdhostname}" "${HOMEDIRECTORYNAME}/${localauthdusername}/.ssh/authorized_keys" 2>/dev/null)" ]
			then
				# the remote host is in the authorized keys for this username and hostname
				#printf "*@${remoteauthdhostname};${localauthdusername}@${localhostname}\n"
				printf "*@${remoteauthdhostname};*@${localhostname}\n"
			fi
			cat "${HOMEDIRECTORYNAME}/${localauthdusername}/.ssh/authorized_keys" | awk '{print $3}' | tr "@" " " | while read remotekeydusername remotekeydhostname
			do
				# there is a username and hostname in this username's authorized keys
				#printf "${remotekeydusername}@${remotekeydhostname};${localauthdusername}@${localhostname}}\n"
				printf "*@${remotekeydhostname};*@${localhostname}}\n"
				if [ -f "${HOMEDIRECTORYNAME}/${localauthdusername}/.ssh/known_hosts" ]
				then
					cat "${HOMEDIRECTORYNAME}/${localauthdusername}/.ssh/known_hosts" | grep "${remotekeydhostname}" | tr -d "[]" | tr "," "\n" | cut -f 1 -d ":" | grep -v "=" | while read remoteknownkeydhostname _
					do
						# this username has connected to a hostname that is found in the authorized keys
						#printf "${localauthdusername}@${localhostname};${remotekeydusername}?@${remoteknownkeydhostname}\n"
						printf "*@${localhostname};*@${remoteknownkeydhostname}\n"
					done
				fi
			done
		fi
	done
done
