// ioctl-reset.c
// Opens a USB file descriptor and resets
// the device with USBDEVFS_RESET.
// Tommy Janna, 2021

#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <linux/usbdevice_fs.h>

int main(int argc, char* argv[]) {
    int device;

    if (argc != 2) {
        fprintf(stderr, "%s: expecting 1 argument\n", __FILE__);
        return EXIT_FAILURE;
    }

    if ((device = open(argv[1], O_RDWR)) < 0) {
        fprintf(stderr, "%s: %s\n", __FILE__, strerror(errno));
        return EXIT_FAILURE;
    }

    if (ioctl(device, USBDEVFS_RESET, 0) < 0) {
        fprintf(stderr, "%s: %s\n", __FILE__, strerror(errno));
    }

    close(device);
    return 0;
}
