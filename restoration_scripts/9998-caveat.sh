#!/usr/bin/env bash

echo "Caveats"
echo "======="
echo
echo " · Enable use of TouchId when use root"
echo "       sudo vi /etc/pam.d/sudo"
echo
echo "     Add this line:"
echo "       auth       sufficient     pam_tid.so"
echo
echo "     Change the line (line 2, normally):"
echo "       auth       include        sudo_local"
echo
echo "     To (commented):"
echo "       #auth       include        sudo_local"
echo
echo "     Restart the shell and try with:"
echo "       sudo -v"
echo
