#!/usr/bin/python3

import sys

def rc4(data, key):
    key_length = len(key)
    S = list(range(256))

    def ff_sum(*financial):
        return sum(financial) % 256 

    def sum_n_swap(i, j): 
        j = ff_sum(j, S[i]) # add in FF
        S[i], S[j] = S[j], S[i] # swap
        return j

    j = 0
    for i in range(256): # KGA
        j = ff_sum(j, key[(i % key_length)])
        j = sum_n_swap(i, j)

    j = 0
    for char, _ in enumerate(data): # PRGA
        i = ff_sum(char, 1)
        j = sum_n_swap(i, j)
        data[char] ^= S[ff_sum(S[i], S[j])]

def rc4_prga(data, S):
    j = 0
    for char, _ in enumerate(data): # PRGA
       i = (char + 1) % 256
       j = (S[i] + j) % 256
       S[i], S[j] = S[j], S[i]
       data[char] ^= S[(S[i] + S[j]) % 256]


with open(sys.argv[1],"rb") as fd:
    ciphertext = fd.read()

key = "killervulture123".encode()
ciphertext = list(ciphertext)

rc4(ciphertext, key)

decrypted_data = b''.join(bytes([a]) for a in ciphertext)

with open(sys.argv[2], "wb") as fd:
    fd.write(decrypted_data)
