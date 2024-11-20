SET SERVEROUTPUT ON

DECLARE
    DATES_STRING VARCHAR(1000);
BEGIN
    FOR MOVIE_ENTRY IN (
        SELECT
            M.MOVIE_ID,
            M.TITLE
        FROM
            MOVIE M
        WHERE
            M.MOVIE_ID IN (1, 2, 3)
    ) LOOP
        DATES_STRING := '';
        FOR SCREENING_ENTRY IN (
            SELECT
                *
            FROM
                SCREENING S
            WHERE
                S.MOVIE_ID = MOVIE_ENTRY.MOVIE_ID
        ) LOOP
            DATES_STRING := DATES_STRING
                            || TO_CHAR(SCREENING_ENTRY.DATE, 'dd/mm/yyyy')
                               || ' ';
        END LOOP;

        IF DATES_STRING = '' THEN
            DBMS_OUTPUT.PUT_LINE('No screenings for the movie '
                                 || MOVIE_ENTRY.TITLE
                                 || '.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Screenings for the movie '
                                 || MOVIE_ENTRY.TITLE
                                 || ' are on the following dates:');
            DBMS_OUTPUT.PUT_LINE(DATES_STRING);
        END IF;
    END LOOP;
END;