# Stego Toolkit

## Tools

### Installed applications

|Tool          |File types                |Description       |How to hide    | How to recover |
|--------------|--------------------------|------------------|---------------|----------------|
|[AudioStego](https://github.com/danielcardeenas/AudioStego)|Audio (MP3 / WAV)| Details on how it works are in this [blog post](https://danielcardeenas.github.io/audiostego.html) | `hideme cover.mp3 secret.txt && mv ./output.mp3 stego.mp3` | `hideme stego.mp3 -f && cat output.txt` |


Basic checks can be done with the check scripts:
- check_jpg.sh: Screen a jpg image, e.g., `check_jpg.sh IMAGE.jpg`
- brute_jpg.sh: Brute force stego in a jpg image, e.g., `brute_jpg.sh IMAGE.jpg WORDLIST.txt`

## Docker GUI

Install xquartz (`brew cask install xquartz`) and socat `brew install socat`.

Run `socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`.
Then run `open -a Xquartz`.
Once opened, click Preferences -> Security and allow network connections.

Then test with `docker run -e DISPLAY=192.168.2.104:0 gns3/xeyes`.
If it works, you see a window with two rolling eyes.


## Codes

Be able to spot codes. Check out this cheat sheet:
- http://www.ericharshbarger.org/epp/code_sheet.pdf


## References

Demo image: https://pixabay.com/p-1685092
Demo sound file: https://upload.wikimedia.org/wikipedia/commons/9/97/De-Ich_bin_ein_Berliner2.ogg --- By John Fitzgerald Kennedy [Public domain], via Wikimedia Commons
