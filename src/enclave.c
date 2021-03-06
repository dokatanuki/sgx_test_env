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
  int ret = sgx_is_within_enclave(&ecall_entrypoint, sizeof(ecall_entrypoint));
	my_printf("%s: address=%p\n", __func__, ecall_entrypoint);
	my_printf("%s: sgx_is_within_enclave=%d\n", __func__, ret);
	my_printf("Hello World!\n");
}

