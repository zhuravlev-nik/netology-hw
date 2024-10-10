# Домашнее задание к занятию "`Индексы`" - `Журавлев Николай`

### Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.

### Решение 1

```sql
SELECT 
    (SUM(index_length) * 100.0 / SUM(data_length + index_length)) AS index_to_table_ratio
FROM 
    information_schema.tables
WHERE 
    table_schema = 'sakila'; 
```

---

### Задание 2

Выполните explain analyze следующего запроса:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
- перечислите узкие места;
- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.

### Решение 2
* Использование таблицы film без условия (и вообще ее использование, т.к. никакой смысловой нагрузки она не несет, как и таблица inventory, в использовании данных из этих таблиц нет необходимости).
* Использование over partition by - добавляет сортировку по большому количеству данных, избежать которой мы можем при применении group by. Благодаря этому мы также можем убрать distinct.

#### Оптимизированный запрос
```sql
select concat(c.last_name, ' ', c.first_name), sum(p.amount)
from payment p, rental r, customer c
where
    date(p.payment_date) = '2005-07-30'
    and p.payment_date = r.rental_date
    and r.customer_id = c.customer_id
GROUP by c.customer_id;
```
#### EXPLAIN ANALIZE нового запроса
```
-> Table scan on <temporary>  (actual time=42.3..42.4 rows=391 loops=1)
    -> Aggregate using temporary table  (actual time=42.3..42.3 rows=391 loops=1)
        -> Nested loop inner join  (cost=24544 rows=16284) (actual time=0.329..39.2 rows=642 loops=1)
            -> Nested loop inner join  (cost=18845 rows=16284) (actual time=0.298..35.3 rows=642 loops=1)
                -> Filter: (cast(p.payment_date as date) = '2005-07-30')  (cost=1633 rows=16086) (actual time=0.242..27.8 rows=634 loops=1)
                    -> Table scan on p  (cost=1633 rows=16086) (actual time=0.188..21.9 rows=16044 loops=1)
                -> Covering index lookup on r using rental_date (rental_date=p.payment_date)  (cost=0.969 rows=1.01) (actual time=0.00874..0.0113 rows=1.01 loops=634)
            -> Single-row index lookup on c using PRIMARY (customer_id=r.customer_id)  (cost=0.25 rows=1) (actual time=0.00533..0.00541 rows=1 loops=642)
```

Также можно добавить составной индекс в таблице payment по атрибутам payment_date + amount (убирает table scan), что еще немного ускорит запрос.

```
-> Table scan on <temporary>  (actual time=13.9..14 rows=391 loops=1)
    -> Aggregate using temporary table  (actual time=13.9..13.9 rows=391 loops=1)
        -> Nested loop inner join  (cost=12982 rows=16284) (actual time=5.01..12.7 rows=642 loops=1)
            -> Nested loop inner join  (cost=7283 rows=16284) (actual time=5..10.5 rows=642 loops=1)
                -> Filter: (cast(p.payment_date as date) = '2005-07-30')  (cost=1633 rows=16086) (actual time=4.98..7.78 rows=634 loops=1)
                    -> Covering index scan on p using idx_payment_date  (cost=1633 rows=16086) (actual time=0.0517..5.41 rows=16044 loops=1)
                -> Covering index lookup on r using rental_date (rental_date=p.payment_date)  (cost=0.25 rows=1.01) (actual time=0.00305..0.00402 rows=1.01 loops=634)
            -> Single-row index lookup on c using PRIMARY (customer_id=r.customer_id)  (cost=0.25 rows=1) (actual time=0.00296..0.003 rows=1 loops=642)

```

---

### Задание 3*

Самостоятельно изучите, какие типы индексов используются в PostgreSQL. Перечислите те индексы, которые используются в PostgreSQL, а в MySQL — нет.

*Приведите ответ в свободной форме.*

### Решение 3*
В PostgreSQL используются несколько типов индексов, которые отсутствуют в MySQL:

* **GIN (Generalized Inverted Index)**: Используется для индексации данных с множественными значениями, таких как массивы и JSONB.
* **GiST (Generalized Search Tree)**: Позволяет создавать индексы для данных, которые не подходят под традиционные структуры, например, для географических данных.
* **BRIN (Block Range INdex):** Эффективен для очень больших таблиц, где данные имеют определённую последовательность, позволяя индексировать большие блоки.
* **SP-GiST (Space-Partitioned Generalized Search Tree)**: Подходит для данных с высоким уровнем пространственной разделяемости, таких как геометрические типы данных.
* **Bloom Index**: Используется для индексирования столбцов с высокой кардинальностью.

---
