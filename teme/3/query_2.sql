SET VERIFY OFF

SET FEEDBACK ON

SET SERVEROUTPUT ON

CREATE TABLE CLIENT_SUMMARY AS
    SELECT
        C.CLIENT_ID,
        UPPER(C.FIRST_NAME
              || ' '
              || C.LAST_NAME) AS FULL_NAME
    FROM
        CLIENT C;

/

CREATE OR REPLACE TYPE CONTACT_DATA IS
    TABLE OF VARCHAR2(255);
/

ALTER TABLE CLIENT_SUMMARY
    ADD (
        CONTACT CONTACT_DATA
    ) NESTED TABLE CONTACT STORE AS CONTACT_DATA_SUMMARY;

/

DECLARE
    CONTACTS    CONTACT_DATA;
    OUTPUT_LINE VARCHAR2(1000);
BEGIN
    FOR ITEM IN (
        SELECT
            *
        FROM
            CLIENT
    ) LOOP
        UPDATE CLIENT_SUMMARY CS
        SET
            CONTACT = CONTACT_DATA(
                ITEM.PHONE_NUMBER,
                ITEM.EMAIL
            )
        WHERE
            CS.CLIENT_ID = ITEM.CLIENT_ID;
    END LOOP;

    FOR ITEM IN (
        SELECT
            *
        FROM
            CLIENT_SUMMARY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('CLIENT_ID: '
                             || ITEM.CLIENT_ID);
        DBMS_OUTPUT.PUT_LINE('FULL_NAME: '
                             || ITEM.FULL_NAME);
        OUTPUT_LINE := '';
        FOR CONTACT_INDEX IN ITEM.CONTACT.FIRST..ITEM.CONTACT.LAST LOOP
            OUTPUT_LINE := OUTPUT_LINE
                           || ITEM.CONTACT(CONTACT_INDEX)
                           || ' ';
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('CONTACT: '
                             || OUTPUT_LINE);
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
END;
/

DROP TABLE CLIENT_SUMMARY;

DROP TYPE CONTACT_DATA;