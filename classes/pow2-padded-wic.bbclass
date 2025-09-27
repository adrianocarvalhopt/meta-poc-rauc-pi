# Ensures that .wic images are padded up to the next power of 2 bytes.

IMAGE_POSTPROCESS_COMMAND += "pad_wic; "

python pad_wic() {
    import os, subprocess
    wic_file = os.path.join(d.getVar("IMGDEPLOYDIR"), d.getVar("IMAGE_NAME") + ".wic")
    if not os.path.exists(wic_file):
        return

    size = os.stat(wic_file).st_size

    # Compute next power of 2
    if size & (size - 1) == 0:
        padded = size
    else:
        n = size
        n -= 1
        n |= n >> 1
        n |= n >> 2
        n |= n >> 4
        n |= n >> 8
        n |= n >> 16
        n |= n >> 32
        padded = n + 1

    if size != padded:
        bb.note(f"Padding {wic_file} from {size} to {padded} bytes (next power of 2)")
        subprocess.check_call(["truncate", "-s", str(padded), wic_file])
    else:
        bb.note(f"The size of {wic_file} is already a power of 2 ({size} bytes)")
}
