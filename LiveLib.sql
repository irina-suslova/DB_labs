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
        description TEXT NOT NULL,
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
CREATE TABLE book_author (
    book_id INT REFERENCES books(book_id) ON UPDATE CASCADE ON DELETE CASCADE,
    author_id INT REFERENCES authors(author_id) ON UPDATE CASCADE,
    CONSTRAINT book_author_pk PRIMARY KEY (book_id, author_id)
);
INSERT INTO book_author (book_id, author_id)
VALUES (1, 1);
------------------------------------------------------------------
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
        description TEXT NOT NULL,
        year_of_birth TIMESTAMPTZ NOT NULL,
        year_of_death TIMESTAMPTZ DEFAULT NULL
);
----------------------------------------------------------------
CREATE TABLE book_author (
    book_id INT REFERENCES books(book_id) ON UPDATE CASCADE ON DELETE CASCADE,
    author_id INT REFERENCES authors(author_id) ON UPDATE CASCADE,
    CONSTRAINT book_author_pk PRIMARY KEY (book_id, author_id)
);
-- INSERT INTO book_author (book_id, author_id)
-- VALUES (1, 1);