// chal9.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <windows.h>
#include "Source_h.h"


int main()
{

    const GUID myClsid = { 0xCEEACC6E, 0xCCB2, 0x4C4F, 0xBC, 0xF6, 0xD2, 0x17, 0x60, 0x37, 0xA9, 0xA7 };
    const GUID myIid = { 0xE27297B0, 0x1E98, 0x4033, 0xB3, 0x89, 0x24, 0xEC, 0xA2, 0x46, 0x00, 0x2A };
    HRESULT hr;
    Imalz* malz = NULL;
    HKEY hKey;
    LSTATUS key_success;
    unsigned char* buf = (unsigned char *)malloc(0x100); 

    hr = CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);
    if (FAILED(hr)) {
        std::string message = std::system_category().message(hr);
        std::cout << "Failed in CoInitializeEx\n";
        std::cout << message;
        return 1;
    }

    hr = CoCreateInstance(myClsid, NULL, CLSCTX_ALL, myIid, (void**) &malz);
    if (FAILED(hr)) {
        std::string message = std::system_category().message(hr);
        std::cout << "Failed in CoCreateInstance\n";
        std::cout << message;
        return 1;
    }

    std::cout << "Before RegCreateKeyW\n";

    key_success = RegCreateKeyW(HKEY_CLASSES_ROOT, L"CLSID\\{CEEACC6E-CCB2-4C4F-BCF6-D2176037A9A7}\\Config\\Data", &hKey);
    if (key_success != ERROR_SUCCESS) {
        std::cout << "Error in creating key \n";
        std::cout << key_success << "\n";
        return 1;
    }
    
    std::cout << "Before RegDeleteKeyW\n";

    key_success = RegDeleteKeyW(HKEY_CLASSES_ROOT, L"CLSID\\{CEEACC6E-CCB2-4C4F-BCF6-D2176037A9A7}\\Config\\\\Data");
    if (key_success != ERROR_SUCCESS) {
        std::cout << "Error in deleting key \n";
        std::cout << key_success << "\n";
        return 1;
    }
    
    std::cout << "Before Pass\n";

    hr = malz->Pass(buf);
    if (FAILED(hr)) {
        std::string message = std::system_category().message(hr);
        std::cout << "Failed in Pass call\n";
        std::cout << hr << "\n";
        std::cout << message << "\n";
        return 1;
    }

    // print out the sbox to see if Pass is being changed by the kernel driver
    /*for (int i = 0; i < 0x100 ; i++){
        std::cout << buf[i] << "\n";
    }*/

    std::cout << "Before Key\n";

    hr = malz->Key(buf);
    if (FAILED(hr)) {
        std::string message = std::system_category().message(hr);
        std::cout << "Failed in Key Call\n";
        std::cout << hr << "\n";
        std::cout << message << "\n";
        return 1;
    }
    

    malz->Release();

    return 0;
}



// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
