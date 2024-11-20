SET VERIFY OFF

SET FEEDBACK ON

SET SERVEROUTPUT ON

DECLARE
    TYPE TAB_IND IS
        TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    T TAB_IND;
BEGIN
    FOR ENTRY IN (
        SELECT
            E.EMPLOYEE_ID,
            E.SALARY
        FROM
            (
                SELECT
                    *
                FROM
                    EMPLOYEES E
                WHERE
                    E.COMMISSION_PCT IS NULL
                ORDER BY
                    E.SALARY ASC
            ) E
        WHERE
            ROWNUM <= 5
    ) LOOP
 
        -- T(ENTRY.EMPLOYEE_ID) := ENTRY.SALARY;
        DBMS_OUTPUT.PUT_LINE('hello');
    END LOOP;

    FOR I IN T.FIRST..T.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(T(I));
    END LOOP;
END;
/

SET VERIFY ON

SET FEEDBACK OFF

SET SERVEROUTPUT OFF