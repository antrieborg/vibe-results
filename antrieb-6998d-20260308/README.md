## OpenLDAP User Automation
### Add Engineering Users with Verification

> ```bash
>  ## Task
>  Add an organizational unit called engineering in OpenLDAP and create two users john.doe and jane.smith under it, then search and list all users to verify. The credentials to access the LDAP server are in the OS env variables $APPLICATION_USERNAME and $APPLICATION_SECRET
> ```

This script automates the process of adding a new organizational unit called "engineering" to OpenLDAP and creating two users, john.doe and jane.smith, under it. It also searches for and lists all users in the system for verification.

### Files

* `main.sh`: The main script that executes the LDAP automation task.

### Iteration History

* Iteration 1 (1): success