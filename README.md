# Stego Toolkit

## Tools

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
