SELECT
    'INSERT INTO MOVIE VALUES
('
    || M.MOVIE_ID
    || ', '''
    || M.TITLE
    || ''', '
    || M.DURATION
    || ', TO_DATE('''
    || TO_CHAR(M.RELEASE_DATE, 'yyyy/mm/dd')
       || ''', ''yyyy/mm/dd''));' AS "Inserare date"
FROM
    MOVIE M;