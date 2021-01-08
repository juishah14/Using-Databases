------------------------------------------
--DDL statement for table 'HR' database--
--------------------------------------------
DROP TABLE EMPLOYEES;
DROP TABLE JOB_HISTORY;
DROP TABLE JOBS;
DROP TABLE DEPARTMENTS;
DROP TABLE LOCATIONS;

CREATE TABLE EMPLOYEES (
                            EMP_ID CHAR(9) NOT NULL, 
                            F_NAME VARCHAR(15) NOT NULL,
                            L_NAME VARCHAR(15) NOT NULL,
                            SSN CHAR(9),
                            B_DATE DATE,
                            SEX CHAR,
                            ADDRESS VARCHAR(30),
                            JOB_ID CHAR(9),
                            SALARY DECIMAL(10,2),
                            MANAGER_ID CHAR(9),
                            DEP_ID CHAR(9) NOT NULL,
                            PRIMARY KEY (EMP_ID));
                            
  CREATE TABLE JOB_HISTORY (
                            EMPL_ID CHAR(9) NOT NULL, 
                            START_DATE DATE,
                            JOBS_ID CHAR(9) NOT NULL,
                            DEPT_ID CHAR(9),
                            PRIMARY KEY (EMPL_ID,JOBS_ID));
 
 CREATE TABLE JOBS (
                            JOB_IDENT CHAR(9) NOT NULL, 
                            JOB_TITLE VARCHAR(30) ,
                            MIN_SALARY DECIMAL(10,2),
                            MAX_SALARY DECIMAL(10,2),
                            PRIMARY KEY (JOB_IDENT));

CREATE TABLE DEPARTMENTS (
                            DEPT_ID_DEP CHAR(9) NOT NULL, 
                            DEP_NAME VARCHAR(15) ,
                            MANAGER_ID CHAR(9),
                            LOC_ID CHAR(9),
                            PRIMARY KEY (DEPT_ID_DEP));

CREATE TABLE LOCATIONS (
                            LOCT_ID CHAR(9) NOT NULL,
                            DEP_ID_LOC CHAR(9) NOT NULL,
                            PRIMARY KEY (LOCT_ID,DEP_ID_LOC));

select DEP_ID, COUNT(*) AS "NUM_EMPLOYEES", AVG(SALARY) AS "AVG_SALARY"
from EMPLOYEES
group by DEP_ID
having count(*) < 4
order by AVG_SALARY;

select D.DEP_NAME , E.F_NAME, E.L_NAME
from EMPLOYEES as E, DEPARTMENTS as D
where E.DEP_ID = D.DEPT_ID_DEP
order by D.DEP_NAME, E.L_NAME desc ;

-- From Week 2 Lab: String Patterns, Sorting & Grouping --

-- Query 1------
select F_NAME , L_NAME
from EMPLOYEES
where ADDRESS LIKE '%Elgin,IL%' ;

--Query 2--
select F_NAME , L_NAME
from EMPLOYEES
where B_DATE LIKE '197%' ;

---Query3--
select *
from EMPLOYEES
where (SALARY BETWEEN 60000 and 70000)  and DEP_ID = 5 ;

--Query4A--
select F_NAME, L_NAME, DEP_ID 
from EMPLOYEES
order by DEP_ID;

--Query4B--
select F_NAME, L_NAME, DEP_ID 
from EMPLOYEES
order by DEP_ID desc, L_NAME desc;

--Query5A--
select DEP_ID, COUNT(*)
from EMPLOYEES
group by DEP_ID;

--Query5B--
select DEP_ID, COUNT(*), AVG(SALARY)
from EMPLOYEES
group by DEP_ID;

--Query5C--
select DEP_ID, COUNT(*) AS "NUM_EMPLOYEES", AVG(SALARY) AS "AVG_SALARY"
from EMPLOYEES
group by DEP_ID;

--Query5D--
select DEP_ID, COUNT(*) AS "NUM_EMPLOYEES", AVG(SALARY) AS "AVG_SALARY"
from EMPLOYEES
group by DEP_ID
order by AVG_SALARY;

--Query5E--
select DEP_ID, COUNT(*) AS "NUM_EMPLOYEES", AVG(SALARY) AS "AVG_SALARY"
from EMPLOYEES
group by DEP_ID
having count(*) < 4
order by AVG_SALARY;

--5E alternative: if you want to use the label
select DEP_ID, NUM_EMPLOYEES, AVG_SALARY from
  ( select DEP_ID, COUNT(*) AS NUM_EMPLOYEES, AVG(SALARY) AS AVG_SALARY from EMPLOYEES group by DEP_ID)
  where NUM_EMPLOYEES < 4
order by AVG_SALARY;

--Query6--
select D.DEP_NAME , E.F_NAME, E.L_NAME
from EMPLOYEES as E, DEPARTMENTS as D
where E.DEP_ID = D.DEPT_ID_DEP
order by D.DEP_NAME, E.L_NAME desc ;

