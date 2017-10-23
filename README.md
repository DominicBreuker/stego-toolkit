# Stego Toolkit

## Tools

### Installed applications

|Tool          |File types                |Description       |How to hide    | How to recover |
|--------------|--------------------------|------------------|---------------|----------------|
| [AudioStego](https://github.com/danielcardeenas/AudioStego) | Audio (MP3 / WAV) | Details on how it works are in this [blog post](https://danielcardeenas.github.io/audiostego.html) | `hideme cover.mp3 secret.txt && mv ./output.mp3 stego.mp3` | `hideme stego.mp3 -f && cat output.txt` |
| [jphide](http://linux01.gwdg.de/~alatham/stego.html) | Image (JPG) | Pretty old tool from [here](http://linux01.gwdg.de/~alatham/stego.html). Here, the version from [here](https://github.com/mmayfield1/SSAK) is installed since the original one crashed all the time. It prompts for a passphrase interactively! | `jphide cover.jpg stego.jpg secret.txt` | `jpseek stego.jpg output.txt` |
| [jsteg](https://github.com/lukechampine/jsteg) | Image (JPG) | LSB stego tool. Does not encrypt the message. | `jsteg hide cover.jpg secret.txt stego.jpg` | `jsteg reveal cover.jpg output.txt` |
| [mp3stego](http://www.petitcolas.net/steganography/mp3stego/) | Audio (MP3) | Old program. Encrypts and then hides a message (3DES encryption!). Windows tool running in Wine. Requires WAV input (may throw errors for certain WAV files. what works is e.g.,: `ffmpeg -i audio.mp3 -flags bitexact audio.wav`). Important: use absolute path only! | `mp3stego-encode -E secret.txt -P password /path/to/cover.wav /path/to/stego.mp3` | `mp3stego-decode -X -P password /path/to/stego.mp3 /path/to/out.pcm /path/to/out.txt`


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
Demo sound file: https://upload.wikimedia.org/wikipedia/commons/c/c5/Auphonic-wikimedia-test-stereo.ogg --- By debuglevel (Own work) [CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons
