CREATE TABLE IF NOT EXISTS product_type
(
    id   INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE SEQUENCE product_type_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER product_type_bi
    BEFORE INSERT
    ON product_type
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT product_type_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;

CREATE TABLE IF NOT EXISTS product
(
    id              INT PRIMARY KEY,
    name            VARCHAR(50) NOT NULL,
    product_type_id INT         NOT NULL,
    FOREIGN KEY (product_type_id) REFERENCES product_type (id)
);

CREATE SEQUENCE product_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER product_bi
    BEFORE INSERT
    ON product
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT product_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;
