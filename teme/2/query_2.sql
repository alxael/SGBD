DECLARE
    CATEGORYID       CATEGORY.CATEGORY_ID%TYPE := 3;
    RESERVATIONCOUNT NUMBER(10);
    DISCOUNT         DECIMAL(10, 4);
BEGIN
    SELECT
        C.CATEGORY_ID INTO CATEGORYID
    FROM
        CATEGORY C
    WHERE
        C.CATEGORY_ID = CATEGORYID;
    SELECT
        COUNT(*) INTO RESERVATIONCOUNT
    FROM
        (
            SELECT
                C.CATEGORY_ID
            FROM
                CATEGORY C
            WHERE
                C.CATEGORY_ID = CATEGORYID
        )              C
        INNER JOIN MOVIE_CATEGORY MC
        ON MC.CATEGORY_ID = C.CATEGORY_ID
        INNER JOIN SCREENING S
        ON S.MOVIE_ID = MC.MOVIE_ID
        INNER JOIN RESERVATION R
        ON R.SCREENING_ID = S.SCREENING_ID;
    CASE
        WHEN RESERVATIONCOUNT <= 50 THEN
            DISCOUNT := -0.1;
        WHEN RESERVATIONCOUNT BETWEEN 50 AND 150 THEN
            DISCOUNT := 0;
        WHEN RESERVATIONCOUNT BETWEEN 150 AND 300 THEN
            DISCOUNT := 0.05;
        WHEN RESERVATIONCOUNT >= 300 THEN
            DISCOUNT := 0.1;        
    END CASE;
    DBMS_OUTPUT.PUT_LINE('The category has ' || RESERVATIONCOUNT || ' reservations so the discount will be ' || ROUND(DISCOUNT * 100) || '%');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No category with ID '
                             || CATEGORYID
                             || ' found!' );
END;