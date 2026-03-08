#!/bin/bash
# set -e removed by engine (prevents false failures)

export NEEDRESTART_MODE=a NEEDRESTART_SUSPEND=1 DEBIAN_FRONTEND=noninteractive

LDAP_URI="ldap://localhost"
BASE_DN="dc=antrieb,dc=local"
ADMIN_DN="$APPLICATION_USERNAME"
ADMIN_PASS="$APPLICATION_SECRET"

cat > /tmp/engineering_ou.ldif <<'EOF'
dn: ou=engineering,dc=antrieb,dc=local
objectClass: organizationalUnit
ou: engineering
description: Engineering Department
EOF

cat > /tmp/john_doe.ldif <<'EOF'
dn: uid=john.doe,ou=engineering,dc=antrieb,dc=local
objectClass: inetOrgPerson
objectClass: posixAccount
uid: john.doe
cn: John Doe
sn: Doe
givenName: John
mail: john.doe@antrieb.local
userPassword: {SSHA}password123
uidNumber: 1001
gidNumber: 1001
homeDirectory: /home/john.doe
loginShell: /bin/bash
EOF

cat > /tmp/jane_smith.ldif <<'EOF'
dn: uid=jane.smith,ou=engineering,dc=antrieb,dc=local
objectClass: inetOrgPerson
objectClass: posixAccount
uid: jane.smith
cn: Jane Smith
sn: Smith
givenName: Jane
mail: jane.smith@antrieb.local
userPassword: {SSHA}password456
uidNumber: 1002
gidNumber: 1002
homeDirectory: /home/jane.smith
loginShell: /bin/bash
EOF

echo "Adding organizational unit 'engineering'..."
ldapadd -x -H "$LDAP_URI" -D "$ADMIN_DN" -w "$ADMIN_PASS" -f /tmp/engineering_ou.ldif

echo "Adding user john.doe..."
ldapadd -x -H "$LDAP_URI" -D "$ADMIN_DN" -w "$ADMIN_PASS" -f /tmp/john_doe.ldif

echo "Adding user jane.smith..."
ldapadd -x -H "$LDAP_URI" -D "$ADMIN_DN" -w "$ADMIN_PASS" -f /tmp/jane_smith.ldif

echo ""
echo "=== Searching and listing all users ==="
ldapsearch -x -H "$LDAP_URI" -b "$BASE_DN" -D "$ADMIN_DN" -w "$ADMIN_PASS" "(objectClass=inetOrgPerson)"

echo ""
echo "=== Verification complete ==="
