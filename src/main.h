#ifndef TESTMAIN_H_
#define TESTMAIN_H_

#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>

/*************/
/* Intel SGX */

#include "sgx_error.h"       /* sgx_status_t */
#include "sgx_eid.h"     /* sgx_enclave_id_t */

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

# define TOKEN_FILENAME   "enclave.token"
# define ENCLAVE_FILENAME "enclave.signed.so"

#define MAX_PATH 256
/*************/


// =========================================================
/*
 * Add here any new function you define inside the enclave
 */

// Need ocalls for printf
int ocall_printf(const char* buf);


// =========================================================

#endif
