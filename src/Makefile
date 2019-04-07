CC = gcc
CFLAGS = -std=gnu99 -m64 -g -O2
DEFINES = 
INCS = -I.
DEPS =
LIBS = -lpthread

########## Intel SGX ############

##### Parameters #####

SGX_SDK ?= /opt/intel/sgxsdk
SGX_MODE ?= SIM
SGX_COMMON_CFLAGS := -m64
SGX_LIBRARY_PATH := $(SGX_SDK)/lib64
SGX_ENCLAVE_SIGNER := $(SGX_SDK)/bin/x64/sgx_sign
SGX_EDGER8R := $(SGX_SDK)/bin/x64/sgx_edger8r

SGX_COMMON_CFLAGS += -g -O2

ifeq ($(SGX_MODE), HW)
	Urts_Library_Name := sgx_urts
	Trts_Library_Name := sgx_trts
	Service_Library_Name := sgx_tservice
else
	Urts_Library_Name := sgx_urts_sim
	Trts_Library_Name := sgx_trts_sim
	Service_Library_Name := sgx_tservice_sim
endif
Crypto_Library_Name := sgx_tcrypto

Enclave_Name := enclave.so
Signed_Enclave_Name := enclave.signed.so
Enclave_Config_File := enclave.config.xml


App_Link_Flags := $(SGX_COMMON_CFLAGS) -L$(SGX_LIBRARY_PATH) -l$(Urts_Library_Name)

ifeq ($(SGX_MODE), HW)
	App_Link_Flags += -lsgx_uae_service
else
	App_Link_Flags += -lsgx_uae_service_sim
endif

INCS += -I$(SGX_SDK)/include

#################################

all: $(Signed_Enclave_Name) app

app: main.o enclave_u.o
	$(CC) $(CFLAGS) $(DEPS) -o $@ $^ $(App_Link_Flags) $(LIBS)

##### App Objects #####

App_C_Flags := $(SGX_COMMON_CFLAGS) -fPIC -Wno-attributes 

# Three configuration modes - Debug, prerelease, release
#   Debug - Macro DEBUG enabled.
#   Prerelease - Macro NDEBUG and EDEBUG enabled.
#   Release - Macro NDEBUG enabled.
ifeq ($(SGX_DEBUG), 1)
	App_C_Flags += -DDEBUG -UNDEBUG -UEDEBUG
else ifeq ($(SGX_PRERELEASE), 1)
	App_C_Flags += -DNDEBUG -DEDEBUG -UDEBUG
else
	App_C_Flags += -DNDEBUG -UEDEBUG -UDEBUG
endif

enclave_u.c: $(SGX_EDGER8R) enclave.edl
	$(SGX_EDGER8R) --untrusted enclave.edl --search-path . --search-path $(SGX_SDK)/include
	@echo "GEN  =>  $@"

enclave_u.o: enclave_u.c
	$(CC) $(App_C_Flags) $(INCS) -c $< -o $@
	@echo "CC   <=  $<"

main.o: main.c enclave_u.o
	$(CC) $(CFLAGS) $(App_C_Flags) $(DEFINES) $(INCS) $(DEPS) -c -o $@ $<

##### Enclave Objects #####

Enclave_Include_Paths := -I. -I$(SGX_SDK)/include -I$(SGX_SDK)/include/tlibc -I$(SGX_SDK)/include/stlport

Enclave_C_Flags := $(SGX_COMMON_CFLAGS) -nostdinc -fvisibility=hidden -fpie -fstack-protector $(Enclave_Include_Paths)
Enclave_Cpp_Flags := $(Enclave_C_Flags) -nostdinc
Enclave_Link_Flags := $(SGX_COMMON_CFLAGS) -Wl,--no-undefined -nostdlib -nodefaultlibs -nostartfiles -L$(SGX_LIBRARY_PATH) \
	-Wl,--whole-archive -l$(Trts_Library_Name) -Wl,--no-whole-archive \
	-Wl,--start-group -lsgx_tstdc -lsgx_tcxx -lsgx_tcmalloc -l$(Crypto_Library_Name) -l$(Service_Library_Name) -Wl,--end-group \
	-Wl,-Bstatic -Wl,-Bsymbolic -Wl,--no-undefined \
	-Wl,-pie,-eenclave_entry -Wl,--export-dynamic  \
	-Wl,--defsym,__ImageBase=0 \
	-Wl,--version-script=enclave.lds

enclave_t.c: $(SGX_EDGER8R) enclave.edl
	$(SGX_EDGER8R) --trusted ./enclave.edl --search-path . --search-path $(SGX_SDK)/include
	@echo "GEN  =>  $@"

enclave_t.o: enclave_t.c
	$(CC) $(Enclave_C_Flags) -c $< -o $@
	@echo "CC   <=  $<"

enclave.o: enclave.c
	$(CC) $(CFLAGS) $(Enclave_C_Flags) $(DEFINES) $(INCS) $(DEPS) -c -o $@ $<
	@echo "CC  <=  $<"

$(Enclave_Name): enclave_t.o enclave.o
	$(CC) $^ -o $@ $(Enclave_Link_Flags)
	@echo "LINK =>  $@"

$(Signed_Enclave_Name): $(Enclave_Name)
	$(SGX_ENCLAVE_SIGNER) sign -key enclave_private.pem -enclave $(Enclave_Name) -out $@ -config $(Enclave_Config_File)
	@echo "SIGN =>  $@"

#################################

clean:
	rm -f *.o app
	rm -f enclave_t.c enclave_t.h
	rm -f enclave_u.c enclave_u.h
	rm -f $(Signed_Enclave_Name) $(Enclave_Name)
