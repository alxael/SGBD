DECLARE
    ID_LOC_REZERVARE      REZERVARI.ID_LOC%TYPE;
    ID_DIFUZARE_REZERVARE REZERVARI.ID_DIFUZARE%TYPE := ROUND(DBMS_RANDOM.VALUE(1, 50));
    ID_CLIENT_REZERVARE   REZERVARI.ID_CLIENT%TYPE := ROUND(DBMS_RANDOM.VALUE(1, 100));
    ZI_DIFUZARE           NUMBER(10);

    PROCEDURE TESTEAZA_INSERARE (
        ID_LOC_PARAM IN REZERVARI.ID_LOC%TYPE,
        ID_DIFUZARE_PARAM IN REZERVARI.ID_DIFUZARE%TYPE,
        ID_CLIENT_PARAM IN REZERVARI.ID_CLIENT%TYPE,
        ZI_DIFUZARE_PARAM NUMBER
    ) AS
    BEGIN
        INSERT INTO REZERVARI VALUES (
            ID_LOC_PARAM,
            ID_DIFUZARE_PARAM,
            ID_CLIENT_PARAM,
            TO_DATE('2025/09/'
                    || ZI_DIFUZARE_PARAM, 'yyyy/mm/dd')
        );
        DBMS_OUTPUT.PUT_LINE('Inserare realizata cu succes!');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Eroare! '
                                 || SUBSTR(SQLERRM, 1, 255));
    END TESTEAZA_INSERARE;

    PROCEDURE TESTEAZA_EDITARE (
        ID_LOC_PARAM IN REZERVARI.ID_LOC%TYPE,
        ID_DIFUZARE_PARAM IN REZERVARI.ID_DIFUZARE%TYPE,
        ID_CLIENT_PARAM IN REZERVARI.ID_CLIENT%TYPE,
        ID_LOC_NOU_PARAM IN REZERVARI.ID_LOC%TYPE,
        ZI_DIFUZARE_NOU_PARAM NUMBER
    ) AS
    BEGIN
        UPDATE REZERVARI
        SET
            ID_LOC = ID_LOC_NOU_PARAM,
            DATA = TO_DATE(
                '2025/09/'
                || ZI_DIFUZARE_NOU_PARAM,
                'yyyy/mm/dd'
            )
        WHERE
            ID_LOC = ID_LOC_PARAM
            AND ID_DIFUZARE = ID_DIFUZARE_PARAM
            AND ID_CLIENT =ID_CLIENT_PARAM;
        DBMS_OUTPUT.PUT_LINE('Editare realizata cu succes!');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Eroare! '
                                 || SUBSTR(SQLERRM, 1, 255));
    END TESTEAZA_EDITARE;
BEGIN
    ID_LOC_REZERVARE := LOC_ALEATOR_LA_DIFUZARE(ID_DIFUZARE_REZERVARE);
    SELECT
        TO_NUMBER(TO_CHAR(D.DATA, 'dd')) INTO ZI_DIFUZARE
    FROM
        DIFUZARI D
    WHERE
        D.ID_DIFUZARE = ID_DIFUZARE_REZERVARE;
 
    -- Caz in care inserarea nu functioneaza pentru ca sala locului difera de sala difuzarii
    TESTEAZA_INSERARE( ID_LOC_REZERVARE + 30, ID_DIFUZARE_REZERVARE, ID_CLIENT_REZERVARE, ZI_DIFUZARE );
 
    -- Caz in care inserarea nu functioneaza pentru ca data rezervarii succede data difuzarii
    TESTEAZA_INSERARE( ID_LOC_REZERVARE, ID_DIFUZARE_REZERVARE, ID_CLIENT_REZERVARE, ZI_DIFUZARE + 1 );
 
    -- Caz in care inserarea functioneaza
    TESTEAZA_INSERARE( ID_LOC_REZERVARE, ID_DIFUZARE_REZERVARE, ID_CLIENT_REZERVARE, ZI_DIFUZARE - 1 );
 
    -- Caz in care editarea nu functioneaza pentru ca sala locului difera de sala difuzarii
    TESTEAZA_EDITARE(ID_LOC_REZERVARE, ID_DIFUZARE_REZERVARE, ID_CLIENT_REZERVARE, ID_LOC_REZERVARE + 30, ZI_DIFUZARE - 1);
 
    -- Caz in care editarea nu functioneaza pentru ca data rezervarii succede data difuzarii
    TESTEAZA_EDITARE(ID_LOC_REZERVARE, ID_DIFUZARE_REZERVARE, ID_CLIENT_REZERVARE, ID_LOC_REZERVARE, ZI_DIFUZARE + 1);
 
    -- Caz in care editarea functioneaza
    TESTEAZA_EDITARE(ID_LOC_REZERVARE, ID_DIFUZARE_REZERVARE, ID_CLIENT_REZERVARE, ID_LOC_REZERVARE + 1, ZI_DIFUZARE - 1);
END;