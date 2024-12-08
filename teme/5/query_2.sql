SET SERVEROUTPUT ON

SET VERIFY OFF

CREATE OR REPLACE PROCEDURE MOVIE_TITLE_TO_RELEASE_DATE_P (
    MOVIE_TITLE IN MOVIE.TITLE%TYPE,
    MOVIE_RELEASE_DATE OUT MOVIE.RELEASE_DATE%TYPE
) IS
BEGIN
    SELECT
        M.RELEASE_DATE INTO MOVIE_RELEASE_DATE
    FROM
        MOVIE M
    WHERE
        LOWER(M.TITLE) LIKE '%'
                            || LOWER(MOVIE_TITLE)
                            || '%';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'There are no movies with the specified name!');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001, 'There are multiple movies with the specified name!');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'An unknown error occured while trying to find the specified movie''s release date!');
END MOVIE_TITLE_TO_RELEASE_DATE_P;
/

DECLARE
    MOVIE_TITLE        MOVIE.TITLE%TYPE := '&MOVIE_TITLE_INPUT';
    MOVIE_RELEASE_DATE MOVIE.RELEASE_DATE%TYPE;
BEGIN
    MOVIE_TITLE_TO_RELEASE_DATE_P(MOVIE_TITLE, MOVIE_RELEASE_DATE);
    DBMS_OUTPUT.PUT_LINE('The movie with the title containing '''
                         || MOVIE_TITLE
                         || ''' was released on '
                         || TO_CHAR(MOVIE_RELEASE_DATE, 'dd/mm/yyyy'));
END;
/