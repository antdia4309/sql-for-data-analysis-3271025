# Wait for MariaDB instead of assuming a fixed startup time.
for attempt in $(seq 1 60); do
  if mysqladmin ping -h 127.0.0.1 -uroot -pmariadb --silent; then
    break
  fi
  if [ "$attempt" -eq 60 ]; then
    echo "MariaDB did not become ready in time." >&2
    exit 1
  fi
  sleep 2
done

if [ -f .devcontainer/setup-mariadb.sql ]; then
  mysql -h 127.0.0.1 -uroot -pmariadb < .devcontainer/setup-mariadb.sql
fi

if [ -f .devcontainer/H_Plus_Sports_MySQL.sql ]; then
  mysql -h 127.0.0.1 -uroot -pmariadb < .devcontainer/H_Plus_Sports_MySQL.sql
fi
