develop:
	@while true; do sleep 60; done

build:
	@bash -c "source /sgx/sgxsdk/environment;cd src; make SGX_MODE=SIM"

clean:
	@cd src; make SGX_MODE=SIM clean

execute:
	@bash -c "source /sgx/sgxsdk/environment;cd src; ./app"

sgx-gdb:
	@bash -c "source /sgx/sgxsdk/environment;cd src; sgx-gdb app"
