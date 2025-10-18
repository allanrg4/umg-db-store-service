CREATE TABLE IF NOT EXISTS store
(
    id              INT PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    address         VARCHAR(200) NOT NULL,
    municipality_id INT          NOT NULL,
    FOREIGN KEY (municipality_id) REFERENCES municipality (id)
);

CREATE SEQUENCE store_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER store_bi
    BEFORE INSERT
    ON store
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT store_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;

CREATE TABLE IF NOT EXISTS aisle
(
    id       INT PRIMARY KEY,
    name     VARCHAR(50) NOT NULL,
    store_id INT         NOT NULL,
    FOREIGN KEY (store_id) REFERENCES store (id)
);

CREATE SEQUENCE aisle_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER aisle_bi
    BEFORE INSERT
    ON aisle
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT aisle_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;

CREATE TABLE IF NOT EXISTS shelf
(
    id          INT PRIMARY KEY,
    description VARCHAR(50) NOT NULL,
    aisle_id    INT         NOT NULL,
    FOREIGN KEY (aisle_id) REFERENCES aisle (id)
);

CREATE SEQUENCE shelf_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER shelf_bi
    BEFORE INSERT
    ON shelf
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT shelf_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;

CREATE TABLE IF NOT EXISTS slot
(
    id          INT PRIMARY KEY,
    shelf_id    INT            NOT NULL,
    product_id  INT            NOT NULL,
    price       DECIMAL(10, 2) NOT NULL,
    description VARCHAR(100),
    FOREIGN KEY (shelf_id) REFERENCES shelf (id),
    FOREIGN KEY (product_id) REFERENCES product (id)
);

CREATE SEQUENCE slot_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER slot_bi
    BEFORE INSERT
    ON slot
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT slot_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;

CREATE TABLE IF NOT EXISTS employee_type
(
    id   INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE SEQUENCE employee_type_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER employee_type_bi
    BEFORE INSERT
    ON employee_type
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT employee_type_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;

CREATE TABLE IF NOT EXISTS employee
(
    id               INT PRIMARY KEY,
    first_name       VARCHAR(200) NOT NULL,
    last_name        VARCHAR(200) NOT NULL,
    address          VARCHAR(200) NOT NULL,
    employee_type_id INT          NOT NULL,
    store_id         INT          NOT NULL,
    FOREIGN KEY (employee_type_id) REFERENCES employee_type (id),
    FOREIGN KEY (store_id) REFERENCES store (id)
);

CREATE SEQUENCE employee_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER employee_bi
    BEFORE INSERT
    ON employee
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT employee_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;
