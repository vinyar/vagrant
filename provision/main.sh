#!/bin/bash

# Define various init scripts that need to be run.
# You can change the order in which these are run, as needed.
SCRIPTS=()
SCRIPTS+=('Init')
SCRIPTS+=('Timezone')
SCRIPTS+=('Hosts_File')
SCRIPTS+=('Git')
SCRIPTS+=('Ruby')
SCRIPTS+=('Rinetd')
SCRIPTS+=('Java')
SCRIPTS+=('MongoDB')
SCRIPTS+=('Node')

# Unless you need to modify core initialization steps, you don't need
# to proceed past this point.

INITIAL_BOOT=1;
if [ -a "/home/vagrant/initial_boot" ]; then
    INITIAL_BOOT=0;
fi

script_path=/vagrant/provision
rightscript_path=$script_path/scripts/
rightscript_log=$script_path/provision.log
truncate -s0 $rightscript_log

touch $rightscript_log
chmod 777 $rightscript_log

# Run scripts
if [ $INITIAL_BOOT -eq 1 ]; then
    echo "Running provision scripts..."
    k=0
    for i in "${SCRIPTS[@]}"
    do
        echo "[$k] $i"
        $rightscript_path/$i 2&>1 >> $rightscript_log
        if [ $? -ne 0 ]; then
            echo "[!] Instance stranded\n"
            echo "[i] see $rightscript_log for details"
            exit 2
        fi
        k=$((k+1))
    done
fi

if [ $INITIAL_BOOT -eq 1 ]; then
    touch /home/vagrant/initial_boot
fi

echo "[i] Reticulating splines"
echo "[i] Instance operational"

exit 0
