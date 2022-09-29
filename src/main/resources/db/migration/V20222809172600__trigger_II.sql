--Procedure to add a row to employment_logs table
CREATE OR REPLACE PROCEDURE add_employment_logs_row(
    p_first_name        employment_logs.first_name%type,
    p_last_name         employment_logs.last_name%type,
    p_employment_action employment_logs.employment_action%type
)
AS
BEGIN
    INSERT INTO employment_logs(first_name, last_name, employment_action, employment_status_updtd_tmstmp)
    VALUES(p_first_name, p_last_name, p_employment_action, SYSTIMESTAMP);
END;

--trigger to audit employment changes
CREATE OR REPLACE TRIGGER employment_logs_trig
    AFTER INSERT OR DELETE ON employees
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        add_employment_logs_row(:NEW.first_name, :NEW.last_name, 'HIRED');
    ELSE
        add_employment_logs_row(:OLD.first_name, :OLD.last_name, 'FIRED');
    END IF;
END employment_logs_trig;
