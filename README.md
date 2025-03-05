# EXE
EXE (ETIB XR Engine)

## Dockerfile

For building the image, run the following command:

```bash
docker build -t exe .
```

To run the container:

```bash
docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb exe bash
```

Inside the container, use the makefile to build the project and after that,
check if you can see the device with the following command:

```bash
adb devices
```

if you didn't see the device, you need to kill the adb server on the host machine

```bash
# on the host machine
adb kill-server
```

and then restart the adb server inside the container

```bash
# inside the container
adb start-server
```

And now you should see the device.
Then you can upload the apk on the headset with the following command:

```bash
```

And finally, you can run the application with the following command:

```bash
adb shell am start -n com.example.questxrexample/com.example.questxrexample.MainActivity
```
