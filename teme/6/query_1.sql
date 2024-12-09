CREATE OR REPLACE PACKAGE MOVIE_STATISTICS AS
    TYPE MOVIE_ID_RESERVATIONS_COUNT IS RECORD (
        MOVIE_ID NUMBER(10),
        RESERVATIONS_COUNT NUMBER(10)
    );
    TYPE MOVIE_ID_REVENUE IS RECORD (
        MOVIE_ID NUMBER(10),
        REVENUE NUMBER(10)
    );
    CURSOR MOVIES_WITH_MINIMUM_RESERVATIONS(
        START_DATE DATE,
        END_DATE DATE,
        MINIMUM_RESERVATIONS NUMBER
    ) RETURN MOVIE_ID_RESERVATIONS_COUNT;
    CURSOR MOVIES_WITH_MAX_REVENUE(
        START_DATE DATE,
        END_DATE DATE
    ) RETURN MOVIE_ID_REVENUE;

    FUNCTION MOVIE_WITH_MAX_REVENUE(
        START_DATE DATE,
        END_DATE DATE
    ) RETURN MOVIE_ID_REVENUE;
END MOVIE_STATISTICS;
/

CREATE OR REPLACE PACKAGE BODY MOVIE_STATISTICS AS
    CURSOR MOVIES_WITH_MINIMUM_RESERVATIONS(
        START_DATE DATE,
        END_DATE DATE,
        MINIMUM_RESERVATIONS NUMBER
    ) RETURN MOVIE_ID_RESERVATIONS_COUNT IS
    SELECT
        *
    FROM
        (
            SELECT
                SR.MOVIE_ID,
                SUM(RESERVATIONS) RESERVATIONS_COUNT
            FROM
                (
                    SELECT
                        S.SCREENING_ID,
                        S.MOVIE_ID,
                        COUNT(CLIENT_ID) AS RESERVATIONS
                    FROM
                        SCREENING   S
                        INNER JOIN RESERVATION R
                        ON R.SCREENING_ID = S.SCREENING_ID
                    WHERE
                        "DATE" BETWEEN START_DATE AND END_DATE
                    GROUP BY
                        S.SCREENING_ID,
                        S.MOVIE_ID,
                        S.PRICE
                ) SR
            GROUP BY
                SR.MOVIE_ID
            ORDER BY
                RESERVATIONS_COUNT
        )
    WHERE
        RESERVATIONS_COUNT >= MINIMUM_RESERVATIONS;
    CURSOR MOVIES_WITH_MAX_REVENUE(
        START_DATE DATE,
        END_DATE DATE
    ) RETURN MOVIE_ID_REVENUE IS
    SELECT
        SR.MOVIE_ID,
        SUM(SR.PARTIAL_REVENUE) AS REVENUE
    FROM
        (
            SELECT
                S.SCREENING_ID,
                S.MOVIE_ID,
                COUNT(CLIENT_ID) * S.PRICE AS PARTIAL_REVENUE
            FROM
                SCREENING   S
                INNER JOIN RESERVATION R
                ON R.SCREENING_ID = S.SCREENING_ID
            WHERE
                "DATE" BETWEEN START_DATE AND END_DATE
            GROUP BY
                S.SCREENING_ID,
                S.MOVIE_ID,
                S.PRICE
        ) SR
    GROUP BY
        SR.MOVIE_ID
    ORDER BY
        REVENUE DESC;

    FUNCTION MOVIE_WITH_MAX_REVENUE(
        START_DATE DATE,
        END_DATE DATE
    ) RETURN MOVIE_ID_REVENUE IS
        MAX_REVENUE_MOVIE MOVIE_ID_REVENUE;
    BEGIN
        FOR MOVIE_REVENUE IN MOVIES_WITH_MAX_REVENUE(START_DATE, END_DATE) LOOP
            MAX_REVENUE_MOVIE := MOVIE_REVENUE;
            EXIT;
        END LOOP;

        RETURN MAX_REVENUE_MOVIE;
    END MOVIE_WITH_MAX_REVENUE;
END MOVIE_STATISTICS;
/