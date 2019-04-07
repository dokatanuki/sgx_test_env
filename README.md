# SGX Test Environment Using Intel SGX SDK

## Requirements
- docker
- docker-compose
- docker-machine
- VirtualBox

## Quickstart
### Setup docker machine
```
$ docker-machine create --driver virtualbox test
```

### Build and execute sgx program
```
$ docker-compose up -d
$ docker-compose exec sgx make build
$ docker-compose exec sgx make execute
```
