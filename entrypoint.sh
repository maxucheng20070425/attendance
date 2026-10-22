#!/bin/bash
# Render injects the PORT environment variable. Tomcat listens on
# 8080 by default, so patch server.xml before startup when PORT is set.
if [ -n "$PORT" ] && [ "$PORT" != "8080" ]; then
  sed -i "s/port=\"8080\"/port=\"$PORT\"/" "$CATALINA_HOME/conf/server.xml"
fi

# Render probes every open port in the container, and the 8005 shutdown
# port only produces "Invalid shutdown command" warnings in the log.
# Tomcat accepts port="-1" to disable the shutdown listener.
sed -i "s/port=\"8005\"/port=\"-1\"/" "$CATALINA_HOME/conf/server.xml"

exec "$CATALINA_HOME/bin/catalina.sh" run
