# Storing and Retrieving Secret in HashiCorp Vault

## Prompt
> Store a secret in HashiCorp Vault at db/postgres with keys host, port, username, and password, then read it back to verify

## Description
This automation task is used to store a secret in a HashiCorp Vault instance at the 'db/postgres' path with keys for 'host', 'port', 'username', and 'password'. It then verifies that the secret can be successfully retrieved from the Vault.

## Files

* `setup.sh`: A shell script that performs the task of storing and retrieving the secret from HashiCorp Vault.

## Iteration History
- Iteration 1 (1): success