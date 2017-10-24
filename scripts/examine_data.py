#!/usr/bin/python2
# WORK IN (early) PROGRESS

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
            self._print_result("string", ''.join(chars))
        except Exception as e:
            self._print_fail("string", e.message)

    def _try_convert_to_integer(self):
        try:
            self._print_result("integer", int(self.bitstring, 2))
        except Exception as e:
            self._print_fail("integer", e.message)

    def _print_result(self, conversion_type, result):
        result = str(result)
        if len(result) > 20:
            print(" - Conversion to {}: '{}...'".format(conversion_type, result[:20]))
        else:
            print(" - Conversion to {}: '{}'".format(conversion_type, result))

    def _print_fail(self, conversion_type, reason):
        print(" - Conversion to {}: FAILED ({})".format(conversion_type, reason))


    # @staticmethod
    # def _to_bits(self, s):
    #     result = []
    #     for c in s:
    #         bits = bin(ord(c))[2:]
    #         bits = '00000000'[len(bits):] + bits
    #         result.extend([int(b) for b in bits])
    #     return result


def parse_args():
    parser = argparse.ArgumentParser(prog='EXAMINE')
    parser.add_argument("data", nargs="?", type=bytes,
                        help="Data to analyse")
    return parser.parse_args()

if __name__ == "__main__":
    args = parse_args()
    BitstringAnalyser(args.data).analyze()
