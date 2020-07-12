class_code = "QJSIM"
tiker = {"AFLT","GAZP","GMKN","SBERP"}--,"TGKBP","INGR","PRMB"}

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
  OPERATION="B",                -- выставление заявки на продажу
  PRICE=nil,                    -- зануление для избежания ошибок компилятора
  QUANTITY=tostring(kolvo),     -- "количество лотов"
  TYPE="L"                      -- тип "лимитированная заявка"
}

function main()
    sendOrder() --выяставление заявок, разово
    while true do
        sleep(3000)
        searchOrder() --обращение к функции для поиска активных заявок
    end
end

function delOrder(id_order,sec_code) --функция для снятия заявок
    local id = 1000 * os.clock()
    id = Round(id)
    transaction["ACTION"] = "KILL_ORDER" --меняем действие на снятие заявки
    transaction["SECCODE"] = tostring(sec_code)
    transaction["TRANS_ID"] = id --id транзакции
    transaction["ORDER_KEY"] = tostring(id_order) --номер ранее выставленной заявки
    res = sendTransaction(transaction)
    return res
end

function sendOrder() --функция для выставления заявок
    for i = #tiker,1,-1 do
        bumaga = tiker[i] --перебор из масива названия бумаг
        local price_min = getParamEx(class_code, bumaga,"LOW").param_image
        transaction["PRICE"] = Round(price_min)
        transaction["SECCODE"] = tostring(bumaga) 
        res = sendTransaction(transaction) --выставляем заявки
    end
    return res
end

function Round(price)                                                                  -- функция на проверку "," в цене
    local start_index = string.find(price,",")                                         -- ищет "," в строке и берем ее индекс
    local price = tonumber(getParamEx(class_code, bumaga,"LOW").param_value)      -- значение "минимальная цена" из "таблица параметров"
    local price_step = getParamEx(class_code, bumaga,"SEC_PRICE_STEP").param_value     -- значение "шаг цены" из "таблица параметров"
        if start_index == nil then                                                     -- проверка: если индекс равен nil, то в бумаге нельзя ставить с дробью, если индекс есть, то бумага дробная
            local step = price/price_step                                              -- высчитывает количество шагов в цене
            local res = step*price_step                                                -- вычистяет цену, умножая шаг цены на количество шагов
            price = math.floor(res)                                                    -- округляет цену, удаляя ноль и запятую в цене, для корректного значения в заявку
        end
return tostring(price)                                                                 -- возвращает price из функции для дальнейшей обработки скрипта
end

function searchOrder() --функция для поиска информации по заявкам. Как она точно работает не могу сказать
    n = getNumberOf("orders") --можно вывести общее кол-во заявок, через message
    order={} --создается пустой массив для сбора всех заявок
    for i=0,n-1 do
        order = getItem("orders", i) --заполнение массива заявками
        flag = order["flags"] --назначаем в переменную флаг заявки
        flag = bit.band(flag,0x1) --преобразуем флаг в бит для проверки
        if flag ~= 0 then --проверям флаг, если 0х1 равен 0, то заявка активна
            delOrder(order["order_num"],order["sec_code"]) --снятие заявки
        --else можно раскоментить, тогда будет спам в виде старых заявок
        --    message("Order NUM: "..order["order_num"].." has been withdrawn (snyata)") --вывод ранее снятых заявок
        end
    end
end
