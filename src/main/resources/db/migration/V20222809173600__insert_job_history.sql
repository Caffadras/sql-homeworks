INSERT INTO regions
    VALUES (1, 'Ciocana');

INSERT INTO countries
    VALUES ('MD', 'Moldova', 1);

INSERT INTO locations
    VALUES (10, 'Alecu Russo', 'MD-2044', 'Chisinau', 'Chisinau', 'MD', 0);

INSERT INTO jobs
    VALUES ('IT_JAVA', 'Java Developer', 500, 3000);

INSERT INTO departments
    VALUES (4, 'IT Development', NULL, 10);

INSERT INTO employees
    VALUES (100, 'Vasea', 'Pupkin', 'someemail@gmail.com', '+37368775566', date'2021-05-05', 'IT_JAVA', 1000, 0.20, NULL, 4);

INSERT INTO job_history
    VALUES (100, date'2020-01-01', date'2021-01-01', 'IT_JAVA', 4);