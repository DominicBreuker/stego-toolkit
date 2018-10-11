# Steganography Toolkit

This project is a Docker image useful for solving Steganography challenges as those you can find at CTF platforms like [hackthebox.eu](https://www.hackthebox.eu/).
The image comes pre-installed with many popular tools (see list [below](#tools)) and several screening scripts you can use check simple things (for instance, run `check_jpg.sh image.jpg` to get a report for a JPG file).

[![Docker build status](https://img.shields.io/docker/build/mariobehling/loklak.svg)](https://hub.docker.com/r/dominicbreuker/stego-toolkit/)

[![Hack The Box](https://www.hackthebox.eu/badge/image/6255)](https://www.hackthebox.eu/profile/6255)

## Usage

First make sure you have Docker installed ([how to](https://docs.docker.com/engine/installation/)).
Then you can use the shell scripts `bin/buid.sh` and `bin/run.sh` in this repo to build the image and run the container.
You will be dropped into a bash shell inside the container.
It will have the `data` folder mounted, into which you can put the files to analyze.

If you don't use the scripts, follow these steps:
1. Build image (`docker build -t <image_name> .`) or pull from Docker hub (`docker pull dominicbreuker/stego-toolkit`)
2. Start a container with your files mounted to the folder `/data` (`docker run -it <image_name> -v /local/folder/with/data:/data /bin/bash`)
3. Use CLI tools and screening scripts on your files: e.g., run `check_jpg.sh image.jpg` to create a quick report, or run `brute_jpg.sh image.jpg wordlist.txt` to try extracting hidden data with various tools and passwords
4. If you want to run GUI tools use one of these two ways:
  - Run `start_ssh.sh` and connect to your container with X11 forwarding
  - Run `start_vnc.sh` and connect to the container's Desktop through your browser

Check out the following sections for more information:
- What tools are installed? Go [here](#tools)
- What scripts can I run to quickly screen files automatically or brute force them? Go [here](#screening-scripts)
- How can I play with different Steganography examples to see if I can break them? Go [here](#steganography-examples)
- How can I run GUI tools inside the container? go [here](#gui-and-containers)

## Demo

Start with `docker run -it --rm -v $(pwd)/data:/data dominicbreuker/stego-toolkit /bin/bash`.
You will be dropped into a container shell in work dir `/data`.
Your host folder `$(pwd)/data` will be mounted and the images inside will be accessible.

![animated demo gif](https://i.imgur.com/UW8CKFV.gif)

## Tools

Many different Linux and Windows tools are installed.
Windows tools are supported with [Wine](https://www.winehq.org/).
Some tools can be used on the command line while others require GUI support!

### Command line interface tools

These tools can be used on the command line.
All you have to do is start a container and mount the steganography files you want to check.

#### General screening tools

Tools to run in the beginning.
Allow you to get a broad idea of what you are dealing with.

|Tool          |Description       |How to use     |
|--------------|------------------|---------------|
| file         | Check out what kind of file you have | `file stego.jpg` |
| exiftool     | Check out metadata of media files | `exiftool stego.jpg` |
| binwalk      | Check out if other files are embedded/appended | `binwalk stego.jpg`
| strings      | Check out if there are interesting readable characters in the file | `strings stego.jpg`
| foremost     | Carve out embedded/appended files | `foremost stego.jpg`
| pngcheck     | Get details on a PNG file (or find out is is actually something else) | `pngcheck stego.png`
| identify     | [GraphicMagick](http://www.graphicsmagick.org/) tool to check what kind of image a file is. Checks also if image is corrupted. | `identify -verbose stego.jpg`
| ffmpeg       | ffmpeg can be used to check integrity of audio files and let it report infos and errors | `ffmpeg -v info -i stego.mp3 -f null -` to recode the file and throw away the result


#### Tools detecting steganography

Tools designed to detect steganography in files.
Mostly perform statistical tests.
They will reveal hidden messages only in simple cases.
However, they may provide hints what to look for if they find interesting irregularities.

|Tool          |File types                |Description       |How to use     |
|--------------|--------------------------|------------------|---------------|
| [stegoVeritas](https://github.com/bannsec/stegoVeritas) | Images (JPG, PNG, GIF, TIFF, BMP) | A wide variety of simple and advanced checks. Check out `stegoveritas.py -h`. Checks metadata, creates many transformed images and saves them to a directory, Brute forces LSB, ... | `stegoveritas.py stego.jpg` to run all checks |
| [zsteg](https://github.com/zed-0xff/zsteg) | Images (PNG, BMP) | Detects various LSB stego, also openstego and the [Camouflage tool](http://camouflage.unfiction.com/) | `zsteg -a stego.jpg` to run all checks |
| [stegdetect](http://old-releases.ubuntu.com/ubuntu/pool/universe/s/stegdetect) | Images (JPG) | Performs statistical tests to find if a stego tool was used (jsteg, outguess, jphide, ...). Check out `man stegdetect` for details. | `stegdetect stego.jpg` |
| [stegbreak](https://linux.die.net/man/1/stegbreak) | Images (JPG) | Brute force cracker for JPG images. Claims it can crack `outguess`, `jphide` and `jsteg`. | `stegbreak -t o -f wordlist.txt stego.jpg`, use `-t o` for outguess, `-t p` for jphide or `-t j` for jsteg |


#### Tools actually doing steganography

Tools you can use to hide messages and reveal them afterwards.
Some encrypt the messages before hiding them.
If they do, they require a password.
If you have a hint what kind of tool was used or what password might be right, try these tools.
Some tools are supported by the brute force scripts available in this Docker image.

|Tool          |File types                |Description       |How to hide    | How to recover |
|--------------|--------------------------|------------------|---------------|----------------|
| [AudioStego](https://github.com/danielcardeenas/AudioStego) | Audio (MP3 / WAV) | Details on how it works are in this [blog post](https://danielcardeenas.github.io/audiostego.html) | `hideme cover.mp3 secret.txt && mv ./output.mp3 stego.mp3` | `hideme stego.mp3 -f && cat output.txt` |
| [jphide/jpseek](http://linux01.gwdg.de/~alatham/stego.html) | Image (JPG) | Pretty old tool from [here](http://linux01.gwdg.de/~alatham/stego.html). Here, the version from [here](https://github.com/mmayfield1/SSAK) is installed since the original one crashed all the time. It prompts for a passphrase interactively! | `jphide cover.jpg stego.jpg secret.txt` | `jpseek stego.jpg output.txt` |
| [jsteg](https://github.com/lukechampine/jsteg) | Image (JPG) | LSB stego tool. Does not encrypt the message. | `jsteg hide cover.jpg secret.txt stego.jpg` | `jsteg reveal cover.jpg output.txt` |
| [mp3stego](http://www.petitcolas.net/steganography/mp3stego/) | Audio (MP3) | Old program. Encrypts and then hides a message (3DES encryption!). Windows tool running in Wine. Requires WAV input (may throw errors for certain WAV files. what works for me is e.g.: `ffmpeg -i audio.mp3 -flags bitexact audio.wav`). Important: use absolute path only! | `mp3stego-encode -E secret.txt -P password /path/to/cover.wav /path/to/stego.mp3` | `mp3stego-decode -X -P password /path/to/stego.mp3 /path/to/out.pcm /path/to/out.txt`
| [openstego](https://github.com/syvaidya/openstego) | Images (PNG) | Various LSB stego algorithms (check out this [blog](http://syvaidya.blogspot.de/)). Still maintained. | `openstego embed -mf secret.txt -cf cover.png -p password -sf stego.png` | `openstego extract -sf openstego.png -p abcd -xf output.txt ` (leave out -xf to create file with original name!) |
| [outguess](https://packages.debian.org/sid/utils/outguess) | Images (JPG) | Uses "redundant bits" to hide data. Comes in two versions: old=`outguess-0.13` taken from [here](https://github.com/mmayfield1/SSAK) and new=`outguess` from the package repos. To recover, you must use the one used for hiding. | `outguess -k password -d secret.txt cover.jpg stego.jpg` | `outguess  -r -k password stego.jpg output.txt` |
| [spectrology](https://github.com/solusipse/spectrology) | Audio (WAV) | Encodes an image in the spectrogram of an audio file. | `TODO` | Use GUI tool `sonic-visualiser` |
| [stegano](https://github.com/cedricbonhomme/Stegano) | Images (PNG) | Hides data with various (LSB-based) methods. Provides also some screening tools. | `stegano-lsb hide --input cover.jpg -f secret.txt -e UTF-8 --output stego.png` or `stegano-red hide --input cover.png -m "secret msg" --output stego.png` or `stegano-lsb-set hide --input cover.png -f secret.txt -e UTF-8 -g $GENERATOR --output stego.png` for various generators (`stegano-lsb-set list-generators`) | `stegano-lsb reveal -i stego.png -e UTF-8 -o output.txt` or `stegano-red reveal -i stego.png` or `stegano-lsb-set reveal -i stego.png -e UTF-8 -g $GENERATOR -o output.txt`
| [Steghide](http://steghide.sourceforge.net/) | Images (JPG, BMP) and Audio (WAV, AU) | Versatile and mature tool to encrypt and hide data. | `steghide embed -f -ef secret.txt -cf cover.jpg -p password -sf stego.jpg` | `steghide extract -sf stego.jpg -p password -xf output.txt`
| [cloackedpixel](https://github.com/livz/cloacked-pixel) | Images (PNG) | LSB stego tool for images | `cloackedpixel hide cover.jpg secret.txt password` creates `cover.jpg-stego.png` | `cloackedpixel extract cover.jpg-stego.png output.txt password`
| [LSBSteg](https://github.com/RobinDavid/LSB-Steganography) | Images (PNG, BMP, ...) in uncompressed formats | Simple LSB tools with very nice and readable Python code | `LSBSteg encode -i cover.png -o stego.png -f secret.txt` | `LSBSteg decode -i stego.png -o output.txt` |
| [f5](https://github.com/jackfengji/f5-steganography) | Images (JPG) | F5 Steganographic Algorithm with detailed info on the process | `f5 -t e -i cover.jpg -o stego.jpg -d 'secret message'` | `f5 -t x -i stego.jpg 1> output.txt` |


### Steganography GUI tools

All tools below have graphical user interfaces and cannot be used through the command line.
To run them, you must make an X11 server available inside the container.
Two ways are supported:
- run `start_ssh.sh` to fire up an SSH server. Connect afterwards with X11 forwarding. Requires an X11 server on your host!
- run `start_vnc.sh` to fire up a VNC server + client. Connect afterwards with your browser to port 6901 and you get an Xfce desktop. No host dependencies!

Alternatively, find other ways to make X11 available inside the container.
Many different ways are possible (e.g., [mount UNIX sockets](https://medium.com/@pigiuz/hw-accelerated-gui-apps-on-docker-7fd424fe813e)).

|Tool          |File types                |Description       |How to start    |
|--------------|--------------------------|------------------|----------------|
| [Steg](http://www.fabionet.org/) | Images (JPG, TIFF, PNG, BMP) | Handles many file types and implements different methods | `steg` |
| [Steganabara](http://www.caesum.com/handbook/stego.htm) (The [original link](http://www.freewebs.com/quangntenemy/steganabara/index.html) is broken) | Images (???) | Interactively transform images until you find something | `steganabara`|
| [Stegsolve](http://www.caesum.com/handbook/stego.htm) | Images (???) | Interactively transform images, view color schemes separately, ... | `stegsolve` |
| [SonicVisualiser](http://www.sonicvisualiser.org/) | Audio (???) | Visualizing audio files in waveform, display spectrograms, ... | `sonic-visualiser` |
| [Stegosuite](https://stegosuite.org/) | Images (JPG, GIF, BMP) | Can encrypt and hide data in images. Actively developed. | `stegosuite` |
| [OpenPuff](http://embeddedsw.net/OpenPuff_Steganography_Home.html) | Images, Audio, Video (many formats) | Sophisticated tool with long history. Still maintained. Windows tool running in wine. | `openpuff` |
| [DeepSound](http://jpinsoft.net/deepsound) | Audio (MP3, WAV) | Audio stego tool trusted by Mr. Robot himself. Windows tool running in wine (very hacky, requires VNC and runs in virtual desktop, MP3 broken due to missing DLL!) | `deepsound` only in VNC session |
| [cloackedpixel-analyse](https://github.com/livz/cloacked-pixel) | Images (PNG) | LSB stego visualization for PNGs - use it to detect suspiciously random LSB values in images (values close to 0.5 may indicate encrypted data is embedded) | `cloackedpixel-analyse image.png` |


### Screening scripts

Many tools above do not require interaction with a GUI.
Therefore, you can easily automate some workflows to do basic screening of files potentially containing hidden messages.
Since the applicable tools differ by filet type, each file type has different scripts.


For each file type, there are two kinds of scripts:
- `XXX_check.sh <stego-file>`: runs basic screening tools and creates a report (+ possibly a directory with reports in files)
- `XXX_brute.sh <stego-file> <wordlist>`: tries to extract a hidden message from a stego file with various tools using a wordlist (`cewl`, `john` and `crunch` are installed to generate lists - keep them small).

The following file types are supported:
- JPG: `check_jpg.h` and `brute_jpg.sh` (brute running `steghide`, `outguess`, `outguess-0.13`, `stegbreak`, `stegoveritas.py -bruteLSB`)
- PNG: `check_png.h` and `brute_png.sh` (brute running `openstego` and `stegoveritas.py -bruteLSB`)


### Wordlist generation

The brute forcing scripts above need wordlists.
Imho it will very likely not help to use huge standard wordlists like rockyou.
The scripts are too slow for it and stego challenges seem to not be designed for
this.
A more probable scenario is that you have a hunch what the password could be but
you do not know exactly.

For these cases, several tools to generate wordlists are included:
- [john](http://www.openwall.com/john/): the community enhanced version of John the Ripper can expand your wordlists. Create a base wordlist with a few candidate passwords and use `john` to create many variants of them. Use `john -wordlist:/path/to/your/wordlist -rules:Single -stdout > /path/to/expanded/wordlist` to apply extensive rules (~x1000) `john -wordlist:/path/to/your/wordlist -rules:Wordlist -stdout > /path/to/expanded/wordlist` for a reduced ruleset (~x50).
- [crunch](https://tools.kali.org/password-attacks/crunch): can generate small wordlists if you have a pattern in mind. For instance, if you know the passwords ends with 1984 and is 6 letters long, use `crunch 6 6 abcdefghijklmnopqrstuvwxyz -t @@1984` will generate the 26 * 26 = 676 passwords aa1984, ab1984, ... up to zz1984. The format is `crunch <min-length> <max-length> <charset> <options>` and we used the templating option. Check out `less /usr/share/crunch/charset.lst` to see the char sets crunch ships with.
- [CeWL](https://digi.ninja/projects/cewl.php): can generate wordlists if you know a website is related to a password. For instance, run `cewl -d 0 -m 8 https://en.wikipedia.org/wiki/Donald_Trump` if you suspect a picture of Donald Trump contains an encrypted hidden message. The command scrapes the site and extracts strings at least 8 characters long.


## Steganography examples

The image contains a sample image and audio file each in different formats:
- `/examples/ORIGINAL.jpg`
- `/examples/ORIGINAL.png`
- `/examples/ORIGINAL.mp3`
- `/examples/ORIGINAL.wav`

It also contains a script `/examples/create_examples.sh` which you can run to embed a hidden message ("This is a very secret message!") into these files with many different methods.
After running this script, you find these files in `/examples/stego-files` with their names indicating which tool was used to embed the message.
You can run the screening scripts to see if they find anything on them or try to break them otherwise.

## GUI and Containers

By default, no GUI tools can be run in a Docker container as no X11 server is available.
To run them, you must change that.
What is required to do so depends on your host machine.
If you:
- run on Linux, you probably have X11
- run on Mac OS, you need Xquartz (`brew install Xquartz`)
- run on Windows, you have a problem

Use X11 forwarding through SSH if you want to go this way. Run `start_ssh` inside the container to start the server, make sure you expose port 22 when starting the container: `docker run -p 127.0.0.1:22:22 ...`, then use `ssh -X ...` when connecting (the script prints the password).

To not depend on X11, the image comes with a TigerVNC server and noVNC client.
You can use it to open an HTML5 VNC session with your browser to connect to the containers Xfce desktop. To to that, run `start_vnc.sh` inside the container to start server and client, make sure you expose port 6901 when starting the container `docker run -p 127.0.0.1:6901:6901 ...` and go to `localhost:6901/?password=<the_password>` (the script prints the password).

### Using SSH with X11 forwarding

![animated demo gif - SSH + X11](https://i.imgur.com/aRJtbnP.gif)

Commands in the GIF for copy & paste:
```
# in 1st host shell
docker run -it --rm -p 127.0.0.1:22:22 dominicbreuker/stego-toolkit /bin/bash

# inside container shell
start_ssh.sh

# in 2nd host shell (use it to launch GUI apps afterwards)
ssh -X -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@localhost
```

### Using Browser and VNC

![animated demo gif - Browser + VNC](https://i.imgur.com/3tkw498.gif)

Commands in the GIF for copy & paste:
```
# in 1st host shell
docker run -it --rm -p 127.0.0.1:6901:6901 dominicbreuker/stego-toolkit /bin/bash

# inside container shell
start_vnc.sh

# in browser, connect with: http://localhost:6901/?password=<password_from_start_vnc>
```
## Link collection

This is a collection of useful Steganography links:
- You must be able to spot codes. Check out this [cheat sheet](http://www.ericharshbarger.org/epp/code_sheet.pdf) from Eric Harshbarger, which contains many different codes.
- Cheat sheet describing workflows, things to look for and common tools: [click](https://pequalsnp-team.github.io/cheatsheet/steganography-101)
- Forensics CTF guide with lots of ideas for stego challenges: [click](https://trailofbits.github.io/ctf/forensics/)
- File format descriptions as beautiful posters: [click](https://github.com/corkami/pics/blob/master/binary/README.md)

## References

The following example media files are included in this repository:
- Demo image (JPG, PNG): https://pixabay.com/p-1685092
- Demo sound file (MP3, WAV): https://upload.wikimedia.org/wikipedia/commons/c/c5/Auphonic-wikimedia-test-stereo.ogg --- By debuglevel (Own work) [CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons
