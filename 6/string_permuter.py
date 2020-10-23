import argparse, hashlib, binascii


def permute_string(string, bmpdata):
    out_string = b""
    bmp_byte_incrementer = 0
    for i in range(len(string)): # for each character in string
        char = string[i]
        # this for loop reconstructs a 7 bit "byte"
        for j in range(6,-1,-1): # iterate 7 times starting from 6 and ending at 0(-1 in python since -1 isn't included)
            single_bmp_bit = bmpdata[bmp_byte_incrementer] & 1 # get a single LSB from a single bmp byte
            char += single_bmp_bit << j # move the bit over according to j iterator
            bmp_byte_incrementer += 1 # move onto the next byte
        print(chr(char))
        out_string += bytes([((char >> 1) + ((char & 1) << 7))])
    return out_string

def main():
    parser = argparse.ArgumentParser(description="brute forces hostnames for Flare-on7 challenge 6")
    parser.add_argument("-bmp", help="sprite.bmp extracted from the exe")
    args = parser.parse_args()

    if (args.bmp is None):
        print("Please see help with -h")
        exit()
    
    with open(args.bmp,"rb") as fd:
        bmpdata = fd.read()

    teststring = b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
    out_string = permute_string(teststring, bmpdata[54:])
    print(bmpdata[54:154])
    print(out_string)

main()
