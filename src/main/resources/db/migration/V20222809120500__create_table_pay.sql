CREATE TABLE pay
(
  cardNr NUMBER(16) PRIMARY KEY,
  employee_id NUMBER(6) UNIQUE NOT NULL,
  salary NUMBER(6) NOT NULL,
  commission_pct NUMBER(2, 2),

  CONSTRAINT cardNr_check CHECK (cardNr > 0)
);

COMMENT ON TABLE pay IS 'Pay table that contains card number of employees and their salary.
One to one relationship with employee';
COMMENT ON COLUMN pay.cardNr IS 'Primary key, 16 digits card number';
COMMENT ON COLUMN pay.employee_id IS 'Foreign key, employees id';
COMMENT ON COLUMN pay.salary IS 'Employees salary';
COMMENT ON COLUMN pay.commission_pct IS 'Employees commission';