#!/bin/bash

echo "Insira uma lista de endereços IP separados por espaço:"
read ip_list

for ip in $ip_list; do
    echo ""
    echo "Consultando a reputação do endereço IP $ip..."
    response=$(curl -s "https://api.abuseipdb.com/api/v2/check?ipAddress=$ip" \
        -H "Key: YOUR-API-KEY>
        -H "Accept: application/json")
    if [[ "$response" =~ "error" ]]; then
        echo "Erro ao consultar a API para o endereço IP $ip."
    else
        is_suspicious=$(echo $response | jq '.data.abuseConfidenceScore >= 1')
        if [[ "$is_suspicious" == "true" ]]; then
            url=$(echo "https://www.abuseipdb.com/check/$ip")
            echo "URL de consulta no site abuseipdb.com para o endereço IP $ip: $url"
            echo "$url" >> urls.txt
        else
            echo "O endereço IP $ip não tem má reputação no site www.abuseipdb.com."
        fi
    fi
done
