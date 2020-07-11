class_code = "QJSIM"
tiker = {"SBER"}

firma = "NC0011100000"          -- фирма из "Позиции по инструментам"
kode_cl = "1907"                -- код клиента из "Позиции по инструментам"
schet_depo = "NL0011100043"     -- счёт депо из "Позиции по инструментам"
trans_id = os.time()
kolvo = 1
price = 203.12

transaction = {                 -- выставление заявки
  TRANS_ID=tostring(trans_id),  -- рандомное число
  ACTION="NEW_ORDER",           -- тип "новая заявка"
  CLASSCODE=class_code,         -- "код класса"
  ACCOUNT=schet_depo,           -- "счёт депо"
  CLIENT_CODE=kode_cl,          -- "код клиента"
  SECCODE=nil,                  -- зануление для избежания ошибок компилятора
  OPERATION="B",                -- зануление для избежания ошибок компилятора
  PRICE=tostring(price),                    -- зануление для избежания ошибок компилятора
  QUANTITY=tostring(kolvo),     -- "количество лотов"
  TYPE="L"                      -- тип "лимитированная заявка"
}

function main()
        for i = #tiker,1,-1 do
            bumaga = tiker[i]                  
            transaction["SECCODE"] = tostring(bumaga)
            res = sendTransaction(transaction)     
        end
end