-- From Week 2 Lab: Sub-queries, Multiple Tables --

--Query A4--
select EMP_ID, SALARY, ( select AVG(SALARY) from employees ) AS AVG_SALARY from employees;

--Query A5--
select * from ( select EMP_ID, F_NAME, L_NAME, DEP_ID from employees) AS EMP4ALL;

--Query B1--
select * from employees where DEP_ID IN ( select DEPT_ID_DEP from departments );

--Query B2--
select * from employees where DEP_ID IN ( select DEPT_ID_DEP from departments where LOC_ID = 'L0002' );

--Query B3--
select DEPT_ID_DEP, DEP_NAME from departments where DEPT_ID_DEP IN ( select DEP_ID from employees where SALARY > 70000 ) ;

--Query B4--
select * from employees, departments;

-- Query B5--
select * from employees, departments where employees.DEP_ID = departments.DEPT_ID_DEP;

--Query B6--
select * from employees E, departments D where E.DEP_ID = D.DEPT_ID_DEP;

--Query B7--
select EMP_ID, DEP_NAME from employees E, departments D where E.DEP_ID = D.DEPT_ID_DEP;

--Query B8--
select E.EMP_ID, D.DEP_NAME from employees E, departments D where E.DEP_ID = D.DEPT_ID_DEP;

-- From Week 3 Lab: JOINs --

-- query 1: select the names and job start dates of all employees who work for department num 5 --
select E.F_NAME, E.L_NAME, JH.START_DATE
	from EMPLOYEES as E
	INNER JOIN JOB_HISTORY as JH on E.EMP_ID=JH.EMPL_ID 
	where E.DEP_ID ='5'
;

-- query 2: select the names, job start dates, and job titles of all employees who work for department num 5 --
select E.F_NAME, E.L_NAME, JH.START_DATE, J.JOB_TITLE
	from EMPLOYEES as E 
	INNER JOIN JOB_HISTORY as JH on E.EMP_ID=JH.EMPL_ID
	INNER JOIN JOBS AS J ON E.JOB_ID = J.JOB_IDENT
	where E.DEP_ID = '5'
;

-- query 3: perform a left outer join on the EMPLOYEES and DEPARTMENT tables and select employee id, last name, department id and department name for all employees --
select E.EMP_ID, E.L_NAME, D.DEPT_ID_DEP, D.DEP_NAME
	from EMPLOYEES as E 
	LEFT OUTER JOIN DEPARTMENTS AS D ON E.DEP_ID=D.DEPT_ID_DEP
;

-- query 4: re-write the query for 2A to limit the result set to include only the rows for employees born before 1980.--
select E.EMP_ID, E.L_NAME, D.DEPT_ID_DEP, D.DEP_NAME
	from EMPLOYEES as E 
	LEFT OUTER JOIN DEPARTMENTS AS D ON E.DEP_ID=D.DEPT_ID_DEP 
	where YEAR(E.B_DATE) < 1980
;

-- same as above but dif method --
select E.EMP_ID, E.L_NAME, D.DEPT_ID_DEP, D.DEP_NAME
	from EMPLOYEES as E 
	INNER JOIN DEPARTMENTS AS D ON E.DEP_ID=D.DEPT_ID_DEP 
	where YEAR(E.B_DATE) < 1980
;

-- query 5: re-write the query for 2A to have the result set include all the employees but department names for only the employees who were born before 1980. --
select E.EMP_ID, E.L_NAME, E.DEP_ID, D.DEP_NAME
	from EMPLOYEES AS E 
	LEFT OUTER JOIN DEPARTMENTS AS D ON E.DEP_ID=D.DEPT_ID_DEP 
	AND YEAR(E.B_DATE) < 1980
;

-- query 6: perform a Full Join on the EMPLOYEES and DEPARTMENT tables and select the First name, Last name and Department name of all employees. --
select E.F_NAME, E.L_NAME, D.DEP_NAME
	from EMPLOYEES AS E 
	FULL OUTER JOIN DEPARTMENTS AS D ON E.DEP_ID=D.DEPT_ID_DEP
;

-- query 7: re-write Query 3A to have the result set include all employee names but department id and department names only for male employees.--
select E.F_NAME, E.L_NAME, D.DEPT_ID_DEP, D.DEP_NAME
	from EMPLOYEES as E 
	LEFT OUTER JOIN DEPARTMENTS AS D ON E.DEP_ID=D.DEPT_ID_DEP AND E.SEX = 'M'
;

-- same as above but dif method --
select E.F_NAME,E.L_NAME,D.DEPT_ID_DEP, D.DEP_NAME
	from EMPLOYEES AS E 
	FULL OUTER JOIN DEPARTMENTS AS D ON E.DEP_ID=D.DEPT_ID_DEP AND E.SEX = 'M'
;