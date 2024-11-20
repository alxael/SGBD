INSERT INTO CATEGORY VALUES (
    1,
    'Horror',
    'The horror category is ...'
);

INSERT INTO CATEGORY VALUES (
    2,
    'Action',
    'The action category is ...'
);

INSERT INTO CATEGORY VALUES (
    3,
    'Romance',
    'The romance category is ...'
);

INSERT INTO CATEGORY VALUES (
    4,
    'History',
    'The history category is ...'
);

INSERT INTO CATEGORY VALUES (
    5,
    'Science-fiction',
    'The science-fiction genre is...'
);

INSERT INTO MOVIE VALUES (
    1,
    'Palm Springs',
    90,
    TO_DATE('2020/07/10', 'yyyy/mm/dd')
);

INSERT INTO MOVIE VALUES (
    2,
    'Beau Is Afraid',
    179,
    TO_DATE('2023/04/21', 'yyyy/mm/dd')
);

INSERT INTO MOVIE VALUES (
    3,
    'Aliens',
    137,
    TO_DATE('1986/07/14', 'yyyy/mm/dd')
);

INSERT INTO MOVIE VALUES (
    4,
    'Everything Everywhere All at Once',
    132,
    TO_DATE('2022/07/14', 'yyyy/mm/dd')
);

INSERT INTO MOVIE VALUES (
    5,
    'Pan''s Labyrinth',
    109,
    TO_DATE('2006/09/11', 'yyyy/mm/dd')
);

INSERT INTO MOVIE_CATEGORY VALUES (
    1,
    3
);

INSERT INTO MOVIE_CATEGORY VALUES (
    1,
    5
);

INSERT INTO MOVIE_CATEGORY VALUES (
    2,
    1
);

INSERT INTO MOVIE_CATEGORY VALUES (
    2,
    5
);

INSERT INTO MOVIE_CATEGORY VALUES (
    3,
    1
);

INSERT INTO MOVIE_CATEGORY VALUES (
    3,
    2
);

INSERT INTO MOVIE_CATEGORY VALUES (
    3,
    5
);

INSERT INTO MOVIE_CATEGORY VALUES (
    4,
    2
);

INSERT INTO MOVIE_CATEGORY VALUES (
    4,
    5
);

INSERT INTO MOVIE_CATEGORY VALUES (
    5,
    5
);
