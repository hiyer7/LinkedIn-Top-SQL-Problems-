#📌 1. Complex Joins & Aggregations

#1️Retrieve the top 3 highest-paid employees in each department.
select count(*) from hr_data.employees;

#select 
select full_name, department_id
from
(
select concat(first_name, " ", last_name) as full_name, department_id,
	   dense_rank() over (partition by department_id order by salary desc) as drank
from hr_data.employees) tbl
where drank <=3
and department_id is not null
order by department_id;
#------>26 rows

#2️. Find employees who earn more than their department’s average salary.
-- select concat(first_name, " ", last_name) as full_name,
-- 		salary,
-- 		department_id,
-- 		avg(salary) over (partition by department_id) as dept_avg_salary)
 
with grouped_avg_salary as 
(select department_id, round(avg(salary),2) as dept_avg_salary
		from hr.employees
where department_id is not null
group by 1)

select concat(first_name, " ", last_name) as full_name,
	   e.department_id
       salary
from hr.employees e 
join grouped_avg_salary
using(department_id)
where salary>dept_avg_salary;
#------>38 rows

#3️ Find the department(s) with the highest number of employees.
select department_id,
		count(*) as total_employees
from hr.employees
group by 1
order by 2 desc
limit 1;
#------>50: 45 employees

#4 Identify departments where the total salary expense exceeds $10 million.
select department_id,
	   sum(salary) as total_salary
from hr.employees
group by 1
order by 2 desc;
#having sum(salary) > 1000000;
#------>0 rows

#5. Find employees who have the same salary as someone in a different department.
select concat(e.first_name, " ", e.last_name) as full_name, e.salary
from hr.employees e
where e.salary = any
(select d.salary
from hr.employees d 
where e.department_id != d.department_id) 
order by 2;
#------> 46 rows

SELECT e.employee_id, e.department_id, e.salary
FROM hr.employees e
WHERE EXISTS (
    SELECT 1
    FROM hr.employees emp
    WHERE e.salary = emp.salary
    AND e.department_id != emp.department_id
);

#📌 2. Window Functions & Ranking

# 6️⃣ Find the second highest salary without using LIMIT or OFFSET.

select full_name
from
(select (e.first_name, " ", e.last_name) as full_name,
	   dense_rank() over(order by salary desc) as salary_rnk
from hr.employees e) tbl
where salary_rnk = 2;
#------> Neena, Lex

#7️⃣ Find employees with the longest tenure in the company.

with oldest_hire_date_cte as
(select concat(e.first_name, " ", e.last_name) as full_name,
		hire_date,
	   min(hire_date) over() as oldest_hire_date
from hr.employees e) 


select full_name, hire_date
from oldest_hire_date_cte
where hire_date = oldest_hire_date;

#------> Steven King

#8️⃣ Identify the cumulative salary expenditure per department over time.

select distinct department_id,
		sum(salary) over (partition by department_id) as cumulative_salary
from hr.employees;
#------> 12 rows including null


#9️⃣ Rank employees by salary within each department.
select concat(e.first_name, " ", e.last_name) as full_name,
	   dense_rank() over(partition by department_id order by salary desc) drank_dept_sal
from hr.employees e;
#------>107 rows;

#🔟 Find the running total of salaries ordered by hire date.
select hire_date,
	   sum(salary) over (order by hire_date rows between unbounded preceding and current row) as running_total
from hr.employees;

#------>107 rows
#692400

#1️⃣6️⃣ Find employees who have been with the company for more than 5 years.

select employee_id,
		hire_date
from hr.employees
where timestampdiff(year, hire_date, current_date) > 35;
#------> > 35: 100, 200

#1️⃣7️⃣ Calculate the average tenure of employees per department.

select department_id,
		avg(timestampdiff(year, hire_date, current_date))
from hr.employees
group by 1;
#------> 12 rows
#1️⃣8️⃣ Find the employee who was hired most recently.

select employee_id,
	   hire_date
from hr.employees
where hire_date = (select max(hire_date) from hr.employees);
#------> 167, 173 2000-04-21

#1️⃣9️⃣ Identify gaps in hiring trends (e.g., months with no hires).
select extract(month from hire_date),
		count(*) 
from hr.employees
group by 1
order by 1;

select extract(year from hire_date),
		count(*) 
from hr.employees
group by 1
order by 1;

#2️⃣0️⃣ Find employees who joined on the same day in different years.

select employee_id, extract(day from hire_date) as day,
	   extract(month from hire_date) as month
from employees e    
where extract(year from hire_date);
		
-- #1️1. Find all direct and indirect managers of an employee (Org Hierarchy).
-- select e.employee_id, e.manager_id , m.manager_id as "manger's manager"
-- from hr.employees e
-- join hr.employees m
-- on m.employee_id = e.manager_id
-- order by 3;

#1️⃣2️⃣ Count the number of direct and indirect reports for each manager.

with recursive org_hierarchy as
(
	select e1.employee_id, 
		   e1.manager_id,
		   e1.manager_id as top_manager,
			1 as level
    from hr.employees e1
    where manager_id is not null
    
	union all
    
    select e2.employee_id, e2.manager_id, oh.top_manager, oh.level+1
    from hr.employees e2
    join org_hierarchy oh
    on e2.manager_id = oh.employee_id
)
select * from org_hierarchy;

-- select top_manager as manager_id, 
-- 		count(case when level = 1 then employee_id end) as direct_reportee,
-- 		count(case when level > 1 then  employee_id end) as indirect_reportee
-- from org_hierarchy
-- group by 1;














-- with direct_cte as
-- (
-- select e.manager_id as id, count(*) as direct_count#, m.manager_id as "manger's manager", 
-- from hr.employees e
-- join hr.employees m
-- on m.employee_id = e.manager_id
-- group by  1),

-- indirect_cte as
-- (
-- select m.manager_id as manager, count(*) as indirect_count 
-- from hr.employees e
-- join hr.employees m
-- on m.employee_id = e.manager_id
-- group by  1)



-- select id,
-- 		direct_count,
--         indirect_count
-- from indirect_cte
-- left join direct_cte
-- on indirect_cte.manager = direct_cte.id;

-- with recursive employee_hierarchy_1 as
-- (
-- 	select employee_id, manager_id, 1 as level
--     from hr.employees
--     where employee_id = (select employee_id from hr.employees where manager_id is null)
--     
--     union all
--     
--     select e.employee_id, e.manager_id, eh.level+1
--     from hr.employees e
--     join employee_hierarchy_1 eh
--     on e.manager_id = eh.employee_id
-- )
-- select * from employee_hierarchy_1;

-- select manager_id,
-- 		case
--         when 
-- 	   count(level)
-- from employee_hierarchy_1
-- group by 1;

-- #1️⃣3️⃣ Identify the shortest reporting chain between two employees.




-- #Understanding recursive cte
-- with recursive employee_hierarchy as
-- (
-- 	select employee_id, first_name, manager_id, 1 as level
--     from hr.employees
--     where employee_id = (select employee_id from hr.employees where manager_id is null)
--     
--     union all
--     
--     select e.employee_id, e.first_name, e.manager_id, eh.level+1
--     from hr.employees e
--     Inner join employee_hierarchy eh
--     on eh.employee_id = e.manager_id
-- )

-- select * from employee_hierarchy;


