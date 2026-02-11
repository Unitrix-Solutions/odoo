#!/bin/bash

ORIGINAL_CONF="debian/odoo.conf"
GENERATED_CONF="/app/odoo.conf"

cp "$ORIGINAL_CONF" "$GENERATED_CONF"

cat >> "$GENERATED_CONF" <<EOF

[options]
db_host = ${ODOO_DB_HOST:-db}
db_port = ${ODOO_DB_PORT:-5432}
db_user = ${ODOO_DB_USER:-odoo}
db_password = ${ODOO_DB_PASSWORD:-odoo_password}
db_name = ${ODOO_DB_NAME:-odoo}
admin_passwd = ${ODOO_ADMIN_PASS:-admin123}
xmlrpc_port = 8069
logfile = /var/log/odoo/odoo.log
addons_path = addons,/usr/lib/python3/dist-packages/odoo/addons
EOF

echo "Generated runtime config at $GENERATED_CONF"

exec ./odoo-bin -c "$GENERATED_CONF"
