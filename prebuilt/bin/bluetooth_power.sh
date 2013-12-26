while true;
do
	WAKELOCK=`getprop persist.bt.wakelock`;
	if [ $WAKELOCK == "0" ];
	then
		echo 0 > /sys/class/rfkill/rfkill0/state
		echo 1 > /sys/class/rfkill/rfkill0/state
		BTPATCH=`/system/bin/brcm_patchram_plus --enable_hci /dev/ttyHS0 2>&1`;
		BTSTATUS=`echo $BTPATCH | grep zero-length | wc -l`;
		
		if [ $BTSTATUS == "1" ]; 
		then
			exit;
		fi;

	fi;
	sleep 5;
done