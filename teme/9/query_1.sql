CREATE TABLE MOVIE_STATISTICS AS (
    SELECT
        MOVIE_ID,
        AVG(SEAT_COUNT) AS RESERVATIONS_PER_SCREENING_AVERAGE
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
);