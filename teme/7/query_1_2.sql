CREATE TABLE CINEMA_REVENUE AS (
    SELECT
        C.CINEMA_ID,
        C.NAME,
        SUM(SP.REVENUE) AS REVENUE
    FROM
        (
            SELECT
                S.SCREENING_ID,
                S.AUDITORIUM_ID,
                COUNT(R.SEAT_ID) * S.PRICE AS REVENUE
            FROM
                SCREENING   S
                INNER JOIN RESERVATION R
                ON R.SCREENING_ID = S.SCREENING_ID
            GROUP BY
                S.SCREENING_ID,
                S.PRICE,
                S.AUDITORIUM_ID
        )          SP
        INNER JOIN AUDITORIUM A
        ON A.AUDITORIUM_ID = SP.AUDITORIUM_ID
        INNER JOIN CINEMA C
        ON C.CINEMA_ID = A.CINEMA_ID
    GROUP BY
        C.CINEMA_ID,
        C.NAME
);