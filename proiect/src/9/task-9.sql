CREATE TYPE DIFUZARI_FILM_IN_INTERVAL_DE_TIMP_DATE_DIFUZARE IS
    OBJECT (
        ID_DIFUZARE NUMBER(10),
        COD_SALA VARCHAR2(255),
        TITLU_FILM VARCHAR2(255),
        DATA_DIFUZARE DATE,
        PRET_DIFUZARE NUMBER,
        NUME_PRENUME VARCHAR2(255),
        COD_LOC VARCHAR2(255)
    )
/

CREATE TYPE DIFUZARI_FILM_IN_INTERVAL_DE_TIMP_DATE_DIFUZARI IS
    TABLE OF DIFUZARI_FILM_IN_INTERVAL_DE_TIMP_DATE_DIFUZARE
/

CREATE OR REPLACE PROCEDURE DIFUZARI_FILM_IN_INTERVAL_DE_TIMP (
    ID_FILM_PARAM IN FILME.ID_FILM%TYPE,
    DATA_INCEPUT_PARAM IN DIFUZARI.DATA%TYPE,
    DATA_SFARSIT_PARAM IN DIFUZARI.DATA%TYPE,
    DATE_DIFUZARI OUT DIFUZARI_FILM_IN_INTERVAL_DE_TIMP_DATE_DIFUZARI
) AS
    EXCEPTIE_DATE_INVALIDE EXCEPTION;
    EXCEPTIE_REZERVARE_INVALIDA EXCEPTION;
BEGIN
    IF DATA_INCEPUT_PARAM > DATA_SFARSIT_PARAM THEN
        RAISE EXCEPTIE_DATE_INVALIDE;
    END IF;

    DATE_DIFUZARI := DIFUZARI_FILM_IN_INTERVAL_DE_TIMP_DATE_DIFUZARI();
    FOR DATE_DIFUZARE IN (
        SELECT
            FD.TITLU,
            FD.DATA,
            FD.ID_SALA,
            FD.COD_SALA,
            FD.PRET,
            FD.ID_DIFUZARE,
            L.COD,
            L.ID_SALA      AS ID_SALA_LOC,
            C.NUME
            || ' '
            || C.PRENUME   AS NUME_COMPLET
        FROM
            (
                SELECT
                    F.TITLU,
                    D.ID_DIFUZARE,
                    D.DATA,
                    D.PRET,
                    S.ID_SALA,
                    S.COD         AS COD_SALA
                FROM
                    (
                        SELECT
                            *
                        FROM
                            FILME F
                        WHERE
                            F.ID_FILM = ID_FILM_PARAM
                    )        F
                    INNER JOIN DIFUZARI D
                    ON D.ID_FILM = F.ID_FILM
                    INNER JOIN SALI S
                    ON S.ID_SALA = D.ID_SALA
                WHERE
                    D.DATA BETWEEN DATA_INCEPUT_PARAM AND DATA_SFARSIT_PARAM
            )         FD
            INNER JOIN REZERVARI R
            ON FD.ID_DIFUZARE = R.ID_DIFUZARE
            INNER JOIN LOCURI L
            ON L.ID_LOC = R.ID_LOC
            INNER JOIN CLIENTI C
            ON C.ID_CLIENT = R.ID_CLIENT
    ) LOOP
        IF DATE_DIFUZARE.ID_SALA != DATE_DIFUZARE.ID_SALA_LOC THEN
            RAISE EXCEPTIE_REZERVARE_INVALIDA;
        END IF;

        DATE_DIFUZARI.EXTEND;
        DATE_DIFUZARI(DATE_DIFUZARI.COUNT) := DIFUZARI_FILM_IN_INTERVAL_DE_TIMP_DATE_DIFUZARE( DATE_DIFUZARE.ID_DIFUZARE, DATE_DIFUZARE.COD_SALA, DATE_DIFUZARE.TITLU, DATE_DIFUZARE.DATA, DATE_DIFUZARE.PRET, DATE_DIFUZARE.NUME_COMPLET, DATE_DIFUZARE.COD );
    END LOOP;
EXCEPTION
    WHEN EXCEPTIE_DATE_INVALIDE THEN
        RAISE_APPLICATION_ERROR(-20002, 'Data de inceput succede data de sfarsit.');
    WHEN EXCEPTIE_REZERVARE_INVALIDA THEN
        RAISE_APPLICATION_ERROR(-20003, 'O rezervare invalida a fost gasita in lista rezervarilor asociate difuzarilor.');
END DIFUZARI_FILM_IN_INTERVAL_DE_TIMP;