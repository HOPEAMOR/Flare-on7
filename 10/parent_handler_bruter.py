
answer = [0xe8135594, 0x9678e7e2, 0x83411ce4, 0x91bda628, 0xb82d3c24, 0xc93de012, 0xab202240, 0x2499954e, 0xf7ff4e38, 0x9c7a9d6, 0x4a51739a, 0x7e85db2a, 0x3dfc1166, 0xb82d3c24]

def hasher(data):
    a = 0xdeadbeef
    b = 0x1337cafe
    data = a ^ data
    data = b * data
    data = data & 0xffffffff
    return data

def main():

    need_count = len(answer)
    found_count = 0
    
    for i in range(2**32):
        single_hash = hasher(i)
        if (single_hash in answer):
            print(f"found: {hex(i)} for {hex(single_hash)}")
            found_count += 1
        if (found_count == need_count):
            print("found all!")
            return
    print("needed: ", need_count)
    print("found: ", found_count)
    print("done")
    return



main()
