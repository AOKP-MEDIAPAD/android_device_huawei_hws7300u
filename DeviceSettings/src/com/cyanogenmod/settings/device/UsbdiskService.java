package com.cyanogenmod.settings.device;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

import java.io.File;
import java.util.Timer;
import java.util.TimerTask;
import android.os.Handler;
import android.util.Log;

/**
 * Created by zyr3x on 09.01.14.
 */
public class UsbdiskService extends Service {


    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startid) {
        (new Timer()).scheduleAtFixedRate(new TimerTask() {
            final CMDProcessor cmd = new CMDProcessor();
            final Handler handler = new Handler();
            final File usbdrive = new File("/dev/bus/usb/001/");

            EasyPair<String, String> easyPair;
            CMDProcessor.CommandResult result;

            Boolean status = false;
            String usbName = null;

            @Override
            public void run() {
                handler.post(new Runnable() {

                    public String getUsbName()
                    {
                        result =  cmd.sh.runWaitFor("ls /dev/block/sd*");
                        easyPair = result.getOutput();
                        return easyPair.first;
                    }

                    public void run() {

                        if(  usbdrive.listFiles() != null)
                        {
                            usbName = getUsbName();

                            if( usbdrive.listFiles().length > 0 && status == false)
                            {
                                if(usbName != null )
                                {
                                    Log.d("UsbdiskService", "Usbdrive mount : " + usbName);

                                    cmd.su.runWaitFor("mount -t vfat -o rw,nosuid,nodev,umask=0,dmask=0,fmask=0 "+usbName+" /storage/usbdisk " +
                                            " && mount -t ext4 -o rw,nosuid,nodev,umask=0,dmask=0,fmask=0 "+usbName+" /storage/" +
                                            " && mount -t ext3 -o rw,nosuid,nodev,umask=0,dmask=0,fmask=0 "+usbName+" /storage/" +
                                            " && mount -t ext2 -o rw,nosuid,nodev,umask=0,dmask=0,fmask=0 "+usbName+" /storage/" +
                                            " && mount -t exfat -o rw,nosuid,nodev,umask=0,dmask=0,fmask=0 "+usbName+" /storage/" +
                                            " && mount -t ntfs -o rw,nosuid,nodev,umask=0,dmask=0,fmask=0 "+usbName+" /storage/");

                                    status = true;
                                }

                            }
                            else
                            {
                                if(status == true && usbName == null)
                                {
                                    status = false;
                                    cmd.su.runWaitFor("umount /storage/usbdisk");
                                    Log.d("UsbdiskService", "Usbdrive umount /storage/usbdisk");
                                }

                            }
                        }


                    }
                });
            }
        }, 1000, 1000 * 5);
        return START_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }



}
