class_code = "QJSIM"
--tiker = {"AFLT","GAZP","GMKN","SBERP","TGKBP","INGR","DZRD"}
tiker = {"GMKN","INGR","DZRDP"}

firma = "NC0011100000"          -- фирма из "Позиции по инструментам"
kode_cl = "1907"                -- код клиента из "Позиции по инструментам"
schet_depo = "NL0011100043"     -- счёт депо из "Позиции по инструментам"
trans_id = os.time()
kolvo = 1

transaction = {                 -- выставление заявки
  TRANS_ID=tostring(trans_id),  -- рандомное число
  ACTION="NEW_ORDER",           -- тип "новая заявка"
  CLASSCODE=class_code,         -- "код класса"
  ACCOUNT=schet_depo,           -- "счёт депо"
  CLIENT_CODE=kode_cl,          -- "код клиента"
  SECCODE=nil,                  -- зануление для избежания ошибок компилятора
  OPERATION="B",                -- зануление для избежания ошибок компилятора
  PRICE=nil,                    -- зануление для избежания ошибок компилятора
  QUANTITY=tostring(kolvo),     -- "количество лотов"
  TYPE="L"                      -- тип "лимитированная заявка"
}

function Round(price)
    local start_index = string.find(price,",")                                                --Ищем , в строке и берем ее индекс
    local price = tonumber(getParamEx (class_code, bumaga, "LAST").param_value)
    local price_step = getParamEx (class_code, bumaga, "SEC_PRICE_STEP").param_value 
    if start_index == nil then                                                          --Делаем проверку: если индекса нет, значит в бумаге нельзя ставить с дробью, если индекс есть, то бумага дробная
        local step = price / price_step
        local res = step * price_step
        price = math.floor(res)
    end
    return tostring(price)
end

function main ()
    while true do
        sleep(5000)
        for i = #tiker,1,-1 do
            bumaga = tiker[i]
            last = Round(getParamEx (class_code, bumaga, "LAST").param_image)           --Берем строковое значение последней цены из таблицы с ,
            message(last)
            transaction["PRICE"] = tostring(last)                          -- подставление: цена покупки из массива
            transaction["SECCODE"] = tostring(bumaga)
            res = sendTransaction(transaction)     
        end
    end
end