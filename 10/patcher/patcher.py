#!/usr/bin/python3

import subprocess

# write new functions to shellcode
def patch_sc(shellcode_data):

    # new functions get placed after new_function_offset and new_function_offset gets updated to a new offset.
    # then their location gets placed in function_offsets_dict
    # asm_patch_list is a list of patches to implement
    # TODO: import an assembler and assemble the code rather than hardcoding it
    new_function_offset = 0x8820
    truncate_path_loc = 0x804c640 # beginning of shellcode
    functions_dict = {
        # PUSHAD
        # MOV ECX,EAX
        # MOV EDX,0x50
        # MOV EBX,1
        # MOV EAX,4
        # INT 0x80
        # POPAD
        # POP EDI ; stores the return pointer in edi
        "puts_eax" : b"\x60\x89\xC1\xBA\x80\x00\x00\x00\xBB\x01\x00\x00\x00\xB8\x04\x00\x00\x00\xCD\x80\x61\x5F",
        # PUSHAD
        # MOV ECX,EAX
        # MOV EDX,0x80
        # MOV EBX,1
        # MOV EAX,4
        # INT 0x80
        # POPAD
        # POP EAX
        "puts_eax_eax" : b"\x60\x89\xC1\xBA\x80\x00\x00\x00\xBB\x01\x00\x00\x00\xB8\x04\x00\x00\x00\xCD\x80\x61\x58",
        # PUSHAD
        # POP EDI
        # PUSH EDI
        # MOV EDX,0x8
        # MOV ECX,EDI
        # MOV EBX,1
        # MOV EAX,4
        # INT 0x80
        # MOV EDX,0x20
        # MOV ECX,EAX
        # MOV EBX,1
        # MOV EAX,4
        # INT 0x80
        # POPAD
        # POP EDI
        "puts_eip_eax" : b"\x60\x5F\x57\xBA\x08\x00\x00\x00\x89\xF9\xBB\x01\x00\x00\x00\xB8\x04\x00\x00\x00\xCD\x80\xBA\x20\x00\x00\x00\x89\xC1\xBB\x01\x00\x00\x00\xB8\x04\x00\x00\x00\xCD\x80\x61\x5F",
        # PUSHAD
        # MOV ECX,EDX
        # MOV EDX,0x20
        # MOV EBX,1
        # MOV EAX,4
        # INT 0x80
        # POPAD
        # POP EDI ; stores the return pointer in edi
        "puts_edx" : b"\x60\x89\xD1\xBA\x50\x00\x00\x00\xBB\x01\x00\x00\x00\xB8\x04\x00\x00\x00\xCD\x80\x61\x5F",
        # PUSHAD
        # MOV ECX,EDX
        # MOV EDX,0x20
        # MOV EBX,1
        # MOV EAX,4
        # INT 0x80
        # POPAD
        # POP EAX ; stores the return pointer in EAX
        "puts_edx_eax" : b"\x60\x89\xD1\xBA\x80\x00\x00\x00\xBB\x01\x00\x00\x00\xB8\x04\x00\x00\x00\xCD\x80\x61\x58",
        # PUSHAD
        # PUSH 0x65656562
        # MOV ECX, [ESP+4]
        # MOV EDX,0x4
        # MOV EBX,1
        # MOV EAX,4
        # INT 0x80
        # POP EDI
        # POPAD
        # POP EDI
        "puts_bee" : b"\x60\x68\x62\x65\x65\x65\x8B\x0C\x24\xBA\x04\x00\x00\x00\xBB\x01\x00\x00\x00\xB8\x04\x00\x00\x00\xCD\x80\x5F\x61\x5F",
        # PUSH EDI ; puts the return pointer back on the stack
        # RET
        "ret" : b"\x57\xc3",
        # PUSH EAX ; puts the return pointer back on the stack
        # RET
        "ret_eax" : b"\x50\xc3"
    }
    functions_offsets_dict = {
        "puts_eax" : 0 # initialize to 0
    }
    # [patch offset, asm replace string, [desired function call from functions_offsets_dict in order], cancel_flag]
    asm_patch_list = [
        [0x8053b70, b"\xE8%s%s%s%s", 5, ["puts_bee","ret"], 1], # CALL puts ; calls puts function from bee_shellcode
        [0x80546e2, b"\xE8%s%s%s%s", 5, ["puts_eax","ret"], 1], # CALL puts ; calls puts function from bee_hash_keygen_store_arg3
        [0x80546e2, b"\xE8%s%s%s%s", 5, ["puts_eax_eax","ret_eax"], 1], # CALL puts ; calls puts function from bee_hash_keygen_store_arg3
        [0x80543cb, b"\xE8%s%s%s%s", 5, ["puts_edx_eax","ret_eax"], 0], # CALL puts ; calls puts function from bee_crypto_wrap_store_arg4
        [0x8054253, b"\xE8%s%s%s%s", 5, ["puts_edx","ret"], 1], # CALL puts ; calls puts function from bee_cmp_*param1<*param2
        [0x8054b63, b"\xE8%s%s%s%s", 5, ["puts_eax","ret"], 1], # CALL puts ; calls puts function from right before sprintf for urandom_compare_buf
        [0x8054b88, b"\xE8%s%s%s%s", 5, ["puts_eax","ret"], 1], # CALL puts ; calls puts function from right before sprintf for string_compare_buf
        [0x8054b9e, b"\xE8%s%s%s%s", 5, ["puts_edx","ret"], 1], # CALL puts ; calls puts function to overwrite the cmp function call for urandom_buf
        [0x8054c4c, b"\xE8%s%s%s%s", 5, ["puts_eax","ret"], 1], # CALL puts ; calls puts function to overwrite the cmp function call for string_compare_buf
        [0x8054802, b"\xE8%s%s%s%s", 5, ["puts_edx_eax","ret_eax"], 1], # CALL puts ; calls puts function from bee_add_sub
        [0x80549d9, b"\xE8%s%s%s%s", 5, ["puts_edx","ret"], 1] # CALL puts ; calls puts function from right before d1cc3447 string gets copied to its buffer
    ]

    # copy bytes out of patched function and prepend them to the call function
    for entry in asm_patch_list:
        offset = entry[0] - truncate_path_loc
        code = entry[1]
        code_len = entry[2]
        functions = entry[3]
        cancel_flag = entry[4]

        if (cancel_flag == 0):
            print("patching location: ", hex(entry[0]), " with ", functions[0])
            # original_bytes is the data that we need to overwrite to make our call
            original_bytes = shellcode_data[offset:offset+code_len]
            # function_bytes reimplements the overwritten bytes from original_bytes and prepends it to a new function
            function_bytes = functions_dict[functions[0]] + original_bytes + functions_dict[functions[1]]
            # update patch code with location of new function.
            byte1 = ((new_function_offset - offset) - code_len) & 0xff
            byte2 = (((new_function_offset - offset) - code_len) & 0xff00) >> 8
            byte3 = (((new_function_offset - offset) - code_len) & 0xff0000) >> 16
            byte4 = (((new_function_offset - offset) - code_len) & 0xff000000) >> 24
            patch_bytes = code % (bytes([byte1]),bytes([byte2]),bytes([byte3]),bytes([byte4]))

            # patch the function
            for i in range(len(patch_bytes)):
                shellcode_data[offset+i] = patch_bytes[i]
            # write our new function
            for i in range(len(function_bytes)):
                shellcode_data[new_function_offset+i] = function_bytes[i]
            # update new_function_offset
            new_function_offset += len(function_bytes)

    return



