#!/bin/bash

GENERATED_CONF="/app/odoo.conf"

# Generate a clean config file (single [options] section)
cat > "$GENERATED_CONF" <<EOF
[options]
db_host = ${ODOO_DB_HOST:-db}
db_port = ${ODOO_DB_PORT:-5432}
db_user = ${ODOO_DB_USER:-odoo}
db_password = ${ODOO_DB_PASSWORD:-odoo_password}
db_name = ${ODOO_DB_NAME:-odoo}
admin_passwd = ${ODOO_ADMIN_PASS:-admin123}
http_port = 8069
longpolling_port = 8072
logfile = /var/log/odoo/odoo.log
addons_path = /app/addons
default_productivity_apps = True
EOF

echo "Generated runtime config at $GENERATED_CONF"

exec ./odoo-bin -c "$GENERATED_CONF"
