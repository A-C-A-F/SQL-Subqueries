###############################################################
###############################################################
-- Project: Mastering SQL Subqueries
###############################################################
###############################################################


#############################
-- Task One: Getting Started
-- In this task, we will retrieve data from the tables in the
-- employees database
#############################

-- 1.1: Retrieve all the data from tables in the employees database
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM salaries;
SELECT * FROM customers;
SELECT * FROM sales;

#############################
-- Task Two: Subquery in the WHERE clause
-- In this task, we will learn how to use a 
-- subquery in the WHERE clause
#############################

--- Generally, subqueries are queries embedded in a query. A subquery is a query within a query. 
--- These subqueries can reside in the WHERE clause, in the FROM clause, or in the SELECT clause. 
--- That is, they're part of another query called the outer query. 

--- Some quick facts about subqueries. 
--- A subquery may return a single value, that is a scalar value, it could return a single row, 
--- a single column or an entire table. Another thing is you can have a lot more than one subquery 
--- in your outer query. Another thing is, it is possible to nest inner queries within another inner query. 

--- Some of the rules to consider when working with subqueries is that a sub query should always be placed
--- within parenthesis. Another thing is, it is more professional to apply the ORDER BY in the outer query.
--- One other thing you should note is that a sub query can have only one column in the SELECT clause.
--- Unless multiple columns are used in the main query for the subquery to compare the selected columns.

--- When you use an ORDER BY command, it cannot be used in the subquery, although the main query
--- can use an ORDER BY.

--- The GROUP BY command can be used to perform the same function as the ORDER BY in the subquery.
--- Another thing is that, depending on the database management system, subqueries can also return more 
--- than one row and can be used within multiple value operators like the IN operator.

--- One last thing is that the BETWEEN operator cannot be used with a subquery. However, the BETWEEN operator 
--- can be used within the sub-query.

-- 2.1: Retrieve a list of all employees that are not managers
--- If we run the employees table, we will notice that there are about 11822 rows of employees.
SELECT * FROM employees;
--- Now if we go to the department's managers table, we will notice that there are about 24 rows.
SELECT * FROM dept_manager;
--- Now let's retrieve all employees that are not manager
SELECT * FROM employees
WHERE emp_no NOT IN (SELECT emp_no FROM dept_manager); -- the parenthesis opens up for sub-queries
--- if we check the messages, we will see that there are 11798 rows retrieved. This is because 11822-24=11798.

--- What has happened is that SQL has checked those employee number that are not in these 24 employees returned here
--- and has returned that answer.


-- 2.2: Retrieve all columns in the sales table for customers above 60 years old

-- Returns the count of customers
SELECT customer_id, COUNT(*)
FROM sales
GROUP BY customer_id
ORDER BY COUNT(*) DESC;

-- Solution
SELECT DISTINCT customer_id
FROM customers
WHERE age > 60;
--- If we run this code alone, what will happen is that it will return only the customer_id of 
--- those customers that are more than 60 years old.
--- Usually what we would have done for to solve this problem would 
--- have been to write an exclusive join statement.
--- But in this case, we don't want to write a join statement. We want to use subquery.
SELECT *
FROM sales
WHERE customer_id IN (SELECT DISTINCT customer_id
		      FROM customers WHERE age > 60); -- copied from the above.
--- What SQL will now do is that it will check those customer-id in this sales table 
--- that are also in this particular subquery value.)
--- We will see all of the records returned here for those customers that are 
--- greater than 60 years old.

					  
-- 2.3: Retrieve a list of all manager's employees number, first and last names
--- Note that the first name and the last name is in the employees table.
--- But we are talking about the manager. The department managers are in the 
--- department managers table, not in the employees.
-- So, if we run the query below:
SELECT * FROM dept_manager;
--- we will see these managers with employee number, department number, the from_date
--- and to_date. That's basically when they became managers, to when they stopped 
--- becoming managers or maybe probably left the company.

--- Now, what we want to do is, we want to have two tables. 
--- Usually we would have written an exclusive join statement.
--- We want to see how to use subquery to solve this problem.

