SET SERVEROUTPUT ON;

SET VERIFY OFF;

DECLARE
    MIN_SEAT_COUNT       NUMBER := &MIN_SEATS;
    SCREENING_COUNT      NUMBER;
    NO_RESULTS_EXCEPTION EXCEPTION;
BEGIN
    SELECT
        COUNT(*) INTO SCREENING_COUNT
    FROM
        (
            SELECT
                R.SCREENING_ID,
                COUNT(SEAT_ID) AS OCCUPIED_SEATS
            FROM
                RESERVATION R
            GROUP BY
                R.SCREENING_ID
        )
    WHERE
        OCCUPIED_SEATS >= MIN_SEAT_COUNT;
    IF SCREENING_COUNT = 0 THEN
        RAISE NO_RESULTS_EXCEPTION;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Numarul de difuzari cu cel putin '
                             || MIN_SEAT_COUNT
                             || ' scaune ocupate este '
                             || SCREENING_COUNT
                             || '.');
    END IF;
EXCEPTION
    WHEN NO_RESULTS_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista difuzari care sa aiba cel putin '
                             || MIN_SEAT_COUNT
                             || ' scaune ocupate.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('O alta eroare s-a produs!');
END;
/