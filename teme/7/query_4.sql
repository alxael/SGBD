SELECT
    *
FROM
    CINEMA_REVENUE;

INSERT INTO RESERVATION VALUES (
    1,
    1,
    1
);

SELECT
    *
FROM
    CINEMA_REVENUE;

DELETE FROM RESERVATION R
WHERE
    R.CLIENT_ID = 1
    AND R.SCREENING_ID = 1
    AND R.SEAT_ID = 1;

SELECT
    *
FROM
    CINEMA_REVENUE;