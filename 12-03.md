# Домашнее задание к занятию "`SQL. Часть 1`" - `Журавлев Николай`

### Задание 1

Получите уникальные названия районов из таблицы с адресами, которые начинаются на “K” и заканчиваются на “a” и не содержат пробелов.

### Решение 1
```sql
SELECT * FROM address
  WHERE district LIKE 'K%a' AND district NOT LIKE '% %'
```

---

### Задание 2

Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись в промежуток с 15 июня 2005 года по 18 июня 2005 года **включительно** и стоимость которых превышает 10.00.

### Решение 2
```sql
SELECT * FROM payment
  WHERE payment_date BETWEEN '2005-06-15 00:00:00' AND '2005-06-18 23:59:59'
    AND amount > 10.00 ORDER BY payment_date;
```

---

### Задание 3

Получите последние пять аренд фильмов.

### Решение 3
```sql
SELECT * FROM rental
  ORDER BY rental_date DESC
  LIMIT 5;
```

---

### Задание 4

Одним запросом получите активных покупателей, имена которых Kelly или Willie. 

Сформируйте вывод в результат таким образом:
- все буквы в фамилии и имени из верхнего регистра переведите в нижний регистр,
- замените буквы 'll' в именах на 'pp'.

### Решение 4
```sql
SELECT *,
  REPLACE(LOWER(first_name),'ll', 'pp'),
  LOWER(last_name)
  FROM customer
  WHERE active = 1 AND first_name in ('Kelly','Willie');
```

---

### Задание 5*

Выведите Email каждого покупателя, разделив значение Email на две отдельных колонки: в первой колонке должно быть значение, указанное до @, во второй — значение, указанное после @.

### Решение 5*
```sql
  SELECT
    SUBSTRING(email, 1, POSITION('@' in email)-1) AS prefix,
    SUBSTRING(email, POSITION('@' in email)+1) AS postfix
    FROM customer;
```

---

### Задание 6*

Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: первая буква должна быть заглавной, остальные — строчными.

### Решение 6*
```sql
WITH email AS (
  SELECT
      SUBSTRING(email, 1, POSITION('@' in email)-1) AS a ,
      SUBSTRING(email, POSITION('@' in email)+1) AS b
      from customer
  )
  SELECT
    CONCAT(UPPER(SUBSTRING(a,1,1)), LOWER(SUBSTRING(a,2))) AS prefix,
    CONCAT(UPPER(SUBSTRING(b,1,1)), LOWER(SUBSTRING(b,2))) AS postfox
    FROM email
```

---