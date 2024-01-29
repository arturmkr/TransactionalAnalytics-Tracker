INSERT INTO transactions (id, created_at, customer_id, amount)
VALUES ('c5b1b3ba-a263-4064-b4c5-acfdb17664f4','2023-01-26 10:00:00', 1, 150.00);

INSERT INTO transactions (id, created_at, customer_id, amount)
VALUES ('1b40ec49-b1fd-4a77-b8b5-ac99dbe9ab51','2023-01-26 11:20:00', 1, 200.00);

INSERT INTO transactions (id, created_at, customer_id, amount)
VALUES ('51d6990e-48ac-4d35-b165-26ebc5036ebc','2023-01-26 11:30:00', 1, 600.00);

INSERT INTO transactions (id, created_at, customer_id, amount)
VALUES ('2019d939-77d3-45b0-9b97-c6d03423f60e','2023-01-26 11:40:00', 1, 77.00);

INSERT INTO transactions (id, created_at, customer_id, amount)
VALUES ('74c7d6f1-f43e-4065-971c-43fb3fe3348b','2023-01-26 11:50:00', 1, 500.00);

INSERT INTO transactions (id, created_at, customer_id, amount)
VALUES ('30150450-bc2a-4eb4-84e9-b3ee3b516003','2023-01-26 11:30:00', 2, 400.00);

DELETE FROM transactions WHERE id = '2019d939-77d3-45b0-9b97-c6d03423f60e';

UPDATE transactions SET amount=505 WHERE id = '74c7d6f1-f43e-4065-971c-43fb3fe3348b';