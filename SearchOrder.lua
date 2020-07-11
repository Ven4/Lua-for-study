class_code = "TQBR"
transaction = {                 -- выставление заявки
  TRANS_ID=nil,  -- рандомное число
  ACTION=nil,           -- тип "новая заявка"
  CLASSCODE=class_code,         -- "код класса"
  ACCOUNT=schet_depo,           -- "счёт депо"
  CLIENT_CODE=kode_cl,          -- "код клиента"
  SECCODE=nil,                  -- зануление для избежания ошибок компилятора
  OPERATION=nil,                -- зануление для избежания ошибок компилятора
  PRICE=nil,                    -- зануление для избежания ошибок компилятора
  QUANTITY=tostring(kolvo),     -- "количество лотов"
  TYPE="L"                      -- тип "лимитированная заявка"
}

function main()
   while true do
       sleep(3000)
       res = searchOrder()
       message("Num: "..res["order_num"]..
                "Flag: "..res["flags"]
            )
   end
end

function searchOrder()
    n = getNumberOf("orders")
    order={}
    --message("total ".. tostring(n) .." of all orders ", 1)
    for i=0,n-1 do
        order = getItem("orders", i)
       -- message("order: num= " .. 
       -- tostring(order["order_num"]) .. "qty= " ..
       -- tostring(order["qty"]) .. " value= " .. 
       -- tostring(order["value"]), 1)
    end
    return order
end