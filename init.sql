DROP DATABASE IF EXISTS shop_db;
CREATE DATABASE shop_db;
USE shop_db;

CREATE TABLE transactions
(
    id          VARCHAR(36)    NOT NULL,
    created_at  DATETIME       NOT NULL,
    customer_id INT            NOT NULL,
    amount      DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE transaction_log
(
    id         MEDIUMINT   NOT NULL AUTO_INCREMENT,
    txn_id     VARCHAR(36) NOT NULL,
    created_at DATETIME    NOT NULL,
    operation  VARCHAR(36) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE counters
(
    counter_name VARCHAR(255) NOT NULL,
    customer_id  INT          NOT NULL,
    value        INT DEFAULT 0,
    PRIMARY KEY (counter_name, customer_id)
);


CREATE PROCEDURE Increment_amount_counter(
    IN counter_name VARCHAR(255),
    IN customer_id INT,
    IN amount DECIMAL(10, 2)
)
BEGIN
    INSERT INTO counters (counter_name, customer_id, value)
    VALUES (counter_name, customer_id, amount)
    ON DUPLICATE KEY UPDATE value = value + amount;
END;


CREATE PROCEDURE Increment_quantity_counter(
    IN counter_name VARCHAR(255),
    IN customer_id INT)
BEGIN
    INSERT INTO counters (counter_name, customer_id, value)
    VALUES (counter_name, customer_id, 1)
    ON DUPLICATE KEY UPDATE value = value + 1;
END;


CREATE PROCEDURE Decrement_amount_counter(
    IN counter_name VARCHAR(255),
    IN customer_id INT,
    IN amount DECIMAL(10, 2)
)
BEGIN
    INSERT INTO counters (counter_name, customer_id, value)
    VALUES (counter_name, customer_id, 0)
    ON DUPLICATE KEY UPDATE value = value - amount;
END;

CREATE PROCEDURE Decrement_quantity_counter(
    IN counter_name VARCHAR(255),
    IN customer_id INT)
BEGIN
    INSERT INTO counters (counter_name, customer_id, value)
    VALUES (counter_name, customer_id, 0)
    ON DUPLICATE KEY UPDATE value = value - 1;
END;

CREATE PROCEDURE Create_Transaction_Log_Entry(
    IN txn_id VARCHAR(36),
    IN operation VARCHAR(36)
)
BEGIN
    INSERT INTO transaction_log (txn_id, created_at, operation)
    VALUES (txn_id, NOW(), operation);
END;


CREATE TRIGGER after_transaction_insert_trigger
    AFTER INSERT
    ON transactions
    FOR EACH ROW
BEGIN
    CALL Increment_quantity_counter('minutely_quantity_txn', NEW.customer_id);
    CALL Increment_amount_counter('minutely_amount_txn', NEW.customer_id, NEW.amount);
    CALL Increment_quantity_counter('daily_quantity_txn', NEW.customer_id);
    CALL Increment_amount_counter('daily_amount_txn', NEW.customer_id, NEW.amount);
    CALL Increment_quantity_counter('monthly_quantity_txn', NEW.customer_id);
    CALL Increment_amount_counter('monthly_amount_txn', NEW.customer_id, NEW.amount);
    CALL Create_Transaction_Log_Entry(NEW.id, 'CREATED');
END;


CREATE TRIGGER after_transaction_delete_trigger
    AFTER DELETE
    ON transactions
    FOR EACH ROW
BEGIN
    CALL Decrement_quantity_counter('minutely_quantity_txn', OLD.customer_id);
    CALL Decrement_amount_counter('minutely_amount_txn', OLD.customer_id, OLD.amount);
    CALL Decrement_quantity_counter('daily_quantity_txn', OLD.customer_id);
    CALL Decrement_amount_counter('daily_amount_txn', OLD.customer_id, OLD.amount);
    CALL Decrement_quantity_counter('monthly_quantity_txn', OLD.customer_id);
    CALL Decrement_amount_counter('monthly_amount_txn', OLD.customer_id, OLD.amount);
    CALL Create_Transaction_Log_Entry(OLD.id, 'DELETED');
END;

CREATE TRIGGER after_transaction_update_trigger
    AFTER UPDATE
    ON transactions
    FOR EACH ROW
BEGIN
    CALL Decrement_quantity_counter('minutely_quantity_txn', OLD.customer_id);
    CALL Decrement_amount_counter('minutely_amount_txn', OLD.customer_id, OLD.amount);
    CALL Decrement_quantity_counter('daily_quantity_txn', OLD.customer_id);
    CALL Decrement_amount_counter('daily_amount_txn', OLD.customer_id, OLD.amount);
    CALL Decrement_quantity_counter('monthly_quantity_txn', OLD.customer_id);
    CALL Decrement_amount_counter('monthly_amount_txn', OLD.customer_id, OLD.amount);
    CALL Increment_quantity_counter('minutely_quantity_txn', NEW.customer_id);
    CALL Increment_amount_counter('minutely_amount_txn', NEW.customer_id, NEW.amount);
    CALL Increment_quantity_counter('daily_quantity_txn', NEW.customer_id);
    CALL Increment_amount_counter('daily_amount_txn', NEW.customer_id, NEW.amount);
    CALL Increment_quantity_counter('monthly_quantity_txn', NEW.customer_id);
    CALL Increment_amount_counter('monthly_amount_txn', NEW.customer_id, NEW.amount);
    CALL Create_Transaction_Log_Entry(NEW.id, 'UPDATED');
END;


CREATE EVENT reset_minute_counters
    ON SCHEDULE EVERY 1 MINUTE
    DO
    UPDATE counters
    SET value = 0
    WHERE counter_name LIKE 'minutely_%';

CREATE EVENT reset_daily_counters
    ON SCHEDULE EVERY 1 DAY STARTS TIMESTAMP(CURRENT_DATE, '08:00:00')
    DO
    UPDATE counters
    SET value = 0
    WHERE counter_name LIKE 'daily_%';

CREATE EVENT reset_monthly_counters
    ON SCHEDULE EVERY 1 MONTH STARTS LAST_DAY(CURRENT_DATE) + INTERVAL 1 DAY
    DO
    UPDATE counters
    SET value = 0
    WHERE counter_name LIKE 'monthly_%';
