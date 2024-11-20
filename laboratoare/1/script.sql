-- Aelenei Alex, Grupa 252

-- ex. 9
SELECT
    *
FROM
    employees e
WHERE
    lower(e.last_name) like '__a%';

-- ex. 10
SELECT
    *
FROM
    employees e
WHERE
    lower(concat(e.last_name, e.first_name)) LIKE '%l%l%'
    AND (
        e.department_id = 30
        OR e.manager_id = 102
    );

-- ex. 11
SELECT
    *
FROM
    employees e
    INNER JOIN jobs j ON j.job_id = e.job_id
WHERE
    (
        upper(j.job_title) LIKE '%CLERK%'
        OR upper(j.job_title) LIKE '%REP%'
    )
    AND e.salary NOT IN (1000, 2000, 3000);