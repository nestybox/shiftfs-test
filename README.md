# shiftfs-test

Small program used by sysbox-mgr to verify that shiftfs-on-overlayfs works.
This program is meant to be executed inside sysbox container whose rootfs
has a shiftfs-on-overlayfs mount.

The program simply creates a file and renames it. If the rename operation fails,
then shiftfs-on-overlayfs does not work.
