DECLARE
    SCREENINGID SCREENING.SCREENING_ID%TYPE;
    MOVIEID     MOVIE.MOVIE_ID%TYPE;
    MOVIETITLE  MOVIE.TITLE%TYPE;
BEGIN
    SELECT
        SCREENING_ID INTO SCREENINGID
    FROM
        (
            SELECT
                *
            FROM
                (
                    SELECT
                        R.SCREENING_ID,
                        COUNT(R.CLIENT_ID) AS RESERVATION_COUNT
                    FROM
                        RESERVATION R
                    GROUP BY
                        R.SCREENING_ID
                )
            ORDER BY
                RESERVATION_COUNT DESC
        )
    WHERE
        ROWNUM <= 1;
    SELECT
        S.MOVIE_ID INTO MOVIEID
    FROM
        SCREENING S
    WHERE
        S.SCREENING_ID = SCREENINGID;
    SELECT
        M.TITLE INTO MOVIETITLE
    FROM
        MOVIE M
    WHERE
        M.MOVIE_ID = MOVIEID;
    DBMS_OUTPUT.PUT_LINE('Difuzarea '
                         || SCREENINGID
                         ||' a filmului '
                         || MOVIETITLE);
END;