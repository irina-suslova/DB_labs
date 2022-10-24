DROP TABLE reviews;
DROP TABLE stories;
DROP TABLE quotes;
DROP TABLE users;
DROP TABLE book_genre;
DROP TABLE genres;
DROP TABLE book_author;
DROP TABLE authors;
DROP TABLE books;
DROP TABLE publishers;
DROP TABLE sources;
CREATE TABLE IF NOT EXISTS "sources" (
    source_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMPTZ DEFAULT NULL,
    system_path TEXT UNIQUE NOT NULL
);
INSERT INTO sources (system_path)
VALUES ('/home/alexesn/Desktop/MEPhI/DB_labs/cover.jpg');
------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "publishers" (
    publisher_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMPTZ NULL,
    name VARCHAR(128) UNIQUE NOT NULL
);
INSERT INTO publishers (name)
VALUES ('CreateSpace Independent Publishing Platform');
-----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "books" (
    book_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMPTZ DEFAULT NULL,
    title VARCHAR(128) NOT NULL,
    description TEXT NOT NULL,
    release_date TIMESTAMPTZ NOT NULL,
    publisher_id INT NOT NULL,
    CONSTRAINT publisher_fk FOREIGN KEY(publisher_id) REFERENCES publishers(publisher_id) ON DELETE
    SET NULL,
        cover_path_id INT NOT NULL,
        CONSTRAINT cover_fk FOREIGN KEY(cover_path_id) REFERENCES sources(source_id) ON DELETE
    SET NULL
);
INSERT INTO books (
        title,
        description,
        release_date,
        publisher_id,
        cover_path_id
    )
VALUES (
        'Martin Eden',
        'Martin Eden, semiautobiographical novel by Jack London, published in 1909. The title character becomes a writer, hoping to acquire the respectability sought by his society-girl sweetheart. She spurns him, however, when his writing is rejected by several magazines and when he is falsely accused of being a socialist.',
        '1909-09-22 00:00:00-00',
        1,
        1
    );
--------------------------------------------------------
CREATE TABLE IF NOT EXISTS "authors" (
    author_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMPTZ DEFAULT NULL,
    first_name VARCHAR(128) NOT NULL,
    last_name VARCHAR(128) NOT NULL,
    photo_path_id INT DEFAULT NULL,
    CONSTRAINT photo_path_fk FOREIGN KEY(photo_path_id) REFERENCES sources(source_id) ON DELETE
    SET NULL,
        description TEXT DEFAULT NULL,
        year_of_birth TIMESTAMPTZ NOT NULL,
        year_of_death TIMESTAMPTZ DEFAULT NULL
);
INSERT INTO authors (
        first_name,
        last_name,
        description,
        year_of_birth,
        year_of_death
    )
VALUES (
        'Jack',
        'London',
        'Jack London was born on January 12, 1876. By age 30 London was internationally famous for his books Call of the Wild (1903), The Sea Wolf (1904) and other literary and journalistic accomplishments. Though he wrote passionately about the great questions of life and death and the struggle to survive with dignity and integrity, he also sought peace and quiet inspiration. His stories of high adventure were based on his own experiences at sea, in the Yukon Territory, and in the fields and factories of California. His writings appealed to millions worldwide.',
        '1876-01-12 00:00:00-00',
        '1916-11-22 00:00:00-00'
    );
------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "book_author" (
    book_id INT REFERENCES books(book_id) ON UPDATE CASCADE ON DELETE CASCADE,
    author_id INT REFERENCES authors(author_id) ON UPDATE CASCADE,
    CONSTRAINT book_author_pk PRIMARY KEY (book_id, author_id)
);
INSERT INTO book_author (book_id, author_id)
VALUES (1, 1);
------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "genres" (
    genre_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMPTZ DEFAULT NULL,
    name VARCHAR(128) UNIQUE NOT NULL,
    description TEXT NOT NULL
);
INSERT INTO genres (name, description)
VALUES (
        'Novel',
        'A fictitious prose narrative of book length, typically representing character and action with some degree of realism.'
    );
----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "book_genre" (
    book_id INT REFERENCES genres(genre_id) ON UPDATE CASCADE ON DELETE CASCADE,
    genre_id INT REFERENCES authors(author_id) ON UPDATE CASCADE,
    CONSTRAINT book_genre_pk PRIMARY KEY (book_id, genre_id)
);
INSERT INTO book_genre (book_id, genre_id)
VALUES (1, 1);
----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "users" (
    user_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMPTZ DEFAULT NULL,
    first_name VARCHAR(128) NOT NULL,
    last_name VARCHAR(128) NOT NULL,
    nick VARCHAR(128) NOT NULL,
    photo_path_id INT DEFAULT NULL,
    CONSTRAINT photo_path_fk FOREIGN KEY(photo_path_id) REFERENCES sources(source_id) ON DELETE
    SET NULL,
        description TEXT DEFAULT NULL,
        passwords VARCHAR(128) NOT NULL
);
INSERT INTO users (first_name, last_name, nick, passwords)
VALUES ('Irina', 'Suslova', 'suslik1978', '12201978');
INSERT INTO users (first_name, last_name, nick, passwords)
VALUES ('Alex', 'Yesis', 'alexesn2015', '12112015');
----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "quotes" (
    quote_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMPTZ DEFAULT NULL,
    book_id INT NOT NULL,
    CONSTRAINT book_fk FOREIGN KEY(book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    user_id INT NOT NULL,
    CONSTRAINT user_fk FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    text TEXT NOT NULL
);
INSERT INTO quotes (book_id, user_id, text)
VALUES (
        1,
        1,
        'Limited minds can recognize limitations only in others'
    );
---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "stories" (
    story_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMPTZ DEFAULT NULL,
    book_id INT NOT NULL,
    CONSTRAINT book_fk FOREIGN KEY(book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    user_id INT NOT NULL,
    CONSTRAINT user_fk FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    text TEXT NOT NULL
);
INSERT INTO stories (book_id, user_id, text)
VALUES (1, 1, 'Met my love while reading a book');
---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "reviews" (
    review_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMPTZ DEFAULT NULL,
    book_id INT NOT NULL,
    CONSTRAINT book_fk FOREIGN KEY(book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    user_id INT NOT NULL,
    CONSTRAINT user_fk FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    rating SMALLINT NOT NULL,
    CONSTRAINT rating_from_0_to_5 CHECK (
        rating >= 0
        AND rating <= 5
    )
);
INSERT INTO reviews (book_id, user_id, text, rating)
VALUES (1, 1, 'Best book', 5);
--------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "selections" (
    selection_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMPTZ DEFAULT NULL,
    user_id INT NOT NULL,
    CONSTRAINT user_fk FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    author_user_id INT NOT NULL,
    CONSTRAINT author_user_fk FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT NOT NULL
);
INSERT INTO selections (user_id, author_user_id, title, description)
VALUES (
        2,
        1,
        'Books Im crazy about',
        'Favorite books in my life'
    );
------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "book_selection" (
    book_id INT REFERENCES genres(genre_id) ON UPDATE CASCADE ON DELETE CASCADE,
    selection_id INT REFERENCES selections(selection_id) ON UPDATE CASCADE,
    CONSTRAINT book_selection_pk PRIMARY KEY (book_id, selection_id)
);