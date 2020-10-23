import argparse, hashlib, binascii, itertools
from Crypto.Cipher import AES


def sha256(data):
    return hashlib.sha256(data).hexdigest()

def permute_string(string, bmpdata):
    out_string = b""
    struct_incrementer = 0
    for i in range(len(string)):
        char = string[i]
        for j in range(6,-1,-1):
            char += (bmpdata[struct_incrementer] & 1) << j
            struct_incrementer += 1
        out_string += bytes([((char >> 1) + ((char & 1) << 7))])
    return out_string

def aes_decrypt(data, key, iv):
    try:
        cipher = AES.new(key, AES.MODE_CBC, iv)
        decrypted_data = cipher.decrypt(data)
        return decrypted_data
    except:
        print("aes failure")
        return b""
    

def main():
    parser = argparse.ArgumentParser(description="brute forces hostnames for Flare-on7 challenge 6")
    parser.add_argument("-bmp", help="sprite.bmp extracted from the exe")
    parser.add_argument("-len", type=int, help="sprite.bmp extracted from the exe")
    args = parser.parse_args()

    if (args.bmp is None):
        print("Please see help with -h")
        exit()
    
    with open(args.bmp,"rb") as fd:
        bmpdata = fd.read()

    encrypted_blob = binascii.unhexlify("CD4B32C650CF21BDA184D8913E6F920A37A4F3963736C042C459EA07B79EA443FFD1898BAE49B115F6CB1E2A7C1AB3C4C25612A519035F18FB3B17528B3AECAF3D480E98BF8A635DAF974E0013535D231E4B75B2C38B804C7AE4D266A37B36F2C555BF3A9EA6A58BC8F906CC665EAE2CE60F2CDE38FD30269CC4CE5BB090472FF9BD26F9119B8C484FE69EB934F43FEEDEDCEBA791460819FB21F10F832B2A5D4D772DB12C3BED947F6F706AE4411A52")
    master_string = b"FLARE"
   
    # testdata
#    encrypted_blob = binascii.unhexlify("7ed822e5ed6c1c11a08259095612805c")
#    master_string = b"testd"

    iv = b"\x00" * 16

    all_strings = map(''.join, itertools.product('abcdefghijklmnopqrstuvwxyz0123456789~!@#$%^&*()_+`-={[}]|;:\'\",<.>?/', repeat=args.len))

    counter = 0

    for teststring in all_strings:
        if(counter%100000 == 0):
            print("Progress: ", teststring)
        counter += 1
        teststring = b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        out_string = permute_string(teststring, bmpdata[54:])
        print(out_string)
        hash_data = sha256(out_string)
        key = binascii.unhexlify(hash_data)
        decrypted_data = aes_decrypt(encrypted_blob, key, iv)
        if (decrypted_data != b""):
            if (decrypted_data.find(master_string) >= 0):
                print("SUCCESS!")
                print("HOSTNAME STRING: ",teststring)
                return 0
    

main()
