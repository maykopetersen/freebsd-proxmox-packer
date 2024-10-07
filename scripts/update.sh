#!/bin/sh
echo
echo "####### Installing Updates #######"
env PAGER=cat freebsd-update --not-running-from-cron fetch install
env ASSUME_ALWAYS_YES=YES pkg bootstrap -f | cat
pkg update -q
pkg upgrade -y