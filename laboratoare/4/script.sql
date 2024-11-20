SET VERIFY OFF

SET FEEDBACK ON

SET SERVEROUTPUT ON

DECLARE
    E_NAME        EMPLOYEES.LAST_NAME%TYPE:='&EMPLOYEE_NAME';
    E_ID          EMPLOYEES.EMPLOYEE_ID%TYPE;
    E_COUNT       NUMBER(10);
    E_TOTAL_COUNT NUMBER(10);
    E_RATIO       NUMBER(10, 2);
    E_CATEGORY    NUMBER(10);
BEGIN
    SELECT
        E.EMPLOYEE_ID INTO E_ID
    FROM
        EMPLOYEES E
    WHERE
        LOWER(E_NAME) = LOWER(E.LAST_NAME);
    SELECT
        COUNT(*) INTO E_COUNT
    FROM
        EMPLOYEES E
    WHERE
        E.MANAGER_ID = E_ID;
    SELECT
        COUNT(*) INTO E_TOTAL_COUNT
    FROM
        EMPLOYEES;
    E_RATIO := E_COUNT / E_TOTAL_COUNT;
    CASE
        WHEN E_RATIO >= 0.6
        THEN
            E_CATEGORY := 1;
        WHEN E_RATIO >= 0.4
        THEN
            E_CATEGORY := 2;
        WHEN E_RATIO >= 0.1
        THEN
            E_CATEGORY := 3;
        ELSE
            E_CATEGORY := 4;
    END CASE;

    DBMS_OUTPUT.PUT_LINE('Categoria angajatului este '
                         || TO_CHAR(E_CATEGORY));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu a fost gasit un angajat cu numele dat');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Exista mai mult de un angajat cu numele dat');
END;
/

SET VERIFY ON

SET FEEDBACK OFF

SET SERVEROUTPUT OFF