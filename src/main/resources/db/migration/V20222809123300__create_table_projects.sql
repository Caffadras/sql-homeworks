CREATE TABLE projects
(
  project_id NUMBER(6) PRIMARY KEY,
  project_description VARCHAR(255),
  project_investments NUMBER (4, -3),
  project_revenue NUMBER (6),

  CONSTRAINT project_descr_len CHECK (LENGTH(project_description) > 10),
  CONSTRAINT project_invest_check CHECK (project_investments> 0)
);

CREATE SEQUENCE project_seq MINVALUE 1 MAXVALUE 9990 INCREMENT BY 10 START WITH 10;

ALTER TABLE projects
    MODIFY project_id DEFAULT project_seq.nextval;

COMMENT ON TABLE projects IS 'Project table that contains information about projects: description, investments, revenue.';
COMMENT ON COLUMN projects.project_id IS 'Primary key of the table';
COMMENT ON COLUMN projects.project_description IS 'Description of the project.
Length must be greater than 10 and smaller than 10';
COMMENT ON COLUMN projects.project_investments IS 'Project Investments. Must be greater than 0';
COMMENT ON COLUMN projects.project_revenue IS 'Revenue of the project';