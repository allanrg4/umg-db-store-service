CREATE TABLE IF NOT EXISTS purchase
(
    id               INT PRIMARY KEY,
    purchase_type    VARCHAR(50)    NOT NULL CHECK (purchase_type IN ('order', 'return')),
    document         VARCHAR(100)   NOT NULL,
    sequence         VARCHAR(50)    NOT NULL,
    total            DECIMAL(10, 2) NOT NULL,
    transaction_date DATE           NOT NULL,
    transaction_user VARCHAR(100)   NOT NULL,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    employee_id      INT            NOT NULL,
    store_id         INT            NOT NULL,
    supplier_id      INT            NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employee (id),
    FOREIGN KEY (store_id) REFERENCES store (id),
    FOREIGN KEY (supplier_id) REFERENCES supplier (id)
);

CREATE SEQUENCE purchase_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER purchase_bi
    BEFORE INSERT
    ON purchase
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT purchase_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;

CREATE TABLE IF NOT EXISTS purchase_detail
(
    id               INT PRIMARY KEY,
    line             INT            NOT NULL,
    purchase_id      INT            NOT NULL,
    product_id       INT            NOT NULL,
    quantity         INT            NOT NULL,
    price            DECIMAL(10, 2) NOT NULL,
    transaction_date DATE           NOT NULL,
    transaction_user VARCHAR(100)   NOT NULL,
    FOREIGN KEY (purchase_id) REFERENCES purchase (id),
    FOREIGN KEY (product_id) REFERENCES product (id)
);

CREATE SEQUENCE purchase_detail_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER purchase_detail_bi
    BEFORE INSERT
    ON purchase_detail
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT purchase_detail_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;

CREATE TABLE IF NOT EXISTS sale
(
    id               INT PRIMARY KEY,
    sale_type        VARCHAR(50)    NOT NULL CHECK (sale_type IN ('sale', 'return')),
    document         VARCHAR(100)   NOT NULL,
    sequence         VARCHAR(50)    NOT NULL,
    total            DECIMAL(10, 2) NOT NULL,
    transaction_date DATE           NOT NULL,
    transaction_user VARCHAR(100)   NOT NULL,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    store_id         INT            NOT NULL,
    employee_id      INT            NOT NULL,
    client_id        INT            NOT NULL,
    FOREIGN KEY (store_id) REFERENCES store (id),
    FOREIGN KEY (employee_id) REFERENCES employee (id),
    FOREIGN KEY (client_id) REFERENCES client (id)
);

CREATE SEQUENCE sale_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER sale_bi
    BEFORE INSERT
    ON sale
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT sale_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;

CREATE TABLE IF NOT EXISTS sale_detail
(
    id               INT PRIMARY KEY,
    line             INT            NOT NULL,
    sale_id          INT            NOT NULL,
    product_id       INT            NOT NULL,
    quantity         INT            NOT NULL,
    price            DECIMAL(10, 2) NOT NULL,
    transaction_date DATE           NOT NULL,
    transaction_user VARCHAR(100)   NOT NULL,
    FOREIGN KEY (sale_id) REFERENCES sale (id),
    FOREIGN KEY (product_id) REFERENCES product (id)
);

CREATE SEQUENCE sale_detail_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER sale_detail_bi
    BEFORE INSERT
    ON sale_detail
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT sale_detail_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;
