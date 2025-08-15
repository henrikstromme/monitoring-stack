health_check() {
  local service_name=$1
  local service_url=$2
  echo "Starting health check for $service_name at $service_url"

  for i in {1..10}; do
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$service_url" || true)
    if [ "$STATUS_CODE" == "200" ]; then
      echo "$service_name is healthy."
      return 0
    fi
    echo "$service_name not ready yet... (Attempt $i, Status $STATUS_CODE)"
    sleep 5
  done

  echo "Health check failed for $service_name after 10 attempts."
  return 1
}