#!/bin/bash

set -e

TARGET_IP="10.42.0.223"
SSH_PORT=22
REBOOT_COMMAND=reboot
CHECK_UPDATE_FUNCTION=check_cmdline_and_bc

UB_FILENAME="update-bundle-all-raspberrypi4-64.raucb"
UB_PATH="tmp/deploy/images/raspberrypi4-64/$UB_FILENAME"

SCP="scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -P $SSH_PORT"
SSH="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $SSH_PORT"

function do_scp {
    $SCP $1  "root@$TARGET_IP:"$2
}

function target_exec {
    $SSH "root@$TARGET_IP" "$@"
}

function do_reboot {
    echo "Rebooting..."
    target_exec $REBOOT_COMMAND
    sleep 60

    echo "Trying to reestablish a connection..."
    while ! target_exec echo "Connection reestablished." ; do
        echo "Trying to reestablish a connection..."
        sleep 5
    done
}

function do_get_copy {
    echo "Getting a copy from backup..."
    target_exec cp $UB_FILENAME.bak $UB_FILENAME
}

function do_rauc_status {
    target_exec rauc status |& awk '{ gsub(/\033\[[0-9;]*[A-Za-z]/,""); print }' |& grep -v -e "^Warning: Permanently added"
}

function check_rauc_slot_status {
    name=$1
    booted_or_inactive=$2
    status=$3

    if ! do_rauc_status | grep -B 1 -e "bootname: $name" | grep -e "$booted_or_inactive" &> /dev/null ; then
        echo "TEST FAILED (expected: $name slot is $booted_or_inactive)"
        return 1
    fi

    if ! do_rauc_status | grep -A 2 -e "bootname: $name" | grep -e "boot status: $status" &> /dev/null ; then
        echo "TEST FAILED (expected: $name slot is $status)"
        return 1
    fi

    return 0
}

function check_rauc_slot_activated {
    name=$1

    if ! do_rauc_status | grep -e "^Activated:.*($name)" &> /dev/null ; then
        echo "TEST FAILED (expected: $name slot is activated)"
        return 1
    fi

    return 0
}

function check_bc {
    if [[ "$1" == "true" ]] ; then
        if ! target_exec bc <<< "0+1" ; then
            echo "TEST FAILED (expected: bc command found)"
            return 1
        fi
    else
        if target_exec bc <<< "0+1" ; then
            echo "TEST FAILED (expected: bc command not found)"
            return 1
        fi
    fi

    return 0
}

function check_cmdline {
    if [[ "$1" == "true" ]] ; then
        if ! target_exec cat /proc/cmdline | grep -e "mynewoption=1" ; then
            echo "TEST FAILED (expected: mynewoption=1 in cmdline)"
            return 1
        fi
    else
        if target_exec cat /proc/cmdline | grep -e "mynewoption=1" ; then
            echo "TEST FAILED (expected: mynewoption=1 not in cmdline)"
            return 1
        fi
    fi

    return 0
}

function check_cmdline_and_bc {
    check_cmdline $1 && check_bc $1
}

function test_bundle_is_corrupted_or_incorrectly_signed {
    echo "TEST: bundle is corrupted / incorrectly signed"

    do_get_copy

    # verify (expected: ok)
    if ! target_exec rauc info $UB_FILENAME ; then
        echo "TEST FAILED (expected: ok)"
        return 1
    fi

    # corrupt
    printf '\xFF' | target_exec dd of=$UB_FILENAME bs=1 count=1 seek=42

    # verify (expected: not ok)
    if target_exec rauc info $UB_FILENAME ; then
        echo "TEST FAILED (expected: not ok)"
        return 1
    fi

    echo "TEST PASSED"
    return 0
}

