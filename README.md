# Домашнее задание к занятию "`SQL. Часть 2`" - `Журавлев Николай`
### Задание 1

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию: 
- фамилия и имя сотрудника из этого магазина;
- город нахождения магазина;
- количество пользователей, закреплённых в этом магазине.

### Решение 1
```sql
SELECT
    CONCAT(sf.last_name, ' ', sf.first_name) AS manager,
    ct.city AS city,
    COUNT(*) as customers
    FROM customer AS cs 
    LEFT JOIN store as st
        ON st.store_id = cs.store_id
    LEFT JOIN address as ad
        ON st.address_id = ad.address_id
    LEFT JOIN city AS ct
        ON ad.city_id = ct.city_id
    LEFT JOIN staff AS sf
        ON st.manager_staff_id = sf.staff_id
    GROUP BY st.store_id
    HAVING customers > 300;
```
---

### Задание 2

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.

### Решение 2
```sql
SELECT COUNT(*) FROM film AS f
    WHERE `f`.`length` > (
        SELECT AVG(a.length) FROM film AS a
    );
```

---

### Задание 3

Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.

### Решение 3
```sql
SELECT
    MONTH(p.payment_date) AS mnt,
    YEAR(p.payment_date) AS yr,
    SUM(p.amount) AS total_amount,
    COUNT(p.rental_id) AS rent_count
FROM payment AS p
GROUP BY mnt, yr
ORDER BY total_amount DESC LIMIT 1
```

---

### Задание 4*

Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия». Если количество продаж превышает 8000, то значение в колонке будет «Да», иначе должно быть значение «Нет».

### Решение 4*
```sql
SELECT
    s.first_name,
    s.last_name,
    COUNT(p.payment_id) AS payment_count,
    CASE
        WHEN COUNT(p.payment_id) > 8000 THEN "Да"
        ELSE "Нет"
    END AS bonus
FROM staff AS s
LEFT JOIN payment AS p
    ON s.staff_id = p.staff_id
GROUP BY s.staff_id
```

---

### Задание 5*

Найдите фильмы, которые ни разу не брали в аренду.

### Решение 5*
```sql
SELECT f.title
FROM film AS f WHERE NOT EXISTS (
    SELECT 1 FROM inventory AS i
        JOIN rental AS r
        ON r.inventory_id = i.inventory_id
    WHERE i.film_id = f.film_id
)
```

---