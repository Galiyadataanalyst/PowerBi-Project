## Проверка данных
-- Количество заказов
SELECT COUNT(*) AS orders_count FROM public_orders;
-- Количество продаж
SELECT COUNT(*) AS sales_count FROM public_sales;
-- Диапазон дат заказов
SELECT MIN(order_date) AS min_order_date, MAX(order_date) AS max_order_date FROM public_orders;
-- Диапазон дат продаж
SELECT MIN(sale_date) AS min_sale_date, MAX(sale_date) AS max_sale_date FROM public_sales;
##обнаружена единичная запись с датой 2026-03-10 и отсутствующим client_id, выходящая за анализируемый период.
SELECT * FROM public_orders WHERE client_id IS NULL;# заказ юез клиента

## Проверка согласованности сумм
SELECT  SUM(o.total_amount) AS orders_total,
        SUM(s.quantity * i.price) AS items_total
FROM public_orders o JOIN public_sales s ON o.order_id = s.order_id
JOIN public_items i ON s.item_id = i.item_id;

##Проверка возможности расчёта прибыли
SELECT SUM(i.price * s.quantity) AS calculated_amount, SUM(o.total_amount) AS order_amount
FROM public_sales s  JOIN public_items i ON s.item_id=i.item_id
JOIN public_orders o ON s.order_id=o.order_id;
##Расчёт прибыли невозможен, так как стоимость товаров не соответствует сумме заказов.

##Проверка структуры таблицы логистики
SELECT * FROM tariffs_and_shipping LIMIT 20; 
## Таблица содержит справочные тарифыи не связана с фактическими заказами.
##Поэтому логистические расходы рассчитать невозможно.

/*
Выявленные ограничения данных:

1. Несогласованность сумм между orders и sales.
2. Аномальная дата заказа.
3. Невозможность расчёта прибыли.
4. Отсутствие фактических данных по логистике.

Эти ограничения были учтены при построении Power BI отчёта.
*/