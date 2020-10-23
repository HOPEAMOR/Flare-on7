#!/usr/bin/python3

import re, argparse, binascii

# accepts data and deobfuscates according to built in regex's
def regex_deobfuscate(data):
    number_constants_regex = r'\$([A-Z]{10})\s=\sNumber\("\s([0-9]{1,})\s"\)'
    
    number_constant_def_arr = re.findall(number_constants_regex,data)
    for val in number_constant_def_arr:
        data = data.replace(val[0],val[1])

    return data

# accepts data and deobfuscates static function names by functionality
def function_name_deobfuscate(data):
    function_names_dict = {
        "AREHDIDXRGK": "", # this is the hex decoding function
        "AREWUOKNZVH": "gen_random_string",
        "AREGFMWBSQD": "file_install_switch",
        "AREUZNAQFMN": "GetComputerName",
        "AREPFNKWYPW": "GetVersionEx",
        "AREAQWBMTIZ": "hash_data",
        "ARERUJPVSFP": "CreateFile",
        "AREMYFDTFQP": "CreateFile",
        "AREMFKXLAYV": "WriteFile_at_location",
        "AREMLFOZYNU": "ReadFile",
        "AREVTGKXJHU": "CloseHandle",
        "AREBBYTWCOJ": "DeleteFileA",
        "ARENWRBSKLL": "GetFileSize",
        "AREIHNVAPWN": "create_os_array",
        "AREIALBHUYT": "main_gui_control",
        "AREGTFDCYNI": "get_data_from_sprite",
        "AREOXAOHPTA": "create_struct_assign_data",
        "AREYZOTAFNF": "place_flag_in_struct",
        "$OS": "$STRINGS_ARR"
    }
    
    for ob_name,deob_name in function_names_dict.items():
        data = data.replace(ob_name,deob_name)

    return data

def variable_name_deobfuscate(data):
    variable_names_dict = {
        "FLVBURIUYD": "file_size",
        "FLNFUFVECT": "file_data_struct",
        "FLXMDCHRQD": "file_data_and_size_struct",
        "FLQGWNZJZC": "struct_incrementer",
        "FLTERGXSKH": "computername_incrementer",
        "FLTAJBYKXX": "inner_for_decrementer",
        "FLYDTVGPNC": "computername_character",
        "FLOCTXPGQH": "out_string",
        "FLKQAOVZEC": "computername_struct",
        "FLISILAYLNRAW": "computername_struct",
        "FLMTVYZRSY": "key_blob_struct",
        "FLKPZLQKCH": "encrypted_blob",
        "FLUELRPEAX": "encrypted_content_struct",
        "FLFZFSUAOZ": "beginning_delimiter",
        "FLTVWQDOTG": "end_delimiter",
        "FLODIUTPUY": "qr_code_struct",
        "FLNPAPEKEN": "qr_code_struct",
        "FLSEKBKMRU": "decrypted_qr_flag",
        "FLNTTMJFEA": "hash_struct",
        "FLPNLTLQHH": "random_string",
        "FLBVOKDXKG": "bitmap_struct",
        "FLFWEZDBYC": "file_descriptor"
    }
    
    for ob_name,deob_name in variable_names_dict.items():
        data = data.replace(ob_name,deob_name)

    return data

# accepts data and strings array and replaces strings
def strings_constants_deobfuscate(data, strings_arr):
    strings_arr_name_prefix = "$STRINGS_ARR["
    strings_arr_name_suffix = "]"

    for i in range(len(strings_arr)):
        old_name = strings_arr_name_prefix + "$" + str(i+1) + strings_arr_name_suffix # static offset to match the one in the strings file
        new_name = strings_arr_name_prefix + "\"" + strings_arr[i] + "\"" + strings_arr_name_suffix
        data = data.replace(old_name, new_name)
    
    return data


# accepts data and strings array and replaces strings
def strings_constants_deobfuscate(data, strings_arr):
    strings_arr_name_prefix = "$STRINGS_ARR["
    strings_arr_name_suffix = "]"

    for i in range(len(strings_arr)):
        old_name = strings_arr_name_prefix + "$" + str(i+1) + strings_arr_name_suffix # static offset to match the one in the strings file
        new_name = "\"" + strings_arr[i] + "\""
        data = data.replace(old_name, new_name)
    
    return data

# accepts a strings file descriptor and returns a list filled with the lines of that file, making it the strings replacement list.
def fill_strings_array(strings_file):
    strings_arr = []
    for line in strings_file.readlines():
        strings_arr.append(line.rstrip("\n"))
    return strings_arr

def main():
    # accept arguments and exit if they do not fit my liking
    parser = argparse.ArgumentParser(description="For Flare-on")
    parser.add_argument("-inf", help="Path to extracted AutoIt script")
    parser.add_argument("-outf", help="Path to put deobfuscated script")
    parser.add_argument("-strings", help="Path to strings constants file with each each line representing the corresponding entry in the obfuscation array")
    args = parser.parse_args()

    if (args.inf is None or args.outf is None or args.strings is None):
        print("Please print help with -h for usage information")
        exit()

    out_file = open(args.outf,"w")

    # load data
    au3_file = open(args.inf,"r")
    data = au3_file.read()
    au3_file.close()

    # load strings array
    strings_file = open(args.strings,"r")
    strings_arr = fill_strings_array(strings_file)
    strings_file.close()
    
    # deobfuscate using a few regex's
    data = regex_deobfuscate(data)

    # deobfuscate function names
    data = function_name_deobfuscate(data)

    # deobfuscate variable names
    data = variable_name_deobfuscate(data)

    # deobfuscates string constants stored in an array
    data = strings_constants_deobfuscate(data, strings_arr)

    # write outfile
    out_file.write(data)

    print("Done!")
    au3_file.close()
    out_file.close()

main()
