-- Laborator 3 E2 - numar de ordine
SET SERVEROUTPUT ON;

DECLARE
    JOB_TITLE      JOBS.JOB_TITLE%TYPE;
    EMPLOYEE_ORDER NUMBER;
    SALARY         EMPLOYEES.SALARY%TYPE;
    JOB            JOBS%ROWTYPE;
    EMPLOYEE       EMPLOYEES%ROWTYPE;
    CURSOR JC IS (
        SELECT
            *
        FROM
            JOBS
    );
    CURSOR EC(
        EMPLOYEE_JOB_ID JOBS.JOB_ID%TYPE
    ) IS (
        SELECT
            *
        FROM
            EMPLOYEES E
        WHERE
            (E.JOB_ID = EMPLOYEE_JOB_ID)
            OR (EMPLOYEE_JOB_ID IS NULL
            AND E.JOB_ID IS NULL)
    );
BEGIN
    OPEN JC;
    LOOP
        FETCH JC INTO JOB;
        EXIT WHEN JC%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(JOB.JOB_TITLE);
        EMPLOYEE_ORDER := 0;
        OPEN EC(JOB.JOB_ID);
        LOOP
            FETCH EC INTO EMPLOYEE;
            EXIT WHEN EC%NOTFOUND;
            EMPLOYEE_ORDER := EMPLOYEE_ORDER + 1;
            SALARY := EMPLOYEE.SALARY * (1 + NVL(EMPLOYEE.COMMISSION_PCT, 0));
            DBMS_OUTPUT.PUT_LINE(EMPLOYEE_ORDER
                                 || '. '
                                 || EMPLOYEE.FIRST_NAME
                                 || ' '
                                 || EMPLOYEE.LAST_NAME
                                 || ' - Salary: '
                                 || SALARY);
        END LOOP;

        CLOSE EC;
        IF EMPLOYEE_ORDER = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No employees with this job!');
        END IF;

        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;

    CLOSE JC;
    DBMS_OUTPUT.PUT_LINE('Unemployed: ');
    EMPLOYEE_ORDER := 0;
    OPEN EC(NULL);
    LOOP
        FETCH EC INTO EMPLOYEE;
        EXIT WHEN EC%NOTFOUND;
        EMPLOYEE_ORDER := EMPLOYEE_ORDER + 1;
        SALARY := EMPLOYEE.SALARY * (1 + NVL(EMPLOYEE.COMMISSION_PCT, 0));
        DBMS_OUTPUT.PUT_LINE(EMPLOYEE_ORDER
                             || '. '
                             || EMPLOYEE.FIRST_NAME
                             || ' '
                             || EMPLOYEE.LAST_NAME
                             || ' - Salary: '
                             || SALARY);
    END LOOP;

    CLOSE EC;
END;
 

-- Laborator 3 E2
SET SERVEROUTPUT ON;
DECLARE
    JOB_TITLE            JOBS.JOB_TITLE%TYPE;
    EMPLOYEE_COUNT       NUMBER;
    EMPLOYEE_COUNT_TOTAL NUMBER;
    SALARY               NUMBER;
    SALARY_TOTAL         NUMBER;
    JOB                  JOBS%ROWTYPE;
    EMPLOYEE             EMPLOYEES%ROWTYPE;
    CURSOR JC IS (
        SELECT
            *
        FROM
            JOBS
    );
    CURSOR EC(
        EMPLOYEE_JOB_ID JOBS.JOB_ID%TYPE
    ) IS (
        SELECT
            *
        FROM
            EMPLOYEES E
        WHERE
            (E.JOB_ID = EMPLOYEE_JOB_ID)
            OR (EMPLOYEE_JOB_ID IS NULL
            AND E.JOB_ID IS NULL)
    );
BEGIN
    EMPLOYEE_COUNT_TOTAL := 0;
    SALARY_TOTAL := 0;
    OPEN JC;
    LOOP
        FETCH JC INTO JOB;
        EXIT WHEN JC%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(JOB.JOB_TITLE);
        EMPLOYEE_COUNT := 0;
        SALARY := 0;
        OPEN EC(JOB.JOB_ID);
        LOOP
            FETCH EC INTO EMPLOYEE;
            EXIT WHEN EC%NOTFOUND;
            EMPLOYEE_COUNT := EMPLOYEE_COUNT + 1;
            SALARY := SALARY + EMPLOYEE.SALARY * (1 + NVL(EMPLOYEE.COMMISSION_PCT, 0));
        END LOOP;

        IF EMPLOYEE_COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No employees found!');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Employee count: '
                                 || EMPLOYEE_COUNT);
            DBMS_OUTPUT.PUT_LINE('Average monthly salary: '
                                 || SALARY / EMPLOYEE_COUNT);
            DBMS_OUTPUT.PUT_LINE('Sum yearly salary: '
                                 || SALARY * 12);
        END IF;

        EMPLOYEE_COUNT_TOTAL := EMPLOYEE_COUNT_TOTAL + EMPLOYEE_COUNT;
        SALARY_TOTAL := SALARY_TOTAL + SALARY;
        CLOSE EC;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;

    CLOSE JC;
    DBMS_OUTPUT.PUT_LINE('Unemployed: ');
    EMPLOYEE_COUNT := 0;
    SALARY := 0;
    OPEN EC(NULL);
    LOOP
        FETCH EC INTO EMPLOYEE;
        EXIT WHEN EC%NOTFOUND;
        EMPLOYEE_COUNT := EMPLOYEE_COUNT + 1;
        SALARY := SALARY + EMPLOYEE.SALARY * (1 + NVL(EMPLOYEE.COMMISSION_PCT, 0));
    END LOOP;

    EMPLOYEE_COUNT_TOTAL := EMPLOYEE_COUNT_TOTAL + EMPLOYEE_COUNT;
    SALARY_TOTAL := SALARY_TOTAL + SALARY;
    CLOSE EC;
    IF EMPLOYEE_COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No employees found!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Employee count: '
                             || EMPLOYEE_COUNT);
        DBMS_OUTPUT.PUT_LINE('Average monthly salary: '
                             || SALARY / EMPLOYEE_COUNT);
        DBMS_OUTPUT.PUT_LINE('Sum yearly salary: '
                             || SALARY * 12);
    END IF;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Total employee count: '
                         || EMPLOYEE_COUNT_TOTAL);
    DBMS_OUTPUT.PUT_LINE('Total average monthly salary: '
                         || SALARY_TOTAL / EMPLOYEE_COUNT_TOTAL);
    DBMS_OUTPUT.PUT_LINE('Total sum yearly salary: '
                         || SALARY_TOTAL * 12);
END;
 

-- Laborator 4 E1
SET SERVEROUTPUT ON;
DECLARE
    V_NUME EMPLOYEES.LAST_NAME%TYPE := INITCAP('&p_nume');

    FUNCTION F1_AAE RETURN NUMBER IS
        SALARIU EMPLOYEES.SALARY%TYPE;
    BEGIN
        SELECT
            SALARY INTO SALARIU
        FROM
            EMPLOYEES
        WHERE
            LAST_NAME = V_NUME;
        RETURN SALARIU;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Alta eroare!');
    END F1_AAE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Salariul este '
                         || F1_AAE);
    FOR ENTRY IN (
        SELECT
            *
        FROM
            USER_OBJECTS
        WHERE
            OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION')
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(ENTRY.OBJECT_NAME);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroarea are codul = '
                             ||SQLCODE
                             || ' si mesajul = '
                             || SQLERRM);
END;
/