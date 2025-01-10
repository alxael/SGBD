CREATE OR REPLACE PROCEDURE GENERARE_REZERVARE_PENTRU_CLIENT (
    ID_CLIENT_PARAM IN CLIENTI.ID_CLIENT%TYPE
) AS
    ID_DIFUZARE_GENERAT DIFUZARI.ID_DIFUZARE%TYPE;
    DIFUZARE            DIFUZARI%ROWTYPE;
    ID_LOC              LOCURI.ID_LOC%TYPE;
    ZI_REZERVARE        NUMBER(10);
BEGIN
    ID_DIFUZARE_GENERAT := ROUND(DBMS_RANDOM.VALUE(1, 50));
    SELECT
        * INTO DIFUZARE
    FROM
        DIFUZARI D
    WHERE
        D.ID_DIFUZARE = ID_DIFUZARE_GENERAT;
    ID_LOC := ROUND(DBMS_RANDOM.VALUE(1, 30));
    ID_LOC := ID_LOC + (DIFUZARE.ID_SALA - 1) * 30;
    ZI_REZERVARE := ROUND(DBMS_RANDOM.VALUE(1, TO_NUMBER(TO_CHAR(DIFUZARE.DATA, 'dd'))));
    INSERT INTO REZERVARI VALUES (
        ID_LOC,
        DIFUZARE.ID_DIFUZARE,
        ID_CLIENT_PARAM,
        TO_DATE('2025/09/'
                || ZI_REZERVARE, 'yyyy/mm/dd')
    );
END GENERARE_REZERVARE_PENTRU_CLIENT;
/

DECLARE
    LOCURI_PER_SALA          NUMBER(10) := 30;
    REZERVARI_PER_CLIENT_MAX NUMBER(10) := 5;
    REZERVARI_PER_CLIENT     NUMBER(10);
    ZI_REZERVARE             NUMBER(10);
    ID_LOC                   LOCURI.ID_LOC%TYPE;
    COD_LOC                  LOCURI.COD%TYPE;
    ID_DIFUZARE_REZERVARE    REZERVARI.ID_DIFUZARE%TYPE;
    ID_SALA_REZERVARE        DIFUZARI.ID_SALA%TYPE;
    ID_LOC_REZERVARE         REZERVARI.ID_LOC%TYPE;
    QUERY_INSERT_REZERVARE   VARCHAR2(255);
    QUERY_INSERT_LOC         VARCHAR2(255);
BEGIN
    FOR DATE_SALA IN (
        SELECT
            *
        FROM
            SALI
    ) LOOP
        FOR INDEX_LOC IN 1..LOCURI_PER_SALA LOOP
            COD_LOC := 'LOC-'
                       || DATE_SALA.ID_SALA
                       || '-'
                       || INDEX_LOC;
            ID_LOC := (DATE_SALA.ID_SALA - 1) * LOCURI_PER_SALA + INDEX_LOC;
            QUERY_INSERT_LOC := 'INSERT INTO LOCURI VALUES('
                                || ID_LOC
                                || ','
                                || DATE_SALA.ID_SALA
                                || ','''
                                || COD_LOC
                                || ''')';
            BEGIN
                EXECUTE IMMEDIATE QUERY_INSERT_LOC;
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Se incearca inserarea unui loc invalid. Sarim peste.');
            END;
        END LOOP;
    END LOOP;

    FOR DATE_CLIENT IN (
        SELECT
            *
        FROM
            CLIENTI
    ) LOOP
        REZERVARI_PER_CLIENT := ROUND(DBMS_RANDOM.VALUE(1, REZERVARI_PER_CLIENT_MAX));
        FOR INDEX_REZERVARE IN 1..REZERVARI_PER_CLIENT LOOP
            BEGIN
                GENERARE_REZERVARE_PENTRU_CLIENT(DATE_CLIENT.ID_CLIENT);
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Se incearca inserarea unei rezervari invalide. Sarim peste.');
            END;
        END LOOP;
    END LOOP;
END;