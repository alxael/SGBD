DECLARE
    ID_LOC                 NUMBER;
    COD_LOC                VARCHAR2(255);
    QUERY_INSERT_LOC       VARCHAR2(255);
    REZERVARI_PER_CLIENT   NUMBER;
    ID_DIFUZARE_REZERVARE  NUMBER;
    ID_SALA_REZERVARE      NUMBER;
    ID_LOC_REZERVARE       NUMBER;
    QUERY_INSERT_REZERVARE VARCHAR2(255);
BEGIN
    FOR DATE_SALA IN (
        SELECT
            *
        FROM
            SALA
    ) LOOP
        FOR INDEX_LOC IN 1..CONSTANTE_GLOBALE.LOCURI_PER_SALA LOOP
            COD_LOC := 'LOC-'
                       || DATE_SALA.ID_SALA
                       || '-'
                       || INDEX_LOC;
            ID_LOC := (DATE_SALA.ID_SALA - 1) * CONSTANTE_GLOBALE.LOCURI_PER_SALA + INDEX_LOC;
            QUERY_INSERT_LOC := 'INSERT INTO LOC VALUES('
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
                    DBMS_OUTPUT.PUT_LINE('Se incearca inserarea unui loc duplicat. Sarim peste.');
            END;
        END LOOP;
    END LOOP;

    FOR DATE_CLIENT IN (
        SELECT
            *
        FROM
            CLIENT
    ) LOOP
        REZERVARI_PER_CLIENT := ROUND(DBMS_RANDOM.VALUE(1, CONSTANTE_GLOBALE.REZERVARI_PER_CLIENT_MAX));
        FOR INDEX_REZERVARE IN 1..REZERVARI_PER_CLIENT LOOP
            ID_DIFUZARE_REZERVARE := ROUND(DBMS_RANDOM.VALUE(1, CONSTANTE_GLOBALE.NUMAR_DIFUZARI));
            SELECT
                D.ID_SALA INTO ID_SALA_REZERVARE
            FROM
                DIFUZARE D
            WHERE
                D.ID_DIFUZARE = ID_DIFUZARE_REZERVARE;
            ID_LOC_REZERVARE := (ID_SALA_REZERVARE - 1) * CONSTANTE_GLOBALE.LOCURI_PER_SALA + ROUND(DBMS_RANDOM.VALUE(1, CONSTANTE_GLOBALE.LOCURI_PER_SALA));
            QUERY_INSERT_REZERVARE := 'INSERT INTO REZERVARE VALUES ('
                                      || ID_LOC_REZERVARE
                                      || ','
                                      || ID_DIFUZARE_REZERVARE
                                      || ','
                                      || DATE_CLIENT.ID_CLIENT
                                      || ')';
            BEGIN
                EXECUTE IMMEDIATE QUERY_INSERT_REZERVARE;
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Se incearca inserarea unei rezervari duplicat. Sarim peste.');
            END;
        END LOOP;
    END LOOP;
END;