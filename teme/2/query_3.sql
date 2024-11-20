DECLARE
    SCREENINGID  SCREENING.SCREENING_ID%TYPE := 5;
    AUDITORIUMID AUDITORIUM.AUDITORIUM_ID%TYPE := 3;
    OLDPRICE     SCREENING.PRICE%TYPE;
    NEWPRICE     SCREENING.PRICE%TYPE;
    DISCOUNT     NUMBER := 0.1;
BEGIN
    SELECT
        S.PRICE INTO OLDPRICE
    FROM
        SCREENING S
    WHERE
        S.SCREENING_ID = SCREENINGID;
    UPDATE SCREENING S
    SET
        S.AUDITORIUM_ID=AUDITORIUMID,
        S.PRICE = ROUND(
            S.PRICE * (1 - DISCOUNT)
        )
    WHERE
        S.SCREENING_ID = SCREENINGID;
    NEWPRICE := ROUND( OLDPRICE * (1 - DISCOUNT) );
    DBMS_OUTPUT.PUT_LINE('Moved screening with ID '
                         || SCREENINGID
                         || ' to auditorium '
                         || AUDITORIUMID
                         || ' and the price was changed from '
                         || OLDPRICE
                         || ' to '
                         || NEWPRICE );
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No screening with ID '
                             || SCREENINGID
                             || ' found!' );
END;