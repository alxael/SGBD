SET SERVEROUTPUT ON

DECLARE
    START_DATE             DATE := TO_DATE('2025/09/15', 'yyyy/mm/dd');
    END_DATE               DATE := TO_DATE('2025/09/30', 'yyyy/mm/dd');
    RESERVATIONS_COUNT     NUMBER(10) := 10;
    MOVIE_WITH_MAX_REVENUE MOVIE_STATISTICS.MOVIE_ID_REVENUE;
BEGIN
    FOR MOVIE_RESERVATIONS IN MOVIE_STATISTICS.MOVIES_WITH_MINIMUM_RESERVATIONS(START_DATE, END_DATE, RESERVATIONS_COUNT) LOOP
        DBMS_OUTPUT.PUT_LINE('Filmul '
                             || MOVIE_RESERVATIONS.MOVIE_ID
                             || ' are in perioada '
                             || TO_CHAR(START_DATE, 'dd.mm.yyyy')
                                || ' - '
                                || TO_CHAR(END_DATE, 'dd.mm.yyyy')
                                   || ' '
                                   || MOVIE_RESERVATIONS.RESERVATIONS_COUNT
                                   || ' rezervari.');
    END LOOP;

    DBMS_OUTPUT.NEW_LINE;
    MOVIE_WITH_MAX_REVENUE := MOVIE_STATISTICS.MOVIE_WITH_MAX_REVENUE(START_DATE, END_DATE);
    DBMS_OUTPUT.PUT_LINE('Filmul '
                         || MOVIE_WITH_MAX_REVENUE.MOVIE_ID
                         || ' a generat in perioada '
                         || TO_CHAR(START_DATE, 'dd.mm.yyyy')
                            || ' - '
                            || TO_CHAR(END_DATE, 'dd.mm.yyyy')
                               || ' cele mai multe venituri, si anume '
                               || MOVIE_WITH_MAX_REVENUE.REVENUE
                               || '.');
END;