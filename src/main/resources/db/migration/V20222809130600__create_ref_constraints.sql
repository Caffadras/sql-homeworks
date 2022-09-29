--------------------------------------------------------
--  Ref Constraints for Table pay
--------------------------------------------------------
ALTER TABLE pay
    ADD CONSTRAINT pay_emp_fk FOREIGN KEY (employee_id)
        REFERENCES employees (employee_id);

--------------------------------------------------------
--  Ref Constraints for Table project_employees
--------------------------------------------------------
ALTER TABLE project_employees
    ADD CONSTRAINT projemp_proj_id_fk FOREIGN KEY (project_id)
        REFERENCES projects (project_id)
    ADD CONSTRAINT projemp_emp_id_fk FOREIGN KEY (employee_id)
        REFERENCES employees (employee_id);


