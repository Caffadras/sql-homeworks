CREATE TABLE project_employees
(
    project_id NUMBER(6) NOT NULL,
    employee_id NUMBER(6) NOT NULL,
    hours_worked NUMBER(6),

    CONSTRAINT hours_worked_min CHECK ( hours_worked >=0 ),
    CONSTRAINT proj_id_emp_id_pk PRIMARY KEY (project_id, employee_id)
);

COMMENT ON TABLE project_employees IS 'Join table between projects and employees.
Contains complex primary key (project_id + employee_id)';
COMMENT ON COLUMN project_employees.project_id IS 'Foreign key, references projects table.';
COMMENT ON COLUMN project_employees.employee_id IS  'Foreign key, references employees table.';
COMMENT ON COLUMN project_employees.hours_worked IS  'Number of hours an employee has worked on a project. Must be >=0';