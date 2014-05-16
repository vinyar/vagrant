#!/usr/bin/env bash
# Unless you have good reason to, you shouldn't need to modify this file.

INITIAL_BOOT=1;
if [ -a "/home/vagrant/initial_boot" ]
then
    INITIAL_BOOT=0;
fi

vagrant_path=/vagrant
script_path=$vagrant_path/scripts/
script_log=$vagrant_path/logs/provision.log
truncate -s0 $script_log

touch $script_log
chmod 777 $script_log

trim() {
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

# Run scripts
if [ $INITIAL_BOOT -eq 1 ]
then
    echo "Running provision scripts..."
    for var in "$@"
    do
        echo "[i] $var"
        $script_path/$var 2&>1 >> $script_log
        if [ $? -ne 0 ]
        then
            echo "[!] Instance stranded\n"
            echo "[i] see $script_log for details"
            exit 2
        fi
    done
fi

if [ $INITIAL_BOOT -eq 1 ]
then
    touch /home/vagrant/initial_boot
fi

echo "[i] Reticulating splines"
echo "[i] Instance operational"

exit 0
