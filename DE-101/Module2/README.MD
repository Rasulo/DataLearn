<h1>Модуль 2</h1>
<h2>2.1 - 2.3</h2>
<h2>2.4 Модели данных</h2>
Описание моих файлов в этом модуле:
<li>orders.sql/people.sql/returns.sql - исходные файлы (DDL). (п.2 с практики)</li>
<li>orders_query_sql - файл с запросами для получения метрик с нормализованной таблицы orders_final_table, полученной путем соединения таблиц people и returns к orders (п.3 с практики)</li>
<li>create_DM_of_superstore.sql - создание таблиц для модели данных (рисунок схемы ниже) с использованием DDL</li>

<h3>Модель данных для файлика Superstore</h3>
За основу архитектуры БД взята модель Инмана по схеме "Звезда" (в нашем случае с источника все данные падают в нормализованную таблицу orders (в моем случае orders_final_table), которую мы разбиваем на таблицу фактов и измерений).
<br/>
<br/>
<img src="https://raw.githubusercontent.com/Rasulo/DataLearn/refs/heads/main/DE-101/Module2/DimensionalModelofSuperstore.png">
Разработано 5 таблиц измерений:
<br/>
<li>Calendar - содержит данные о дате заказа, доставки и колонки с разделением на год, месяц и день по дате заказа.</li>
<li>Product_dim - содержит данные о категории и подкатегории продукта/товара.</li>
<li>Shipping_dim - содержит данные о типе доставки.</li>
<li>Customer_dim - содержит данные о покупателе: ФИО, сегмент покупателя.</li>
<li>Geo_dim - содержит данные о месте получения заказа.</li>
<br/>
Таблица фактов состоит из ключей вышеперечисленных 5 таблиц измерений + статистических данных (прибыль, скидка и пр.).
<br/>
Файлик с DDL расположен здесь: https://github.com/Rasulo/DataLearn/blob/main/DE-101/Module2/create_DM_of_superstore.sql
<h2>2.5 База данных в облаке</h2>
В качестве облачного хранилища я взял облачный сервис Clever Cloud (https://www.clever-cloud.com/) с максимальным размером 256 MB. С помощью клиента DBeaver в облаке были созданы таблица исходных данных (Stage), таблица фактов и измерений (DW). 
<h2>2.6 Как донести данные до бизнес-пользователя)</h2>
Для создания дашбордов, с целью отслеживания различных метрик, я взял сервис Yandex DataLens, который подключается к источнику всех stage и DW таблиц - Clever Cloud.
Метрики я разделил на следующие виды:
<ul>
<li>Key Metrics (ссылка к дашборду: https://datalens.yandex/qgrew1z3hlh4c) - ключевые метрики (с таблицы фактов), которые показывают сводные данные по всем ключевым показателям.</li>
<li>Product Metrics (ссылка к дашборду: https://datalens.yandex/ukvitu7vbk48g) - метрики для демонстрации статистических показателей по различным характеристикам продукта.</li>
<li>Customer Metrics (ссылка к дашборду: https://datalens.yandex/yovo1viqcfgsk) - метрики, показывающие информацию по покупателям.</li>
</ul>
<b>Скрины с дашбордов:</b>
<br/>
Key Metrics
<br/>
<br/>
<img src="https://raw.githubusercontent.com/Rasulo/DataLearn/refs/heads/main/DE-101/Module2/KeyMetrics.png">
Product Metrics
<br/>
<br/>
<img src="https://raw.githubusercontent.com/Rasulo/DataLearn/refs/heads/main/DE-101/Module2/ProductMetrics.png">
Customer Metrics
<br/>
<br/>
<img src="https://raw.githubusercontent.com/Rasulo/DataLearn/refs/heads/main/DE-101/Module2/CustomerMetrics.png">
