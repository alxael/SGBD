CREATE OR REPLACE PROCEDURE BACKUP_MANUAL_TABEL(
    NUME_TABEL IN VARCHAR2
) AS
    NUME_TABEL_POTRIVIRI NUMBER(10);
BEGIN
    SELECT
        COUNT(*) INTO NUME_TABEL_POTRIVIRI
    FROM
        ALL_OBJECTS
    WHERE
        OBJECT_TYPE IN ('TABLE', 'VIEW')
        AND OBJECT_NAME = NUME_TABEL;
    IF NUME_TABEL_POTRIVIRI = 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Niciun tabel cu numele specificat nu a fost gasit!');
    END IF;

    EXECUTE IMMEDIATE ('ALTER TABLE '
                       || NUME_TABEL
                       || ' RENAME TO '
                       || NUME_TABEL
                       || '_MANUAL');
    EXECUTE IMMEDIATE ('ALTER TABLE '
                       || NUME_TABEL
                       || '_MANUAL RENAME TO '
                       || NUME_TABEL);
END;
/

DECLARE
    NUME_TABEL VARCHAR2(255) := '&NUME_TABEL';
BEGIN
    BACKUP_MANUAL_TABEL(NUME_TABEL);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare! '
                             || SUBSTR(SQLERRM, 1, 255));
END;