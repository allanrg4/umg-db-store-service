CREATE TABLE IF NOT EXISTS supplier
(
    id            INT PRIMARY KEY,
    company_name  VARCHAR(255) NOT NULL,
    address       VARCHAR(255) NOT NULL,
    status        VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    department_id INT          NOT NULL,
    FOREIGN KEY (department_id) REFERENCES department (id)
);

CREATE SEQUENCE supplier_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER supplier_bi
    BEFORE INSERT
    ON supplier
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT supplier_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;

CREATE TABLE IF NOT EXISTS supplier_product
(
    id          INT PRIMARY KEY,
    supplier_id INT            NOT NULL,
    product_id  INT            NOT NULL,
    price       DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES supplier (id),
    FOREIGN KEY (product_id) REFERENCES product (id)
);

CREATE SEQUENCE supplier_product_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER supplier_product_bi
    BEFORE INSERT
    ON supplier_product
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT supplier_product_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;
