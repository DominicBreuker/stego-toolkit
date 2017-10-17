#!/usr/bin/python2

import argparse
import re


class BitstringAnalyser(object):
    def __init__(self, bitstring):
        self.bitstring = bitstring

    def analyze(self):
        if self._is_bitstring():
            print("\nBitstring found: length={} content='{}'"
                  .format(len(self.bitstring), self.bitstring))
            self._try_convert_to_string()
            self._try_convert_to_integer()

    def _is_bitstring(self):
        return re.match(r"^[01]*$", self.bitstring) is not None

    def _try_convert_to_string(self):
        try:
            chars = []
            for b in range(len(self.bitstring) / 8):
                byte = self.bitstring[b*8:(b+1)*8]
                chars.append(chr(int(''.join([str(bit) for bit in byte]), 2)))
            result = ''.join(chars)
            print(" - Conversion to string: \n------------------\n{}\n----------------\n".format(result))
        except Exception as e:
            print(" - Conversion to integer: FAILED ({})".format(e.message))

    def _try_convert_to_integer(self):
        try:
            result = int(self.bitstring, 2)
            print(" - Conversion to integer: '{}'".format(result))
            pass
        except Exception as e:
            print(" - Conversion to integer: FAILED ({})".format(e.message))


    # @staticmethod
    # def _to_bits(self, s):
    #     result = []
    #     for c in s:
    #         bits = bin(ord(c))[2:]
    #         bits = '00000000'[len(bits):] + bits
    #         result.extend([int(b) for b in bits])
    #     return result


def parse_args():
    parser = argparse.ArgumentParser(prog='BRUTE')
    parser.add_argument("data", nargs="?", type=bytes,
                        help="Data to analyse")
    return parser.parse_args()

if __name__ == "__main__":
    args = parse_args()
    BitstringAnalyser(args.data).analyze()
