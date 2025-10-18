CREATE TABLE IF NOT EXISTS promotion
(
    id         INT PRIMARY KEY,
    store_id   INT          NOT NULL,
    name       VARCHAR(255) NOT NULL,
    status     VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    date_start DATE         NOT NULL,
    date_end   DATE         NOT NULL,
    FOREIGN KEY (store_id) REFERENCES store (id)
);

CREATE SEQUENCE promotion_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER promotion_bi
    BEFORE INSERT
    ON promotion
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT promotion_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;

CREATE TABLE IF NOT EXISTS promotion_product
(
    id           INT PRIMARY KEY,
    promotion_id INT NOT NULL,
    product_id   INT NOT NULL,
    FOREIGN KEY (promotion_id) REFERENCES promotion (id),
    FOREIGN KEY (product_id) REFERENCES product (id)
);

CREATE SEQUENCE promotion_product_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER promotion_product_bi
    BEFORE INSERT
    ON promotion_product
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT promotion_product_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;
