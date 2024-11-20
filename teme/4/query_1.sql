SET SERVEROUTPUT ON

DECLARE
    MOVIE_TITLE     MOVIE.TITLE%TYPE;
    MOVIE_ID        MOVIE.MOVIE_ID%TYPE;
    MOVIE_SCREENING SCREENING%ROWTYPE;
    DATES_STRING    VARCHAR(1000);
    CURSOR MC IS (
        SELECT
            M.MOVIE_ID,
            M.TITLE
        FROM
            MOVIE M
        WHERE
            M.MOVIE_ID IN (1, 2, 3)
    );
    CURSOR SC(
        SCREENING_MOVIE_ID MOVIE.MOVIE_ID%TYPE
    ) IS (
        SELECT
            *
        FROM
            SCREENING S
        WHERE
            S.MOVIE_ID = SCREENING_MOVIE_ID
    );
BEGIN
    OPEN MC;
    LOOP
        FETCH MC INTO MOVIE_ID, MOVIE_TITLE;
        EXIT WHEN MC%NOTFOUND;
        DATES_STRING := '';
        OPEN SC(MOVIE_ID);
        LOOP
            FETCH SC INTO MOVIE_SCREENING;
            EXIT WHEN SC%NOTFOUND;
            DATES_STRING := DATES_STRING
                            || TO_CHAR(MOVIE_SCREENING.DATE, 'dd/mm/yyyy')
                               || ' ';
        END LOOP;

        CLOSE SC;
        IF DATES_STRING = '' THEN
            DBMS_OUTPUT.PUT_LINE('No screenings for the movie '
                                 || MOVIE_TITLE
                                 || '.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Screenings for the movie '
                                 || MOVIE_TITLE
                                 || ' are on the following dates:');
            DBMS_OUTPUT.PUT_LINE(DATES_STRING);
        END IF;
    END LOOP;

    CLOSE MC;
END;