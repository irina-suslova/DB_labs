-- найти всех друзей
SELECT u1.first_name,
    u1.last_name,
    u2.first_name,
    u2.last_name
FROM friends
    JOIN users u1 on u1.user_id = friends.user_id_1
    JOIN users u2 on u2.user_id = friends.user_id_2
ORDER BY u1.first_name;
-- найти тех у кого больше или 4 друга
SELECT u1.first_name,
    u1.last_name,
    COUNT(u2.nick)
FROM friends
    JOIN users u1 on u1.user_id = friends.user_id_1
    JOIN users u2 on u2.user_id = friends.user_id_2
GROUP BY u1.first_name,
    u1.last_name
HAVING COUNT(u2.nick) >= 4
ORDER BY COUNT(u2.nick) DESC;
-- книги, авторы, издательства
SELECT b.title,
    a.first_name,
    a.last_name,
    p.name
FROM book_author
    JOIN authors a on a.author_id = book_author.author_id
    JOIN books b on b.book_id = book_author.book_id
    JOIN publishers p on p.publisher_id = b.publisher_id;
-- самый взрослый из мертвых
SELECT a.first_name,
    a.last_name,
    a.year_of_birth,
    a.year_of_death,
    (a.year_of_death - a.year_of_birth) as years
FROM authors a
WHERE a.year_of_death IS NOT NULL
ORDER BY years DESC;
-- самый взрослый
SELECT a.first_name,
    a.last_name,
    a.year_of_birth,
    (now() - a.year_of_birth) as years
FROM authors a
WHERE a.year_of_death IS NULL
ORDER BY years DESC;
-- сколько кто прочитал
SELECT u.first_name,
    u.last_name,
    u.nick,
    COUNT(user_book.book_id)
FROM user_book
    JOIN user_book_types ubt on ubt.user_book_type_id = user_book.user_book_type_id
    JOIN users u on user_book.user_id = u.user_id
WHERE ubt.user_book_type_name = 'Прочитал(а)'
GROUP BY u.user_id
ORDER BY COUNT(user_book.book_id) DESC;
--  найти для определенного жанра книги, которые прочитал только мужчина
SELECT ub.user_id,
    ub.book_id,
    b.title,
    u.sex
FROM user_book AS ub
    JOIN books b on b.book_id = ub.book_id
    JOIN users u on ub.user_id = u.user_id
    JOIN user_book_types ubt on ub.user_book_type_id = ubt.user_book_type_id
    JOIN book_genre bg on bg.book_id = b.book_id
    JOIN genres g on g.genre_id = bg.genre_id
WHERE g.name = 'Религия'
    AND ubt.user_book_type_name = 'Прочитал(а)';


WITH r1 AS (
    SELECT ub.user_id,
        ub.book_id,
        b.title,
        u.sex
    FROM user_book AS ub
        JOIN books b on b.book_id = ub.book_id
        JOIN users u on ub.user_id = u.user_id
        JOIN user_book_types ubt on ub.user_book_type_id = ubt.user_book_type_id
        JOIN book_genre bg on bg.book_id = b.book_id
        JOIN genres g on g.genre_id = bg.genre_id
    WHERE g.name = 'Религия'
        AND ubt.user_book_type_name = 'Прочитал(а)'
)
SELECT r1.title
FROM r1
    JOIN r1 r2 on r1.book_id = r2.book_id
WHERE r1.sex = 'female'
    OR r2.sex = 'female';


WITH r1 AS (
    SELECT ub.user_id,
        ub.book_id,
        b.title,
        u.sex
    FROM user_book AS ub
        JOIN books b on b.book_id = ub.book_id
        JOIN users u on ub.user_id = u.user_id
        JOIN user_book_types ubt on ub.user_book_type_id = ubt.user_book_type_id
        JOIN book_genre bg on bg.book_id = b.book_id
        JOIN genres g on g.genre_id = bg.genre_id
    WHERE g.name = 'Бизнес-книги'
        AND ubt.user_book_type_name = 'Прочитал(а)'
)
SELECT DISTINCT b.title
FROM user_book AS ub
    JOIN books b on b.book_id = ub.book_id
    JOIN users u on ub.user_id = u.user_id
    JOIN user_book_types ubt on ub.user_book_type_id = ubt.user_book_type_id
    JOIN book_genre bg on bg.book_id = b.book_id
    JOIN genres g on g.genre_id = bg.genre_id
WHERE g.name = 'Бизнес-книги'
    AND ubt.user_book_type_name = 'Прочитал(а)'
EXCEPT
SELECT DISTINCT r1.title
FROM r1
    JOIN r1 r2 on r1.book_id = r2.book_id
WHERE r1.sex = 'male'
    OR r2.sex = 'male';


WITH r1 AS (
    SELECT ub.user_id,
        ub.book_id,
        b.title,
        u.sex
    FROM user_book AS ub
        JOIN books b on b.book_id = ub.book_id
        JOIN users u on ub.user_id = u.user_id
        JOIN user_book_types ubt on ub.user_book_type_id = ubt.user_book_type_id
        JOIN book_genre bg on bg.book_id = b.book_id
        JOIN genres g on g.genre_id = bg.genre_id
    WHERE g.name = 'Бизнес-книги'
        AND ubt.user_book_type_name = 'Прочитал(а)'
)
SELECT DISTINCT r1.title
FROM r1
    JOIN r1 r2 on r1.book_id = r2.book_id
WHERE r1.sex = 'male'
    OR r2.sex = 'male';
--- категории людей по количеству прочитанного
SELECT u.first_name,
       u.last_name,
       u.nick,
       COUNT(user_book.book_id) as books,
       CASE WHEN COUNT(user_book.book_id) BETWEEN 0 AND 1 THEN
                'мало (<=1)'
            WHEN COUNT(user_book.book_id) BETWEEN 1 AND 2 THEN
                'средне (<=2)'
            WHEN COUNT(user_book.book_id) >= 3 THEN
                'много (>=3)'
           END CASE
FROM user_book
    JOIN user_book_types ubt on ubt.user_book_type_id = user_book.user_book_type_id
    JOIN users u on user_book.user_id = u.user_id
WHERE ubt.user_book_type_name = 'Прочитал(а)'
GROUP BY u.user_id
ORDER BY books DESC;
---------- Вывести книги писателей, которые родились в диапазоне (с янваля 1950 до ферваля 1970)
SELECT a.first_name,
       a.last_name,
       a.year_of_birth,
       b.title
FROM authors a
         JOIN book_author ba on ba.author_id = a.author_id
         JOIN books b on b.book_id = ba.book_id
WHERE timestamp '1950-01-01 00:00' <= a.year_of_birth AND a.year_of_birth <= timestamp '1970-02-28 01:00'
------------------ Вывести книги, которые содержат в названии какое-то слово
SELECT a.first_name,
       a.last_name,
       b.title
FROM authors a
         JOIN book_author ba on ba.author_id = a.author_id
         JOIN books b on b.book_id = ba.book_id
WHERE b.title SIMILAR TO '% и %'
------------- содержат в названии слово без учета регистра (не содержат)
SELECT a.first_name,
       a.last_name,
       b.title
FROM authors a
         JOIN book_author ba on ba.author_id = a.author_id
         JOIN books b on b.book_id = ba.book_id
-- WHERE b.title ~~* '%пр%'
WHERE b.title ILIKE '%пр%'
-- WHERE b.title NOT LIKE '% и %'	-- !~~