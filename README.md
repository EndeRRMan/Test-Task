# Скрипт для тестового задания

Мониторинг процесса `test` с отправкой HTTP-запросов и логированием.

## Установка
```bash
# Скопируйте файлы
sudo cp scripts/test-monitor.sh /usr/local/bin/
sudo cp systemd/test-monitor.service /etc/systemd/system/
sudo cp logrotate/test-monitor /etc/logrotate.d/

# Дайте права
sudo chmod +x /usr/local/bin/test-monitor.sh
sudo chmod 644 /etc/systemd/system/test-monitor.service

# Запустите сервис
sudo systemctl daemon-reload
sudo systemctl enable --now test-monitor
```

## Логи
Логи сохраняются в `/var/log/monitoring.log`:

