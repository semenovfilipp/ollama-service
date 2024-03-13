# Запуск ollama serve и запись логов в файл
nohup ollama serve > ollama-serv.log 2>&1 &

echo "Running Ollama..."

# Ожидание, пока ollama serve полностью загрузится
while [ "$(curl -s -o /dev/null -w '%{http_code}\n' "localhost:11434")" != "200" ]; do
    echo "Waiting for ollama serve to start..."
    sleep 1
done

echo "...Ollama run successfully!"
sleep 3

# Загрузка модели для ollama run llama2
echo "Downloading model for Ollama..."
nohup ollama run llama2 > ollama-run.log 2>&1 &

# Ожидание, пока ollama run llama2 начнет загрузку
echo "Waiting for model llama2 to start..."
attempt=1
while [ $attempt -le 600 ]; do
    current_status=$(tail -n 1 ollama-run.log)  # Читаем последнюю строку из лога ollama-run
    echo "$current_status"  # Выводим статус загрузки в консоль

    # Проверка, началась ли загрузка модели
    if echo "$current_status" | grep -q "Downloading model..."; then
        echo "Model loading started."
        break
    fi

    sleep 1
    attempt=$((attempt + 1))
done

# Ожидание, пока ollama run llama2 полностью загрузится
echo "Waiting for model llama2 to finish downloading..."
attempt=1
while [ $attempt -le 180 ]; do
    response=$(curl -s -o /dev/null -w '%{http_code}\n' "http://localhost:11434/api/generate" -d '{"model": "llama2", "prompt":"Some"}')
    if [ "$response" = "200" ]; then
        echo "ollama run llama2 started successfully!"
        break
    fi
    sleep 1
    attempt=$((attempt + 1))
done

# Если загрузка не удалась за отведенное время, выводим сообщение об ошибке
if [ $attempt -gt 180 ]; then
    echo "Failed to start ollama run llama2."
fi




# Запуск Java
echo "Starting Java..."
java -cp '*:lib/*' OllamaServiceKt




#nohup ollama serve > /dev/null 2>&1 &
#nohup ollama run llama2 > /dev/null 2>&1 &
#java -cp '*:lib/*' OllamaServiceKt



#+++++++++
## Запуск ollama serve и ожидание его полной загрузки
#nohup ollama serve > /dev/null 2>&1 &
#
## Ожидание, пока ollama serve полностью загрузится
#while [[ "$(curl -s -o /dev/null -w '%{http_code}\n' $ES_URL)" != "200" ]]; do
#    sleep 1
#done
#
## После того как ollama serve загружен, запуск ollama run llama2
#nohup ollama run llama2 > /dev/null 2>&1 &
#
#
##подождать пока run закончит все действия перед bash
##bash
## вывести ошибки в файл (что бы они не терялись в dev/null)
#
## после того как все запустилось и скачалось нужно запустить процессы olloma-service
#
#java -cp '*:lib/*' OllamaServiceKt





#-------------------
#nohup ollama serve > /dev/null 2>&1 &
#sleep 5
#nohup ollama run llama2 > /dev/null 2>&1 &





## Загрузка модели для ollama run llama2
#echo "Downloading model for Ollama..."
#nohup ollama run llama2 > ollama-run.log 2>&1 &
#
## Ожидание, пока ollama run llama2 полностью загрузится
#echo "Waiting model llama2 to start..."
#while :; do
#    current_status=$(tail -n 1 ollama-run.log)  # Читаем последнюю строку из лога ollama-run
#    echo "$current_status"  # Выводим статус загрузки в консоль
#    # shellcheck disable=SC2081
#    if [ "$current_status" = *"100%"* ]; then  # Если статус содержит "100%"
#        echo "ollama run llama2 загрузилась на 100%!"
#        break  # Выходим из цикла
#    fi
#    sleep 5  # Подождать перед следующей проверкой статуса
#done
#echo "...Ollama model running llama2 successfully!"


## Загрузка модели для ollama run llama2
#echo "Downloading model for Ollama..."
#nohup ollama run llama2 > ollama-run.log 2>&1 &
#
## Ожидание, пока ollama run llama2 полностью загрузится
#echo "Waiting model llama2 to start..."
#attempt=1
#while [[ $attempt -le 180 ]]; do
#    response=$(curl -s -o /dev/null -w '%{http_code}\n' "http://localhost:11434/api/generate" -d '{"model": "llama2", "prompt":"Some"}')
#    if [[ "$response" == "200" ]]; then
#        echo "ollama run llama2 started successfully!"
#        break
#    fi
#    sleep 5
#    attempt=$((attempt + 5))
#done