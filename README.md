# ...

## Docker GUI

Install xquartz (`brew cask install xquartz`) and socat `brew install socat`.

Run `open -a Xquartz`.
Once opened, click Preferences -> Security and allow network connections.

Then `socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`.

Then test with `docker run -e DISPLAY=192.168.2.104:0 gns3/xeyes`.
If it works, you see a window with two rolling eyes.
