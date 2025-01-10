DECLARE
    NUME_CATEGORIE VARCHAR2(255) := '&DENUMIRE_CATEGORIE';
    CURSOR_FILM    SYS_REFCURSOR;
    DATE_FILM      FILME%ROWTYPE;
BEGIN
    CURSOR_FILM := FILME_IN_CATEGORIE(NUME_CATEGORIE);
    LOOP
        FETCH CURSOR_FILM INTO DATE_FILM;
        EXIT WHEN CURSOR_FILM%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(''''
                             || DATE_FILM.TITLU
                             || ''' - durata: '
                             || DATE_FILM.DURATA
                             || ' minute - data aparitiei: '
                             || TO_CHAR(DATE_FILM.DATA_PUBLICARE, 'dd/mm/yyyy'));
    END LOOP;
END;