-- Solution
--- If we run only the query below:
SELECT emp_no, first_name, last_name
FROM employees
--- this will return all employees in our database.
--- But what we want to have is the managers details.
--- If we run only the query below:
SELECT emp_no FROM dept_manager;
--- it will return a series of values which contains only 
--- the employee number of all the managers which is 24.
--- But we want to now get the names of those 24 managers.
--- We will combine the above two queries to retrieve our desired output.
SELECT emp_no, first_name, last_name
FROM employees
WHERE emp_no IN (SELECT emp_no FROM dept_manager)
ORDER BY emp_no;
--- If we check the messages, our result shows 24 rows.
--- And in our data output, we will see the first name and last name
--- of the 24 managers we are expcting to see.

-- Exercise 2.1: Write a JOIN statement to get the result of task 2.3
SELECT * FROM employees;
SELECT * FROM dept_manager;

SELECT d.emp_no, e.first_name, e.last_name
FROM employees e
INNER JOIN dept_manager d
ON e.emp_no = d.emp_no
ORDER BY d.emp_no;
--- So, running this and checking the messages, you will have
--- the same result.

-- Exercise 2.2: Retrieve a list of all managers that were 
-- employed between 1st January, 1990 and 1st January, 1995
SELECT *
FROM dept_manager
WHERE emp_no IN (SELECT emp_no FROM employees WHERE hire_date BETWEEN '1990-01-01' AND '1995-01-01')
ORDER BY emp_no;

--- alternatively, we can do this also using JOIN.
SELECT d.emp_no, e.first_name, e.last_name, e.hire_date
FROM employees e
INNER JOIN dept_manager d
ON e.emp_no = d.emp_no
WHERE e.hire_date BETWEEN '1990-01-01' AND '1995-01-01'
ORDER BY d.emp_no;



#############################
-- Task Three: Subquery in the FROM clause
-- In this task, we will learn how to use a 
-- subquery in the FROM clause
#############################

-- 3.1: Retrieve a list of all customers living in the southern region
SELECT *
FROM (SELECT * FROM customers WHERE region = 'South') a;

--- This is quite redundant for now. But I want to use this to demonstrate 
--- how you have a subquery. The query inside the parenthesis becomes a source
--- of data. Not really a table as the case might be because usually we know that the FROM clause 
--- takes a table. But in this case we would have a source of data. The letter 'a' in the
--- last part of my query is my alias for that source.

--- Let's try retrieving some columns from this source.
SELECT a.customer_name, a.age
FROM (SELECT * FROM customers WHERE region = 'South') a;
--- This will return a result showing the columns of customer name and age.

--- Note worth taking: the code below will return an error becuase we changed the name
--- of the "age" column from inside of our subquery.
SELECT a.customer_name, a.age 
FROM (SELECT customer_name, age customer_age 
      FROM customers WHERE region = 'South') a;
--- The solution to this is to replace "a.age" with "a.customer_age".

--- Another example of sub-query. But this time, with multiple sub-query.
SELECT customer_id, a.customer_name, a.customer_age, a.region, b.category 
FROM (SELECT customer_id, customer_name, age customer_age, region 
      FROM customers WHERE region = 'South') a,
     (SELECT customer_id, category FROM sales) b;
--- This will return an error because the "customer_id" in line 1 is ambiguous.
--- This is because we have "customer_id" in a and b.
--- Thus, whenever we're referencing subquery, we must reference it properly.
--- The query below is the correct one.
SELECT a.customer_id, a.customer_name, a.customer_age, a.region, b.category 
FROM (SELECT customer_id, customer_name, age customer_age, region 
      FROM customers WHERE region = 'South') a,
     (SELECT customer_id, category FROM sales) b;


-- 3.2: Retrieve a list of managers and their department names

-- Returns all the data from the dept_manager table
SELECT * FROM dept_manager; -- this table has 24 rows
--- the department name is not in this table. 
--- It is in the 'departments' table.
SELECT * FROM departments; -- this table has 9 rows.

-- Solution
SELECT dm.*, d.dept_name
FROM dept_manager dm, (SELECT dept_no, dept_name FROM departments) d;
--- This will give us 216 rows of records which is quite not correct.
--- The reason is, 24 rows x 9 rows = 216.
--- To solve this problem, let's use WHERE clause.
SELECT dm.*, d.dept_name
FROM dept_manager dm, (SELECT dept_no, dept_name FROM departments) d
WHERE dm.dept_no = d.dept_no;
--- this will return the correct 24 records.


