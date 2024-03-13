# Запуск ollama serve и запись логов в файл
nohup ollama serve > ollama-serv.log 2>&1 &

echo "Running Ollama..."

# Ожидание, пока ollama serve полностью загрузится
while [[ "$(curl -s -o /dev/null -w '%{http_code}\n' "localhost:11434")" != "200" ]]; do
    sleep 1
done

echo "...Ollama run successfully!"
sleep 3

# Загрузка модели для ollama run llama2
echo "Downloading model for Ollama..."
nohup ollama run llama2 > ollama-run.log 2>&1 &

# Ожидание, пока ollama run llama2 полностью загрузится
echo "Waiting model llama2 to start..."
attempt=1
while [[ $attempt -le 180 ]]; do
    response=$(curl -s -o /dev/null -w '%{http_code}\n' "http://localhost:11434/api/generate" -d '{"model": "llama2", "prompt":"Some"}')
    if [[ "$response" == "200" ]]; then
        echo "ollama run llama2 started successfully!"
        break
    fi
    sleep 5
    attempt=$((attempt + 5))
done

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