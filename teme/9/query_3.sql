CREATE OR REPLACE TRIGGER UPDATE_MOVIE_STATISTICS AFTER
    INSERT ON RESERVATION
DECLARE
    ID_MOVIE MOVIE.MOVIE_ID%TYPE;
    AVERAGE  MOVIE_STATISTICS.RESERVATIONS_PER_SCREENING_AVERAGE%TYPE;
BEGIN
    FOR ENTRY IN (
        SELECT
            MOVIE_ID,
            AVG(SEAT_COUNT) AS AVERAGE
        FROM
            (
                SELECT
                    S.SCREENING_ID,
                    S.MOVIE_ID,
                    COUNT(R.SEAT_ID) AS SEAT_COUNT
                FROM
                    RESERVATION R
                    INNER JOIN SCREENING S
                    ON R.SCREENING_ID = S.SCREENING_ID
                GROUP BY
                    S.SCREENING_ID,
                    S.MOVIE_ID
            )
        GROUP BY
            MOVIE_ID
    ) LOOP
        UPDATE MOVIE_STATISTICS
        SET
            RESERVATIONS_PER_SCREENING_AVERAGE=AVERAGE
        WHERE
            MOVIE_ID=ENTRY.MOVIE_ID;
    END LOOP;
END;