# reconnect-usb-linux
This CLI resets USB device that may be misbehaving without the need to replug the device.

A bash script is used to display a list of the currently attached USB devices and manages the users input choice. The selection is then passed off to a C program to open the device file descriptor and reset it using [ioctl(2)](https://linux.die.net/man/2/ioctl) and the `USBDEVFS_RESET (_IO('U', 20)`  request defined in [linux/usbdevice_fs.h](https://github.com/torvalds/linux/blob/master/include/uapi/linux/usbdevice_fs.h).

## Usage
The C program must first be compiled beforehand. For compatibility with the bash script, make certain the binary is named `ioctl-reset`.
```
gcc ioctl-reset.c -o ioctl-reset
```
Finally, run the shell script. The script will automatically elevate to required privileges for the C program using `sudo` to write to the device file.
```
./reconnect-usb.sh
```
## systemd service
I wrote this utility to fix an issue I was experiencing where my external USB speakers would not produce any sound until they were physically reconnected to my computer. This issue arose on Fedora 34, likely as a result of the new audio backend pre-installed, [PipeWire](https://pipewire.org/). This commonly occurred after resuming the computer from suspend, so I created a systemd service to execute after waking up the computer, made possible with `After=suspend.target`.

```
sudo cp ioctl-reset /usr/local/bin/
sudo cp audio-fix.service /etc/systemd/system/
sudo systemctl enable audio-fix.service
```

And you should be good to go!
