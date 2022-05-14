#!/system/bin/sh

load()
{
    is_fastboot_twrp=$(getprop ro.boot.fastboot)
    if [ ! -z "$is_fastboot_twrp" ]; then
        for mod in /vendor/lib/modules/*.ko; do
		insmod $mod
	done
    else
        mkdir /v
        suffix=$(getprop ro.boot.slot_suffix)
        if [ -z "$suffix" ]; then
            suf=$(getprop ro.boot.slot)
            suffix="_$suf"
        fi
        venpath="/dev/block/mapper/vendor$suffix"
        mount -t ext4 -o ro "$venpath" /v
        rm -rf /vendor/lib/modules
	mkdir -p /vendor/lib/modules
        cp /v/lib/modules/aw8695.ko /vendor/lib/modules
	cp /v/lib/modules/focaltech_0flash_mmi.ko /vendor/lib/modules
	cp /v/lib/modules/himax_v2_mmi_hx83112.ko /vendor/lib/modules
	cp /v/lib/modules/himax_v2_mmi.ko /vendor/lib/modules
	cp /v/lib/modules/nova_0flash_mmi.ko /vendor/lib/modules
	cp /v/lib/modules/qpnp-smbcharger-mmi.ko /vendor/lib/modules
        insmod /vendor/lib/modules/aw8695.ko
        insmod /vendor/lib/modules/focaltech_0flash_mmi.ko
        insmod /vendor/lib/modules/himax_v2_mmi_hx83112.ko
        insmod /vendor/lib/modules/himax_v2_mmi.ko
        insmod /vendor/lib/modules/nova_0flash_mmi.ko
        insmod /vendor/lib/modules/qpnp-smbcharger-mmi.ko
        umount /v
        rmdir /v
    fi
}

load
wait 1

setprop modules.loaded 1

exit 0
