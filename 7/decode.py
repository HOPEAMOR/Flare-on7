import sys

def decrypt(encoded_bytes,l):
    decoded_bytes = ""
    for i in range(l):
        block=encoded_bytes[i*2:i*2+2]
        decoded_byte_low = ord(block[1]) & 0x0F
        decoded_byte_high = ((ord(block[1]) >> 4) + (ord(block[0]) & 0x0F)) & 0x0F
        decoded_byte=chr(decoded_byte_low + (decoded_byte_high <<4))
        decoded_bytes+=decoded_byte
    return decoded_bytes

def main():
    with open(sys.argv[1],"r") as fd:
        line_data = fd.readlines()

    for data in line_data:
        if len(data) > 0:
            l = int(len(data)/2)
            print(decrypt(data,l))

main()
