# Este script se ejecutaría en el servidor on-premise para convertirlo en el nuevo master.
# ======================================================================================
#!/bin/bash
set -e

echo "Promocionando esta base de datos a primario..."
# pg_promote es la forma moderna y segura de hacerlo.
# Reemplaza la ruta si tu binario está en otro lugar.
/usr/lib/postgresql/15/bin/pg_promote

echo "¡Promoción completada! Esta base de datos ahora acepta escrituras."
echo "Recuerda actualizar la configuración de tu aplicación para que apunte aquí."
