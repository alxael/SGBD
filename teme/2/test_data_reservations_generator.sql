DECLARE
    SCREENINGID  NUMBER;
    AUDITORIUMID NUMBER;
    SEATID       NUMBER;
    SEATNUMBER   NUMBER;
BEGIN
    FOR CLIENT IN (
        SELECT
            *
        FROM
            CLIENT
    ) LOOP
        SCREENINGID := ROUND(DBMS_RANDOM.VALUE(1, 100));
        SELECT
            S.AUDITORIUM_ID INTO AUDITORIUMID
        FROM
            SCREENING S
        WHERE
            S.SCREENING_ID = SCREENINGID;
        SEATNUMBER := ROUND(DBMS_RANDOM.VALUE(1, 100));
        SEATID := SEATNUMBER + (AUDITORIUMID - 1) * 100;
        DBMS_OUTPUT.PUT_LINE('INSERT INTO RESERVATION VALUES ('
                             || SEATID
                             || ','
                             || SCREENINGID
                             || ','
                             || CLIENT.CLIENT_ID
                             || ');');
    END LOOP;
END;