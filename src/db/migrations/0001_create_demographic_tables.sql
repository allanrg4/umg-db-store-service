CREATE TABLE IF NOT EXISTS department
(
    id   INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE SEQUENCE department_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER department_bi
    BEFORE INSERT
    ON department
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT department_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;

CREATE TABLE IF NOT EXISTS municipality
(
    id            INT PRIMARY KEY,
    name          VARCHAR(50) NOT NULL,
    department_id INT         NOT NULL,
    FOREIGN KEY (department_id) REFERENCES department (id) ON DELETE CASCADE
);

CREATE SEQUENCE municipality_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER municipality_bi
    BEFORE INSERT
    ON municipality
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT municipality_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;