function test_power_loss_during_update {
    echo "TEST: power loss during update"

    # precondition
    check_rauc_slot_status "A" "booted"   "good" || return 1
    check_rauc_slot_status "B" "inactive" "good" || return 1

    do_get_copy

    # request install but kill it before it ends (simulates a power loss or similar)
    echo "Installing..."
    target_exec "rauc install $UB_FILENAME" | tee >(
        grep -q -m 1 "51% Copying image to"
        target_exec systemctl kill --kill-who=all --signal=SIGKILL rauc # killing "rauc install" is not enough.
    )
    echo "rauc killed before it was able to finish install (simulates a power loss or similar)."

    # restart rauc service
    echo "Restarting rauc..."
    target_exec systemctl start rauc

    # verify
    check_rauc_slot_status "A" "booted"   "good" || return 1
    check_rauc_slot_status "B" "inactive" "bad"  || return 1

    # reboot
    do_reboot

    # verify again
    check_rauc_slot_status "A" "booted"   "good" || return 1
    check_rauc_slot_status "B" "inactive" "bad"  || return 1

    echo "TEST PASSED"
    return 0
}

function test_does_not_boot {
    echo "TEST: does not boot"

    # precondition
    check_rauc_slot_activated "A"              || return 1
    check_rauc_slot_status "A" "booted" "good" || return 1
    # slot B is not checked because it is probably bad from previous tests
    $CHECK_UPDATE_FUNCTION false || return 1

    do_get_copy

    # rauc install
    if ! target_exec "rauc install $UB_FILENAME" ; then
        echo "TEST FAILED (rauc install failed)"
        return 1
    fi

    # verify
    check_rauc_slot_activated "B"                || return 1
    check_rauc_slot_status "A" "booted"   "good" || return 1
    check_rauc_slot_status "B" "inactive" "good" || return 1
    $CHECK_UPDATE_FUNCTION false                               || return 1

    # Now, we are going to reboot and we should end up with slot B (where bc is
    # available). However, we are not going to mark it as good to simulate some kind
    # of problem with the update. After rebooting three times, without marking slot
    # B as good, we should return back to slot A.

    # reboot into slot B and verify
    do_reboot
    check_rauc_slot_activated "B"                || return 1
    check_rauc_slot_status "A" "inactive" "good" || return 1
    check_rauc_slot_status "B" "booted" "good"   || return 1
    # bc must be found now
    $CHECK_UPDATE_FUNCTION true                                || return 1

    # disable rauc-mark-good service (from now on, all boots will not be marked as good)
    target_exec systemctl disable rauc-mark-good.service

    # reboot and verify
    do_reboot
    # at this stage we should be on slot B which has not been marked as good (1st time)
    check_rauc_slot_activated "B"                || return 1
    check_rauc_slot_status "A" "inactive" "good" || return 1
    check_rauc_slot_status "B" "booted" "good"   || return 1
    $CHECK_UPDATE_FUNCTION true                                || return 1

    # reboot and verify
    do_reboot
    # at this stage we should be on slot B which has not been marked as good (2nd time)
    check_rauc_slot_activated "B"                || return 1
    check_rauc_slot_status "A" "inactive" "good" || return 1
    check_rauc_slot_status "B" "booted" "good"   || return 1
    $CHECK_UPDATE_FUNCTION true                                || return 1

    # reboot and verify
    do_reboot
    # at this stage we should be on slot B which has not been marked as good (3rd and last time)
    check_rauc_slot_activated "A"                || return 1
    check_rauc_slot_status "A" "inactive" "good" || return 1
    check_rauc_slot_status "B" "booted" "bad"    || return 1
    $CHECK_UPDATE_FUNCTION true                                || return 1

    # reboot and verify
    do_reboot
    # at this stage we should be back on slot A
    check_rauc_slot_activated "A"               || return 1
    check_rauc_slot_status "A" "booted" "good"  || return 1
    check_rauc_slot_status "B" "inactive" "bad" || return 1
    # bc must not be found now
    $CHECK_UPDATE_FUNCTION false                              || return 1

    echo "TEST PASSED"
    return 0
}

#
# main
#

echo "Copying update bundle to the target..."
do_scp "$UB_PATH"
echo "Backing up..."
target_exec cp "$UB_FILENAME" "$UB_FILENAME.bak"

test_bundle_is_corrupted_or_incorrectly_signed || exit 1
test_power_loss_during_update || exit 1
test_does_not_boot || exit 1
exit 0