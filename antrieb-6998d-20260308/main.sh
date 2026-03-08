#!/bin/bash
# set -e removed by engine (prevents false failures)

export NEEDRESTART_MODE=a NEEDRESTART_SUSPEND=1 DEBIAN_FRONTEND=noninteractive

BASE_DN="dc=antrieb,dc=local"
ADMIN_DN="$APPLICATION_USERNAME"
ADMIN_PASS="$APPLICATION_SECRET"
LDAP_URI="ldap://localhost"

echo "Creating organizational unit 'engineering'..."
cat > /tmp/engineering_ou.ldif <<'EOF'
dn: ou=engineering,dc=antrieb,dc=local
objectClass: organizationalUnit
ou: engineering
description: Engineering Department
EOF

ldapadd -x -H "$LDAP_URI" -D "$ADMIN_DN" -w "$ADMIN_PASS" -f /tmp/engineering_ou.ldif

echo "Creating user john.doe..."
cat > /tmp/john_doe.ldif <<'EOF'
dn: uid=john.doe,ou=engineering,dc=antrieb,dc=local
objectClass: inetOrgPerson
objectClass: posixAccount
uid: john.doe
cn: John Doe
sn: Doe
givenName: John
mail: john.doe@antrieb.local
uidNumber: 1001
gidNumber: 1001
homeDirectory: /home/john.doe
loginShell: /bin/bash
userPassword: {SSHA}password123
EOF

ldapadd -x -H "$LDAP_URI" -D "$ADMIN_DN" -w "$ADMIN_PASS" -f /tmp/john_doe.ldif

echo "Creating user jane.smith..."
cat > /tmp/jane_smith.ldif <<'EOF'
dn: uid=jane.smith,ou=engineering,dc=antrieb,dc=local
objectClass: inetOrgPerson
objectClass: posixAccount
uid: jane.smith
cn: Jane Smith
sn: Smith
givenName: Jane
mail: jane.smith@antrieb.local
uidNumber: 1002
gidNumber: 1002
homeDirectory: /home/jane.smith
loginShell: /bin/bash
userPassword: {SSHA}password456
EOF

ldapadd -x -H "$LDAP_URI" -D "$ADMIN_DN" -w "$ADMIN_PASS" -f /tmp/jane_smith.ldif

echo ""
echo "=== Verifying: Searching all users in engineering OU ==="
ldapsearch -x -H "$LDAP_URI" -b "ou=engineering,$BASE_DN" -D "$ADMIN_DN" -w "$ADMIN_PASS" "(objectClass=inetOrgPerson)"

echo ""
echo "=== Verifying: Listing all entries in LDAP directory ==="
ldapsearch -x -H "$LDAP_URI" -b "$BASE_DN" -D "$ADMIN_DN" -w "$ADMIN_PASS" -LLL

echo ""
echo "Setup complete. Engineering OU created with users john.doe and jane.smith."
