CREATE TABLE IF NOT EXISTS inventory
(
    id          INT PRIMARY KEY,
    store_id    INT  NOT NULL,
    employee_id INT  NOT NULL,
    created_at  DATE NOT NULL,
    date_start  DATE,
    date_end    DATE,
    status      VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    FOREIGN KEY (store_id) REFERENCES store (id),
    FOREIGN KEY (employee_id) REFERENCES employee (id)
);

CREATE SEQUENCE inventory_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER inventory_bi
    BEFORE INSERT
    ON inventory
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT inventory_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;

CREATE TABLE IF NOT EXISTS inventory_detail
(
    id               INT PRIMARY KEY,
    inventory_id     INT NOT NULL,
    product_id       INT NOT NULL,
    quantity_start   INT,
    quantity_end     INT,
    quantity_current INT,
    price_start      DECIMAL(10, 2),
    price_end        DECIMAL(10, 2),
    price_current    DECIMAL(10, 2),
    transaction_date DATE,
    FOREIGN KEY (inventory_id) REFERENCES inventory (id),
    FOREIGN KEY (product_id) REFERENCES product (id)
);

CREATE SEQUENCE inventory_detail_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER inventory_detail_bi
    BEFORE INSERT
    ON inventory_detail
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT inventory_detail_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;
