#!/bin/bash
set -e

PROM_URL="http://localhost:9090"
GRAFANA_URL="http://localhost:3000"
ALERT_URL="http://localhost:9093"

echo "Checking Prometheus..."
curl -sf $PROM_URL/-/ready || { echo "Prometheus not ready"; exit 1; }

echo "Checking Grafana..."
curl -sf $GRAFANA_URL/login || { echo "Grafana not reachable"; exit 1; }

echo "Checking Alertmanager..."
curl -sf $ALERT_URL/-/ready || { echo "Alertmanager not ready"; exit 1; }

# Optional — check if webapp is up in Prometheus targets
WEBAPP_TARGETS=$(curl -s $PROM_URL/api/v1/targets | grep -c 'webapp')
if [ "$WEBAPP_TARGETS" -gt 0 ]; then
    echo "Webapp target found in Prometheus."
else
    echo "WARNING: No webapp target found in Prometheus."
fi

echo "All checks complete."
