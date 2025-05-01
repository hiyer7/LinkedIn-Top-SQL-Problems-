#🧩 1. Generate Numbers from 1 to 50

with recursive generate_10_cte as
(
	select 1 as numbers
    
    union all
    
    select numbers + 1
    from generate_10_cte
    where numbers < 10
)
select * from generate_10_cte;

#🏗️ 2. Build a Simple Hierarchy (Org Chart)

with recursive employee_alice_hierarchy as
(
	select e1.employee_id, e1.first_name, e1.manager_id, 1 as level
    from hr.employees e1
    where manager_id is null
    
    union all
    
    select e2.employee_id, e2.first_name, e2.manager_id, eh.level+1
    from hr.employees e2 join
    employee_alice_hierarchy eh
    on eh.employee_id = e2.manager_id
)

select * from employee_alice_hierarchy;

#📅 4. Generate All Dates Between Two Dates
with recursive generate_all_dates_cte as
(
	select date('2025-02-27') as first
    
    union all
    
    select date_add(first, interval 1 day)
    from generate_all_dates_cte
    where first < date('2025-07-03')
)

select * from generate_all_dates_cte;