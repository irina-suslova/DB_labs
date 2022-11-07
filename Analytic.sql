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