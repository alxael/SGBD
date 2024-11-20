-- Aelenei Alex, Grupa 252
-- ex. 30
WITH salary_averages AS (
    SELECT
        d.department_id,
        FLOOR(AVG(e.salary)) as average
    FROM
        departments d
        INNER JOIN employees e ON d.department_id = e.department_id
    GROUP BY
        d.department_id
    ORDER BY
        d.department_id
)
SELECT
    e.*
FROM
    employees e
    INNER JOIN salary_averages sa ON e.department_id = sa.department_id
WHERE
    e.salary > sa.average;

-- ex. 31
WITH promotion_count AS (
    SELECT
        COUNT(jh.employee_id) AS count,
        jh.employee_id
    FROM
        job_history jh
    GROUP BY
        jh.employee_id
)
SELECT
    e.*,
    pc.count AS "Promotion count"
FROM
    employees e
    LEFT JOIN promotion_count pc ON e.employee_id = pc.employee_id;

-- ex. 32
SELECT
    *
FROM
    (
        SELECT
            e.employee_id,
            e.job_id,
            e.salary
        FROM
            employees e
        ORDER BY
            e.employee_id
    )
UNION
SELECT
    *
FROM
    (
        SELECT
            jh.employee_id,
            jh.job_id,
            1000 AS salary
            /* salariul nu e inclus in job_history asa ca am pus o valoare default */
        FROM
            job_history jh
    );

SET SERVEROUTPUT ON
SET VERIFY OFF
    
DECLARE 

v_location_id NUMBER := &location_id;
v_department_count NUMBER;

BEGIN
SELECT
    COUNT(*) INTO v_department_count
FROM
    (
        SELECT
            *
        FROM
            departments d
        WHERE
            d.location_id = v_location_id
    );

DBMS_OUTPUT.PUT_LINE(
    'Sunt ' || v_department_count || ' departamente la locatia cu ID-ul ' || v_location_id || ''
);

END;

/