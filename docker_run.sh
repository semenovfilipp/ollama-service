nohup ollama serve > ollama_serve.log 2>&1 &

while [[ "$(curl -s -o /dev/null -w '%{http_code}\n' $ES_URL)" != "200" ]]; do
    sleep 1
done

nohup ollama run $OLLAMA_MODEL > ollama_run_${OLLAMA_MODEL}.log 2>&1 &

wait

java -cp '*:lib/*' OllamaServiceKt




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