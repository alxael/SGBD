BEGIN
    FOR VAL IN (
        SELECT
            TABLE_NAME
        FROM
            USER_TABLES
    ) LOOP
        EXECUTE IMMEDIATE ('DROP TABLE "'
                           || VAL.TABLE_NAME
                           || '" CASCADE CONSTRAINTS');
    END LOOP;
END;