-- Exercise 3.1: Retrieve a list of managers, their first, last, and their department names

-- Returns data from the employees table
SELECT * FROM employees;

-- Solution
SELECT dm.*, e.first_name, e.last_name, d.dept_name
FROM dept_manager dm, employees e,
		      (SELECT dept_no, dept_name FROM departments) d
WHERE dm.dept_no = d.dept_no AND e.emp_no = dm.emp_no;
--- This will return our desired result with 24 records.
--- If we were to do this, normally, we would have written two or three 
--- joins just to achieve this.
--- So, SQL offers us something quite easier.


#############################
-- Task Four: Subquery in the SELECT clause
-- In this task, we will learn how to use a 
-- subquery in the SELECT clause
#############################

-- 4.1: Retrieve the first name, last name and average salary of all employees
SELECT first_name, last_name, (SELECT ROUND(AVG(salary), 2) FROM salaries) avg_salary
FROM employees;

-- Exercise 4.1: Retrieve a list of customer_id, product_id, order_line and the name of the customer
-- Returns data from the sales and customers tables
SELECT * FROM sales
ORDER BY customer_id;

SELECT * FROM customers;

-- Solution
SELECT customer_id, product_id, order_line, (SELECT customer_name FROM customers c
					     WHERE s.customer_id = c.customer_id)
FROM sales s
ORDER BY customer_id;

--- alternatively, you can run the query below.
SELECT s.customer_id, s.product_id, s.order_line, c.customer_name
FROM sales s, (SELECT customer_id, customer_name FROM customers) c
WHERE s.customer_id = c.customer_id
ORDER BY s.customer_id;


#############################
-- Task Five: Subquery Exercises - Part 1
-- In this task, we will try our hands on more 
-- exercises on subqueries
#############################

-- Exercise 5.1: Return a list of all employees who are in Customer Service department
-- Returns data from the dept_emp and departments tables
SELECT * FROM dept_emp;
SELECT * FROM departments;

-- Solution
--- Soln. #1
SELECT * FROM employees;

SELECT e.first_name, e.last_name, d.*
FROM employees e, (SELECT de.emp_no, d.dept_no, d.dept_name
		  FROM dept_emp de
		  JOIN departments d
		  ON d.dept_no = de.dept_no
		  WHERE d.dept_name = 'Customer Service') d
WHERE e.emp_no = d.emp_no
ORDER BY e.emp_no;

--- Soln. #2
SELECT * FROM dept_emp
WHERE dept_no IN (SELECT dept_no FROM departments
		  WHERE dept_name = 'Customer Service');


-- Exercise 5.2: Include the employee number, first and last names
SELECT a.emp_no, b.dept_no, a.first_name, a.last_name
FROM employees a
JOIN
(SELECT * FROM dept_emp
WHERE dept_no IN (SELECT dept_no FROM departments
		  WHERE dept_name = 'Customer Service')) b
ON a.emp_no = b.emp_no
ORDER BY emp_no;


-- Exercise 5.3: Retrieve a list of all managers who became managers after 
-- the 1st of January, 1985 and are in the Finance or HR department
-- Returns data from the departments and dept_manager tables
SELECT * FROM departments;
SELECT * FROM dept_manager
WHERE from_date > '1985-01-01';

-- Solution
--- try Soln. #1:
SELECT a.*, b.*
FROM departments a, (SELECT from_date, to_date
		     FROM dept_manager
		     WHERE from_date = '1985-01-01') b
WHERE a.dept_name = 'Finance' OR dept_name = 'Human Resources';

--- try Soln. #2:
SELECT c.emp_no, c.first_name, c.last_name, a.*, b.from_date, b.to_date
FROM departments a, (SELECT emp_no, dept_no, from_date, to_date
		     FROM dept_manager
		     WHERE from_date = '1985-01-01') b,
		    (SELECT emp_no, first_name, last_name
		     FROM employees) c
WHERE a.dept_name = 'Finance' OR dept_name = 'Human Resources' AND c.emp_no = b.emp_no AND a.dept_no = b.dept_no;
		     

--- try Soln. #3:
SELECT c.emp_no, c.first_name, c.last_name, a.*, b.from_date, b.to_date
FROM departments a, (SELECT emp_no, dept_no, from_date, to_date
		     FROM dept_manager
		     WHERE from_date = '1985-01-01') b
