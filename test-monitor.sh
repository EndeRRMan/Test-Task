#!/bin/bash

# Куда писать логи (по заданию)
LOG_FILE="/var/log/monitoring.log"
# Какой URL проверять (по заданию)
URL="https://test.com/monitoring/test/api"
# Какой процесс мы мониторим (по заданию)
PROCESS_NAME="test"

# Функция для записи в лог
# Принимает один аргумент - сообщение
write_log() {
    # date - текущая дата и время
    # $1 - первое, что передали в функцию
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE
}

# Создаем лог-файл, если его нет
touch $LOG_FILE

# Переменная для хранения предыдущего PID
last_pid=""

# Бесконечный цикл (каждые 60 секунд)
while true; do
    # Ищем PID процесса:
    # pgrep - ищет процессы по имени
    # -o - берет самый старый (первый) процесс
    current_pid=$(pgrep -o $PROCESS_NAME)

    # Если процесс нашелся (current_pid не пустой)
    if [ -n "$current_pid" ]; then
        # Если у нас был старый PID и он изменился
        if [ -n "$last_pid" ] && [ "$current_pid" != "$last_pid" ]; then
            write_log "Процесс $PROCESS_NAME перезапущен (был $last_pid, стал $current_pid)"
        fi

        # Проверяем доступность сервера:
        # curl - утилита для HTTP-запросов
        # -s - тихий режим (без лишнего вывода)
        # -o /dev/null - не сохранять результат
        # -w "%{http_code}" - показать только код ответа
        # --max-time 5 - таймаут 5 секунд
        http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 $URL)

        # Если код ответа не 200
        if [ "$http_code" != "200" ]; then
            write_log "Сервер мониторинга недоступен (код $http_code)"
        fi

        # Запоминаем текущий PID для следующей проверки
        last_pid=$current_pid
    fi

    # Ждем 60 секунд перед следующей проверкой
    sleep 60
donex