def main():
    # open the decrypted shellcode file
    with open("bee_script_dump_dec.bin","rb") as fd:
        shellcode_data = fd.read()
    # make the byte array mutable
    shellcode_data = bytearray(shellcode_data)

    # write new functions to shellcode data
    # write prebuilt patch bytes to predefined offsets
    print("patching shellcode")
    patch_sc(shellcode_data)
    #print(shellcode_data[0x80a2:0x80a2+0x10])

    # write new shellcode data to disk and encrypt with with 2nd_part_cryptor
    with open("bee_script_patched_dec.bin","wb") as fd:
        fd.write(shellcode_data)
    print("encrypting shellcode")
    subprocess.run(["./2nd_part_cryptor","e","bee_script_patched_dec.bin","bee_script_patched_enc.bin"])

    # overwrite data from original file and write it to disk as a new file.
    # open original binary
    print("opening break_rm_patched")
    with open("../break_rm_patched","rb") as fd:
        binary_data = fd.read()
    binary_data = bytearray(binary_data)

    # open encrypted shellcode file
    with open("bee_script_patched_enc.bin","rb") as fd:
        enc_shellcode_data = fd.read()

    # find offset to begining of desired patch location
    print("patching binary with encrypted shellcode")
    enc_shellcode_start_bytes = b"\xd6\x3f\x6a\x10\xaa\x92\xdc\xf4\xd6\x3f\x6a\x10\xaa\x92\xdc\xf4\xd6\x3f\x6a\x10\xaa\x92\xdc\xf4\xd6\x3f\x6a\x10\xaa\x92\xdc\xf4"
    binary_shellcode_loc = binary_data.find(enc_shellcode_start_bytes)
    # overwrite shellcode portion of binary data
    for i in range(len(enc_shellcode_data)):
        binary_data[binary_shellcode_loc+i] = enc_shellcode_data[i]

    # write out patched binary
    print("writing break_rm_bee_patched")
    with open("../break_rm_bee_patched","wb") as fd:
        fd.write(binary_data)

    print("Finished!")
    return

main()
