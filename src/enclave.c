#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#include "enclave.h"
#include "enclave_t.h"


// =========================================================
/*
 * Add here any new function you define inside the enclave
 */

int my_printf(const char* format, ...) {
	char buf[BUFSIZ] = {'\0'};
	va_list ap;
	va_start(ap, format);
	vsnprintf(buf, BUFSIZ, format, ap);
	va_end(ap);
	int r;
	sgx_status_t ret = ocall_printf(&r, buf);
	if (ret != SGX_SUCCESS) {
		//there was a problem during the ocall
	}
	return r;
}



// =========================================================

void ecall_entrypoint() {
	//TODO: fix the compilation problem with printf
	my_printf("Hello World!\n");
}

