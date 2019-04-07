#include "enclave_u.h"
#include <errno.h>

typedef struct ms_ocall_printf_t {
	int ms_retval;
	const char* ms_buf;
} ms_ocall_printf_t;

static sgx_status_t SGX_CDECL enclave_ocall_printf(void* pms)
{
	ms_ocall_printf_t* ms = SGX_CAST(ms_ocall_printf_t*, pms);
	ms->ms_retval = ocall_printf(ms->ms_buf);

	return SGX_SUCCESS;
}

static const struct {
	size_t nr_ocall;
	void * table[1];
} ocall_table_enclave = {
	1,
	{
		(void*)enclave_ocall_printf,
	}
};
sgx_status_t ecall_entrypoint(sgx_enclave_id_t eid)
{
	sgx_status_t status;
	status = sgx_ecall(eid, 0, &ocall_table_enclave, NULL);
	return status;
}

