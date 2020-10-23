

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


 /* File created by MIDL compiler version 8.01.0622 */
/* at Mon Jan 18 19:14:07 2038
 */
/* Compiler settings for Source.idl:
    Oicf, W1, Zp8, env=Win64 (32b run), target_arch=AMD64 8.01.0622 
    protocol : all , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
/* @@MIDL_FILE_HEADING(  ) */



/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 500
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif /* __RPCNDR_H_VERSION__ */

#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif /*COM_NO_WINDOWS_H*/

#ifndef __Source_h_h__
#define __Source_h_h__

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

/* Forward Declarations */ 

#ifndef __Imalz_FWD_DEFINED__
#define __Imalz_FWD_DEFINED__
typedef interface Imalz Imalz;

#endif 	/* __Imalz_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

#ifdef __cplusplus
extern "C"{
#endif 


#ifndef __Imalz_INTERFACE_DEFINED__
#define __Imalz_INTERFACE_DEFINED__

/* interface Imalz */
/* [unique][uuid][object] */ 


EXTERN_C const IID IID_Imalz;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("E27297B0-1E98-4033-B389-24ECA246002A")
    Imalz : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE Pass( 
            unsigned char *buf) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE Key( 
            unsigned char *buf) = 0;
        
    };
    
    
#else 	/* C style interface */

    typedef struct ImalzVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            Imalz * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            _COM_Outptr_  void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            Imalz * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            Imalz * This);
        
        HRESULT ( STDMETHODCALLTYPE *Pass )( 
            Imalz * This,
            unsigned char *buf);
        
        HRESULT ( STDMETHODCALLTYPE *Key )( 
            Imalz * This,
            unsigned char *buf);
        
        END_INTERFACE
    } ImalzVtbl;

    interface Imalz
    {
        CONST_VTBL struct ImalzVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define Imalz_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define Imalz_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define Imalz_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define Imalz_Pass(This,buf)	\
    ( (This)->lpVtbl -> Pass(This,buf) ) 

#define Imalz_Key(This,buf)	\
    ( (This)->lpVtbl -> Key(This,buf) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __Imalz_INTERFACE_DEFINED__ */


/* Additional Prototypes for ALL interfaces */

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif


