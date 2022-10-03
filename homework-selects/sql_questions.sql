-- Write a query to display: 
-- 1. the first name, last name, salary, and job grade for all employees.
SELECT first_name, last_name, salary, job_title
FROM employees
         LEFT JOIN jobs USING (job_id);

-- 2. the first and last name, department, city, and state province for each employee.
SELECT first_name, last_name, department_name, city, state_province
FROM employees
    LEFT JOIN departments USING (department_id)
    LEFT JOIN locations USING (location_id);

-- 3. the first name, last name, department number and department name, for all employees for departments 80 or 40.
SELECT first_name, last_name, department_name, department_id
FROM employees
    LEFT JOIN departments USING (department_id)
WHERE department_id = 80 or department_id = 40;

-- 4. those employees who contain a letter z to their first name and also display their last name, department, city, and state province.
SELECT first_name, last_name, department_name, city, state_province
FROM employees
    LEFT JOIN departments USING (department_id)
    LEFT JOIN locations USING (location_id)
WHERE LOWER(first_name) LIKE '%z%';

-- 5. the first and last name and salary for those employees who earn less than the employee earn whose number is 182.
SELECT first_name, last_name, salary
from employees
WHERE salary < (
    SELECT salary
    FROM employees
    WHERE employee_id = 182
    );

-- 6. the first name of all employees including the first name of their manager.
SELECT emp.first_name as EmployeeFirst_Name, man.first_name as ManagerFirst_Name
FROM employees emp
    JOIN employees man ON (man.employee_id = emp.manager_id);

-- 7. the first name of all employees and the first name of their manager including those who does not working under any manager.
SELECT e1.first_name, e2.first_name AS manager_name
FROM employees e1
    LEFT JOIN employees e2 ON e1.employee_id = e2.manager_id;

-- 8. the details of employees who manage a department.
SELECT emp.*
FROM employees emp
    INNER JOIN departments ON (emp.employee_id = departments.manager_id);

-- 9. the first name, last name, and department number for those employees who works in the same department as the employee who holds the last name as Taylor.
SELECT first_name, last_name, department_id
FROM employees
WHERE department_id IN (
    SELECT DEPARTMENT_ID
    FROM employees
    WHERE last_name = 'Taylor'
    );

--10. the department name and number of employees in each of the department.
SELECT department_name, COUNT(*) AS employess_count
FROM employees
    INNER JOIN departments USING (department_id)
GROUP BY department_name;

--11.1 the name of the department, average salary and number of employees working in that department who got commission.
--(display departments even if there are no workers with commission)
SELECT department_name, AVG(salary), COUNT(salary) AS employee_count
FROM departments
    LEFT JOIN (
        SELECT salary, department_id
        FROM employees
        WHERE commission_pct IS NOT NULL
        ) USING (department_id)
GROUP BY department_name;

--11.2 the name of the department, average salary and number of employees working in that department who got commission.
--(do NOT display departments if there are no workers with commission)
SELECT department_name, AVG(salary), COUNT(salary) AS employee_count
FROM employees
         INNER JOIN departments USING (department_id)
WHERE commission_pct IS NOT NULL
GROUP BY department_name;

--12. job title and average salary of employees.
SELECT job_title, AVG(salary) AS everage_salary
FROM jobs
    INNER JOIN employees USING (job_id)
GROUP BY job_title;

--13. the country name, city, and number of those departments where at least 2 employees are working.
SELECT country_name, city, department_id
FROM locations
    INNER JOIN countries USING (country_id)
    INNER JOIN departments USING (location_id)
    INNER JOIN employees USING (department_id)
GROUP BY country_name, city, department_id
HAVING COUNT(employee_id) >= 2;

--14. the employee ID, job name, number of days worked in for all those jobs in department 80.
SELECT employee_id, job_title, end_date - start_date AS days_worked
FROM job_history
    INNER JOIN jobs USING (job_id)
WHERE department_id = 80;

--15. the name ( first name and last name ) for those employees who gets more salary than the employee whose ID is 163.
SELECT (first_name || ' ' || last_name) AS employee_name
FROM employees
WHERE salary > (
    SELECT salary
    FROM employees
    WHERE employee_id = 163
    );

--16. the employee id, employee name (first name and last name ) for all employees who earn more than the average salary.
SELECT employee_id, (first_name || ' ' || last_name) AS employee_name
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

--17. the employee name ( first name and last name ), employee id and salary of all employees who report to Payam.
SELECT (first_name || ' ' || last_name) AS emploee_name, employee_id, salary
FROM employees
WHERE manager_id = (
    SELECT employee_id
    FROM employees
    WHERE first_name = 'Payam'
);

--18. the department number, name ( first name and last name ), job and department name for all employees in the Finance department.
SELECT department_id, (first_name || ' ' || last_name) AS emploee_name, job_title, department_name
FROM employees
    INNER JOIN departments USING (department_id)
    INNER JOIN jobs USING (job_id)
WHERE department_name = 'Finance';

--19. all the information of an employee whose id is any of the number 134, 159 and 183.
SELECT *
FROM employees
WHERE employee_id IN (134, 159, 183);

--20. all the information of the employees whose salary is within the range of smallest salary and 2500.
SELECT *
FROM employees
WHERE salary BETWEEN (
    SELECT MIN(salary)
    FROM employees
    ) AND 2500;

--21. all the information of the employees who does not work in those departments where some employees works whose id within the range 100 and 200.
SELECT *
      FROM employees
      WHERE department_id NOT IN (
          SELECT department_id
          FROM employees
                   INNER JOIN departments USING (department_id)
          WHERE employee_id BETWEEN 100 AND 200
      );

--22. all the information for those employees whose id is any id who earn the second highest salary.
SELECT *
FROM employees
WHERE salary IN (SELECT MAX(salary)
                 FROM employees
                 WHERE salary < (SELECT MAX(salary)
                                  FROM employees)
);

--23. the employee name( first name and last name ) and hiredate for all employees in the same department as Clara. Exclude Clara.
SELECT (first_name || ' ' || last_name) AS employee_name, hire_date
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE first_name = 'Clara'
    ) AND first_name != 'Clara';

--24. the employee number and name( first name and last name ) for all employees who work in a department with any employee whose name contains a T.
SELECT employee_id, (first_name || ' ' || last_name) AS employee_name
FROM employees
WHERE department_id in (
    SELECT DISTINCT department_id
    FROM employees
    WHERE (first_name || ' ' || last_name) LIKE '%T%'
);

--25. full name(first and last name), job title, starting and ending date of last jobs for those employees with worked without a commission percentage.
--25.1: if we want to output current job title:
SELECT (first_name || ' ' || last_name) AS employee_name,
       job_title AS current_job_title, MAX(start_date), MAX(end_date)
FROM job_history jh
    INNER JOIN employees emp USING (employee_id)
    INNER JOIN jobs jb ON (emp.job_id = jb.job_id)
WHERE commission_pct IS NULL
GROUP BY first_name, last_name, job_title;

--25.2: if we want to output last job title:
SELECT (first_name || ' ' || last_name) AS employee_name,
       jobs.job_title AS last_job_title, start_date AS last_start_date, end_date  AS last_end_date
FROM job_history jh
         INNER JOIN jobs ON (jobs.job_id = jh.job_id)
         INNER JOIN employees emp ON (emp.employee_id = jh.employee_id)
WHERE (jh.employee_id, start_date, end_date) IN (
    SELECT employee_id, MAX (start_date) , MAX (end_date)
    FROM job_history
    GROUP BY employee_id
) AND commission_pct IS NULL;

--26. the employee number, name( first name and last name ), and salary for all employees who earn more than the average salary and who work in a department with any employee with a J in their name.
SELECT employee_id, (first_name || ' ' || last_name) AS employee_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
)
  AND department_id in (
    SELECT DISTINCT department_id
    FROM employees
    WHERE (first_name || ' ' || last_name) LIKE '%J%'
);

--27. the employee number, name( first name and last name ) and job title for all employees whose salary is smaller than any salary of those employees whose job title is MK_MAN.
SELECT employee_id, (first_name || ' ' || last_name) AS employee_name, job_title
FROM employees
    INNER JOIN jobs USING (job_id)
WHERE salary < ANY(
    SELECT salary
    FROM employees
    WHERE job_id = 'MK_MAN'
);

--28. the employee number, name( first name and last name ) and job title for all employees whose salary is smaller than any salary of those employees whose job title is MK_MAN. Exclude Job title MK_MAN.
SELECT employee_id, (first_name || ' ' || last_name) AS employee_name, job_title
FROM employees
    INNER JOIN jobs USING (job_id)
WHERE salary < ANY(
    SELECT salary
    FROM employees
    WHERE job_id = 'MK_MAN'
) AND job_id != 'MK_MAN'; --Redundant: at this point any salary is smaller than MIN(salary) with job_id 'MK_MAN', thus, job_id will never be 'MK_MAN'


--29. all the information of those employees who did not have any job in the past.
SELECT *
FROM employees
WHERE employee_id NOT IN (
    SELECT DISTINCT EMPLOYEE_ID
    FROM job_history
    );

--30. the employee number, name( first name and last name ) and job title for all employees whose salary is more than any average salary of any department.
    SELECT employee_id, (first_name || ' ' || last_name) AS employee_name, job_title
    FROM employees
        INNER JOIN jobs USING (job_id)
    WHERE salary > ANY(
         SELECT AVG(salary)
         FROM departments
            INNER JOIN employees USING (department_id)
         GROUP BY department_id
        );


--31. the employee id, name ( first name and last name ) and the job id column with a modified title SALESMAN for those employees whose job title is ST_MAN and DEVELOPER for whose job title is IT_PROG.
SELECT employee_id, (first_name || ' ' || last_name) AS employee_name,
       CASE WHEN job_id = 'ST_MAN' THEN 'SALESMAN'
           ELSE 'DEVELOPER' END AS job_id
FROM employees
WHERE job_id IN ('ST_MAN', 'IT_PROG');

--32. the employee id, name ( first name and last name ), salary and the SalaryStatus column with a title HIGH and LOW respectively for those employees whose salary is more than and less than the average salary of all employees.
SELECT employee_id, (first_name || ' ' || last_name) AS employee_name,
       CASE WHEN salary >= (SELECT AVG(salary)
                            FROM employees) THEN 'HIGH'
            ELSE 'LOW' END AS SalaryStatus
FROM employees;

--33. the employee id, name ( first name and last name ), SalaryDrawn, AvgCompare (salary - the average salary of all employees)
    -- and the SalaryStatus column with a title HIGH and LOW respectively for those employees whose salary is more than and less than
    -- the average salary of all employees.
SELECT employee_id, (first_name || ' ' || last_name) AS employee_name,
       salary AS SalaryDrawn,
       CASE WHEN salary >= avg_salary THEN 'HIGH'
          ELSE 'LOW' END AS SalaryStatus,
       salary - avg_salary as AvgCompare
FROM employees,
    (
    SELECT AVG(salary) AS avg_salary
    FROM employees
);

--34. all the employees who earn more than the average and who work in any of the IT departments.
SELECT *
FROM employees
    INNER JOIN departments USING (department_id)
WHERE salary > (
    SELECT AVG (salary)
    FROM employees
)
  AND department_name LIKE '%IT%';


--35. who earns more than Mr. Ozer.
SELECT *
FROM employees
WHERE salary > (
    SELECT salary
    FROM employees
    WHERE last_name = 'Ozer'
    );

--36. which employees have a manager who works for a department based in the US.
SELECT emp.*
FROM employees emp
    INNER JOIN employees man ON (emp.manager_id = man.employee_id)
    INNER JOIN departments dep ON (man.employee_id = dep.manager_id)
    INNER JOIN locations loc ON (dep.location_id = loc.location_id)
WHERE country_id = 'US';

--37. the names of all employees whose salary is greater than 50% of their department’s total salary bill.
SELECT (first_name || ' ' || last_name) AS employee_name
FROM employees emp
WHERE salary > 0.5 * (
    SELECT SUM(salary)
    FROM employees
    WHERE department_id = emp.department_id
);

--38. the employee id, name ( first name and last name ), salary, department name and city for all
--the employees who gets the salary as the salary earn by the employee which is maximum within the joining person January 1st, 2002 and December 31st, 2003.
SELECT employee_id, (first_name || ' ' || last_name) AS employee_name, salary, department_name, city
FROM employees
    INNER JOIN departments USING (department_id)
    INNER JOIN locations USING (location_id)
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE hire_date BETWEEN DATE '2002-01-01' AND DATE '2003-12-31'
    );

--39. the first and last name, salary, and department ID for all those employees who earn more than the average salary and arrange the list in descending order on salary.
SELECT employee_id, first_name, last_name, salary, department_id
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
)
ORDER BY salary DESC;

--40. the first and last name, salary, and department ID for those employees who earn more than the maximum salary of a department which ID is 40.
SELECT employee_id, first_name, last_name, salary, department_id
FROM employees
WHERE salary > (
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = 40
);

--41. the department name and Id for all departments where they located, that Id is equal to the Id for the location where department number 30 is located.
SELECT department_id, department_name
FROM departments
WHERE location_id = (
    SELECT location_id
    FROM departments
    WHERE department_id = 30
);

--42. the first and last name, salary, and department ID for all those employees who work in that department where the employee works who hold the ID 201.
SELECT first_name, last_name, salary, department_id
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE employee_id = 201
);

--43. the first and last name, salary, and department ID for those employees whose salary is equal to the salary of the employee who works in that department which ID is 40.
SELECT first_name, last_name, salary, department_id
FROM employees
WHERE salary IN (
    SELECT salary
    FROM employees
    WHERE department_id = 40
);

--44. the first and last name, salary, and department ID for those employees who earn more than the minimum salary of a department which ID is 40.
SELECT first_name, last_name, salary, department_id
FROM employees
WHERE salary > (
    SELECT MIN(salary)
    FROM employees
    WHERE department_id = 40
);

--45. the first and last name, salary, and department ID for those employees who earn less than the minimum salary of a department which ID is 70.
SELECT first_name, last_name, salary, department_id
FROM employees
WHERE salary > (
    SELECT MIN(salary)
    FROM employees
    WHERE department_id = 70
);

--46. the first and last name, salary, and department ID for those employees who earn less than the average salary, and also work at the department where the employee Laura is working as a first name holder.
SELECT first_name, last_name, salary, department_id
FROM employees
WHERE salary < (
    SELECT AVG(salary)
    FROM employees
)
  AND department_id = (
    SELECT department_id
    FROM employees
    WHERE first_name = 'Laura'
);

--47. the full name (first and last name) of manager who is supervising 4 or more employees.
SELECT (first_name || ' ' || last_name) AS manager_name
FROM employees
WHERE employee_id IN (
    SELECT manager_id
    FROM employees
    WHERE manager_id IS NOT NULL
    GROUP BY manager_id
    HAVING COUNT(manager_id) >= 4
);

--48. the details of the current job for those employees who worked as a Sales Representative in the past.
SELECT jb1.*
FROM jobs jb1
    INNER JOIN employees emp ON (jb1.job_id = emp.job_id)
WHERE employee_id IN(
    SELECT DISTINCT employee_id
    FROM job_history jh
        INNER JOIN jobs jb2 ON (jh.job_id = jb2.job_id)
    WHERE job_title = 'Sales Representative'
);

--49. all the infromation about those employees who earn second lowest salary of all the employees.
SELECT *
FROM employees
WHERE salary IN (SELECT MIN(salary)
                 FROM employees
                 WHERE salary > (SELECT MIN(salary)
                                  FROM employees)
);

--50. the department ID, full name (first and last name), salary for those employees who is highest salary drawar in a department.
SELECT department_id, (first_name || ' ' || last_name) AS employee_name, salary
FROM employees emp1
WHERE salary = (
    SELECT MAX(salary)
    FROM employees emp2
    WHERE emp2.department_id IS NOT NULL
      AND emp1.department_id = emp2.department_id
);