JOIN
(SELECT emp_no, first_name, last_name
FROM employees) c
ON b.emp_no = c.emp_no
WHERE a.dept_name = 'Finance' OR dept_name = 'Human Resources' AND a.dept_no = b.dept_no;

--- Correct Soln.:
SELECT * FROM dept_manager
WHERE from_date > '1985-01-01'
AND dept_no IN (SELECT dept_no FROM departments
		WHERE dept_name = 'Finance' OR dept_name = 'Human Resources');


-- Exercise 5.4: Retrieve a list of all employees that earn above 120,000
-- and are in the Finance or HR departments

-- Retrieve a list of all employees that earn above 120,000
SELECT emp_no, salary FROM salaries
WHERE salary > 120000;

-- Solution
SELECT emp_no, salary
FROM salaries
WHERE salary > 120000
AND emp_no IN (SELECT emp_no FROM dept_emp
	       WHERE dept_no = 'd002' OR dept_no = 'd003');


-- Alternative Solution
SELECT emp_no, salary FROM salaries
WHERE salary > 120000
AND emp_no IN (SELECT emp_no FROM dept_emp
				WHERE dept_no IN ('d002','d003'));

-- Exercise 5.5: Retrieve the average salary of these employees
SELECT emp_no, ROUND(AVG(salary), 2) AS avg_salary
FROM salaries
WHERE salary > 120000
AND emp_no IN (SELECT emp_no FROM dept_emp
	       WHERE dept_no IN ('d002','d003'))
GROUP BY emp_no
ORDER BY avg_salary DESC;


#############################
-- Task Six: Subquery Exercises - Part Two
-- In this task, we will try our hands on more 
-- exercises on subqueries
#############################

-- Exercise 6.1: Return a list of all employees number, first and last name.
-- Also, return the average salary of all the employees and average salary
-- of each employee

-- Retrieve all the records in the salaries table
SELECT * FROM salaries;

-- Return the employee number, first and last names and average
-- salary of all employees
SELECT e.emp_no, e.first_name, e.last_name,
(SELECT ROUND(AVG(salary), 2) FROM salaries) avg_salary
FROM employees e
JOIN salaries s
ON e.emp_no = s.emp_no;

-- Returns the employee number and average salary of each employee
SELECT emp_no, ROUND(AVG(salary), 2) AS emp_avg_salary
FROM salaries
GROUP BY emp_no
ORDER BY emp_no;

-- Solution
SELECT e.emp_no, e.first_name, e.last_name, a.emp_avg_salary,
(SELECT ROUND(AVG(salary), 2) FROM salaries) avg_salary
FROM employees e
JOIN (SELECT emp_no, ROUND(AVG(salary), 2) AS emp_avg_salary
      FROM salaries
      GROUP BY emp_no
      ORDER BY emp_no) a
ON e.emp_no = a.emp_no
ORDER BY e.emp_no;


-- Exercise 6.2: Find the difference between an employee's average salary
-- and the average salary of all employees
SELECT e.emp_no, e.first_name, e.last_name, a.emp_avg_salary,
(SELECT ROUND(AVG(salary), 2) FROM salaries) avg_salary, 
a.emp_avg_salary - (SELECT ROUND(AVG(salary), 2) FROM salaries) AS avg_salary_diff
FROM employees e
JOIN (SELECT emp_no, ROUND(AVG(salary), 2) AS emp_avg_salary
      FROM salaries
      GROUP BY emp_no
      ORDER BY emp_no) a
ON e.emp_no = a.emp_no
ORDER BY e.emp_no;

-- Exercise 6.3: Find the difference between the maximum salary of employees
-- in the Finance or HR department and the maximum salary of all employees

SELECT e.emp_no, e.first_name, e.last_name, a.emp_max_salary,
(SELECT MAX(salary) max_salary FROM salaries), ---  This part here is returning the maximum salary. It will return only one value.
(SELECT MAX(salary) max_salary FROM salaries) - a.emp_max_salary salary_diff
FROM employees e
JOIN (SELECT s.emp_no, MAX(salary) AS emp_max_salary
				   FROM salaries s
				   GROUP BY s.emp_no
				   ORDER BY s.emp_no) a --- This part of the query here will return the maximum salary of each of the employee.
