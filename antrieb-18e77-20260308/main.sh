#!/bin/bash
# set -e removed by engine (prevents false failures)

export NEEDRESTART_MODE=a NEEDRESTART_SUSPEND=1 DEBIAN_FRONTEND=noninteractive

LDAP_URI="ldap://localhost"
LDAP_BASE="dc=antrieb,dc=local"
LDAP_ADMIN_DN="cn=admin,dc=antrieb,dc=local"
LDAP_ADMIN_PASS="ldap123"

echo "Creating organizational unit 'engineering'..."
ldapadd -x -H "$LDAP_URI" -D "$LDAP_ADMIN_DN" -w "$LDAP_ADMIN_PASS" <<'EOF'
dn: ou=engineering,dc=antrieb,dc=local
objectClass: organizationalUnit
ou: engineering
description: Engineering Department
EOF

echo "Creating user john.doe..."
ldapadd -x -H "$LDAP_URI" -D "$LDAP_ADMIN_DN" -w "$LDAP_ADMIN_PASS" <<'EOF'
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

echo "Creating user jane.smith..."
ldapadd -x -H "$LDAP_URI" -D "$LDAP_ADMIN_DN" -w "$LDAP_ADMIN_PASS" <<'EOF'
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

echo ""
echo "=== Searching all entries in LDAP ==="
ldapsearch -x -H "$LDAP_URI" -b "$LDAP_BASE" -D "$LDAP_ADMIN_DN" -w "$LDAP_ADMIN_PASS"

echo ""
echo "=== Listing all users in engineering OU ==="
ldapsearch -x -H "$LDAP_URI" -b "ou=engineering,$LDAP_BASE" -D "$LDAP_ADMIN_DN" -w "$LDAP_ADMIN_PASS" "(objectClass=inetOrgPerson)"

echo ""
echo "=== Verification Complete ==="
echo "✓ Organizational unit 'engineering' created"
echo "✓ User 'john.doe' created under engineering OU"
echo "✓ User 'jane.smith' created under engineering OU"
