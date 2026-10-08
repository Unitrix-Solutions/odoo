#!/bin/bash

GENERATED_CONF="/app/odoo.conf"

cat > "$GENERATED_CONF" <<EOF
[options]
db_host = ${ODOO_DB_HOST}
db_port = ${ODOO_DB_PORT:-}
db_user = ${ODOO_DB_USER:-}
db_password = ${ODOO_DB_PASSWORD}
db_name = ${ODOO_DB_NAME:-}
admin_passwd = ${ODOO_ADMIN_PASS:-}
http_port = 8069
longpolling_port = 8072
logfile = /var/log/odoo/odoo.log
addons_path = /app/addons
default_productivity_apps = True
EOF

echo "Generated runtime config at $GENERATED_CONF"
echo "PostgreSQL host: ${ODOO_DB_HOST}"
echo "PostgreSQL port: ${ODOO_DB_PORT:-}"
echo "PostgreSQL user: ${ODOO_DB_USER:-}"

exec ./odoo-bin -c "$GENERATED_CONF"