ON e.emp_no = a.emp_no
WHERE e.emp_no IN (SELECT emp_no FROM dept_emp WHERE dept_no IN ('d002', 'd003'))
ORDER BY emp_no;


#############################
-- Task Seven: Subquery Exercises - Part Three
-- In this task, we will try our hands on more 
-- exercises on subqueries
#############################

-- Exercise 7.1: Retrieve the salary that occurred the most

-- Returns a list of the count of salaries
SELECT salary, COUNT(*)
FROM salaries
GROUP BY salary
ORDER BY COUNT(*) DESC, salary DESC
LIMIT 1;


-- Solution
SELECT a.salary
FROM
(SELECT salary, COUNT(*) --- this now becomes a source of data.
FROM salaries
GROUP BY salary
ORDER BY COUNT(*) DESC, salary DESC
LIMIT 1) a;

-- Exercise 7.2: Find the average salary excluding the highest and
-- the lowest salaries

-- Returns the average salary of all employees
SELECT ROUND(AVG(salary), 2) avg_salary
FROM salaries

-- Solution
SELECT ROUND(AVG(salary), 2) avg_salary
FROM salaries
WHERE salary NOT IN (
	(SELECT MIN(salary) FROM salaries),
	(SELECT MAX(salary) FROM salaries)
);



-- Exercise 7.3: Retrieve a list of customers id, name that has
-- bought the most from the store

-- Returns a list of customer counts
SELECT customer_id, COUNT(*) AS cust_count
FROM sales
GROUP BY customer_id
ORDER BY cust_count DESC;
--- So, clearly w can see that this customer WB--21850 has purchased 37 times 
--- from the store.
--- Probably we want to do a promotion to give those customers that purchased the most.
--- Probably some kind of discount.

-- Solution
SELECT c.customer_id, c.customer_name, a.cust_count
FROM customers c,
    (SELECT customer_id, COUNT(*) AS cust_count
     FROM sales
     GROUP BY customer_id
     ORDER BY cust_count DESC) AS a
WHERE c.customer_id = a.customer_id
ORDER BY a.cust_count DESC
--- So, clearly we say William Brown has purchased most
--- in our customers table. So, this particular person has
--- come to the store the most to buy followed by John Lee.
--- So, we could want to do a discount or a special promotion for
--- those customers.
--- Maybe probably the first top five customers.
--- let's add a LIMIT.
LIMIT 5; --- run this with the rest of the query above.


-- Exercise 7.4: Retrieve a list of the customer name and segment
-- of those customers that bought the most from the store and
-- had the highest total sales

-- Returns a list of customer counts and total sales
SELECT * FROM sales;
--- we'll see a sales column that tells us about the quantity the person
--- bought, the customer bought, and how much that gave to the company in sales. 

--- Let's try to explore the total sales like how much
--- do you give when you purchase from us?
SELECT customer_id, COUNT(*) AS cust_count, SUM(sales) total_sales
FROM sales
GROUP BY customer_id
ORDER BY total_sales DESC, cust_count DESC;

--- And we will see there is a new column which is the total
--- sales that howbeit, the customer SM-20320 has purchased just 15 times from the company.

-- Solution
SELECT c.customer_id, c.customer_name, c.segment, a.cust_count, a.total_sales
FROM customers c,
       (SELECT customer_id, COUNT(*) AS cust_count, SUM(sales) total_sales
	FROM sales
	GROUP BY customer_id
	ORDER BY total_sales DESC, cust_count DESC) AS a
WHERE c.customer_id = a.customer_id
ORDER BY a.total_sales DESC, a.cust_count DESC
--- And we'll see that the customer (Sean Miller) has home office, the
--- segment is home office and person has purcahsed 15 times but
--- come to the office-- to the store- 15 times.
--- But in terms of how much the person brings in terms of the sales, 
--- it's the highest. And we'll see, in fact, we can even put a limit here.
--- We probably want to target the first five people.
LIMIT 5;

--- And we'll understand that it's not about the quantity. 
--- See this person, (Adrian Barton), he's a consumer; has purchased 20 times; come to the store 
-- 20 times, but has not generated as much as each of these other customers.

