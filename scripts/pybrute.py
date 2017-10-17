#!/usr/bin/python
from __future__ import print_function

import os
import re
import sys
import md5
import argparse
import threading
import subprocess
from tqdm import tqdm


class ThreadedCracker(threading.Thread):
    def __init__(self, pool, args):
        threading.Thread.__init__(self)
        self.pool = pool
        self.args = args

    def crack(self):
        self.pool.acquire()
        self.start()

    def run(self):
        try:
            self.crack_function(*self.args)
        except Exception as e:
            print("Error cracking {} - {}".format(self.args, e))
        finally:
            self.pool.release()

    def crack_function(self):
        raise Exception("Not implemented")


class ThreadedSteghideCracker(ThreadedCracker):
    def crack_function(self, stego_file, passphrase):
        process = subprocess.Popen(['steghide',
                                    'info',
                                    stego_file,
                                    '-p', passphrase],
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE)
        (out, err) = process.communicate()
        m = re.search(r"embedded file \"(.*)\"", out)
        if m is not None:
            print("\nFound '{}'!\n\
Extract with `steghide extract -sf {} -p \"{}\"`"
                  .format(m.group(1), stego_file, passphrase))
            sys.exit(0)


class ThreadedOutguessCracker(ThreadedCracker):
    def crack_function(self, stego_file, passphrase):
        tmp_file = "/tmp/{}".format(md5.new(passphrase).hexdigest())
        process = subprocess.Popen(['outguess',
                                    '-k', passphrase,
                                    '-r', stego_file,
                                    tmp_file],
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE)
        (out, err) = process.communicate()
        try:
            with open(tmp_file, "r") as f:
                data = f.read()
                if len(data) > 0:
                    ascii_data = "".join(filter(lambda x: ord(x) < 128, data))
                    if float(len(ascii_data)) / float(len(data)) > 0.8:
                        print("\nFound secret message:\n---\n{}\n---\n\
Extract with `outguess -k \"{}\" -r {} /tmp/outguess_secret.txt`"
                              .format(ascii_data, passphrase, stego_file))
                        sys.exit(0)
        finally:
            os.remove(tmp_file)


class ThreadedOutguess013Cracker(ThreadedCracker):
    def crack_function(self, stego_file, passphrase):
        tmp_file = "/tmp/{}".format(md5.new(passphrase).hexdigest())
        process = subprocess.Popen(['outguess-0.13',
                                    '-k', passphrase,
                                    '-r', stego_file,
                                    tmp_file],
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE)
        (out, err) = process.communicate()
        try:
            with open(tmp_file, "r") as f:
                data = f.read()
                if len(data) > 0:
                    ascii_data = "".join(filter(lambda x: ord(x) < 128, data))
                    if float(len(ascii_data)) / float(len(data)) > 0.8:
                        print("\nFound secret message:\n---\n{}\n---\n\
Extract with `outguess -k \"{}\" -r {} /tmp/outguess_secret.txt`"
                              .format(ascii_data, passphrase, stego_file))
                        sys.exit(0)
        finally:
            os.remove(tmp_file)


class ThreadedOpenstegoCracker(ThreadedCracker):
    def crack_function(self, stego_file, passphrase):
        process = subprocess.Popen(['openstego', 'extract',
                                    '-p', passphrase,
                                    '-sf', stego_file],
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE)
        (out, err) = process.communicate()
        m = re.search(r"Extracted file: (.*)", err)
        if m is not None:
            print("\nFound '{}'!\n\
Extract with `openstego extract -sf {} -p \"{}\"`"
                  .format(m.group(1), stego_file, passphrase))
            sys.exit(0)

# TODO: jphide / jpseek brute forcing --- requires interactive passphrase...


def parse_args():
    parser = argparse.ArgumentParser(prog='BRUTE')
    parser.add_argument("-f", "--file", nargs="?", required=True, type=str,
                        help="File containing secret message")
    parser.add_argument("-w", "--wordlist", nargs="?", required=True,
                        type=argparse.FileType('r'), default=sys.stdin,
                        help="Wordlist with passphrases")
    parser.add_argument("-t", "--threads", nargs="?", required=False,
                        type=int, default=10,
                        help="Number of threads")

    subparsers = parser.add_subparsers(title='Commands',
                                       description='Choose stego tool')
    steghide_parser = subparsers.add_parser('steghide',
                                            help='steghide tool')
    steghide_parser.set_defaults(tool='steghide')

    outguess_parser = subparsers.add_parser('outguess',
                                            help='outguess tool')
    outguess_parser.set_defaults(tool='outguess')

    outguess013_parser = subparsers.add_parser('outguess-0.13',
                                               help='outguess-0.13 tool')
    outguess013_parser.set_defaults(tool='outguess-0.13')

    openstego_parser = subparsers.add_parser('openstego',
                                               help='openstego tool')
    openstego_parser.set_defaults(tool='openstego')

    return parser.parse_args()


def bruteforce(Cracker, stego_file, wordlist, num_threads):
    pool = threading.BoundedSemaphore(value=num_threads)
    with tqdm(total=get_num_passphrases(wordlist)) as progress_bar:
        for passphrase in wordlist:
            passphrase = passphrase.strip()
            try:
                Cracker(pool, (stego_file, passphrase)).crack()
            except:
                print("Error: could not start thread")
            progress_bar.update(1)


def get_num_passphrases(wordlist):
    num_lines = sum(1 for line in wordlist)
    wordlist.seek(0)
    return num_lines


if __name__ == "__main__":
    args = parse_args()
    crackers = {
        "steghide": ThreadedSteghideCracker,
        "outguess": ThreadedOutguessCracker,
        "outguess-0.13": ThreadedOutguess013Cracker,
        "openstego": ThreadedOpenstegoCracker
    }
    print("Cracking {} with {} - {} threads"
          .format(args.file, args.tool, args.threads))
    bruteforce(crackers[args.tool], args.file,
               args.wordlist, args.threads)
