FROM python:3.12-slim-bookworm

LABEL maintainer="Unitrix Solutions"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install system dependencies required by Odoo
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    fonts-noto-cjk \
    gcc \
    git \
    gsfonts \
    libffi-dev \
    libgeoip-dev \
    libjpeg62-turbo-dev \
    libldap2-dev \
    libpq-dev \
    libsasl2-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    node-less \
    npm \
    postgresql-client \
    python3-dev \
    python3-num2words \
    python3-pdfminer \
    python3-pip \
    python3-phonenumbers \
    python3-pyldap \
    python3-qrcode \
    python3-renderpm \
    python3-setuptools \
    python3-slugify \
    python3-vobject \
    python3-watchdog \
    python3-xlrd \
    python3-xlwt \
    xfonts-75dpi \
    xfonts-base \
    xz-utils \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install wkhtmltopdf (needed for PDF reports)
RUN curl -o /tmp/wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends /tmp/wkhtmltox.deb \
    && rm -f /tmp/wkhtmltox.deb \
    && rm -rf /var/lib/apt/lists/*

# Install rtlcss for RTL support
RUN npm install -g rtlcss

# Create odoo user (avoid running as root)
RUN useradd -m -d /app -s /bin/bash odoo

# Set working directory
WORKDIR /app

# Copy requirements first (for Docker layer caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt

# Copy the rest of the application
COPY . .

# Create necessary directories and set ownership
RUN mkdir -p /var/log/odoo /var/lib/odoo \
    && chown -R odoo:odoo /var/log/odoo /var/lib/odoo /app \
    && chmod +x generate_odoo_conf.sh \
    && chmod +x odoo-bin

# Switch to non-root user
USER odoo

# Expose Odoo ports
EXPOSE 8069
EXPOSE 8072

# Run Odoo via the config generator script
CMD ["bash", "generate_odoo_conf.sh"]
