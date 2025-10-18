CREATE TABLE IF NOT EXISTS client
(
    id            INT PRIMARY KEY,
    first_name    VARCHAR(200) NOT NULL,
    last_name     VARCHAR(200) NOT NULL,
    address       VARCHAR(200) NOT NULL,
    birthday      DATE         NOT NULL,
    status        VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    department_id INT          NOT NULL,
    FOREIGN KEY (department_id) REFERENCES department (id)
);

CREATE SEQUENCE client_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER client_bi
    BEFORE INSERT
    ON client
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT client_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;
