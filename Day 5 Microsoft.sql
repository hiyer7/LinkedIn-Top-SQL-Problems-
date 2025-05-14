CREATE TABLE ms_projects(id int, title varchar(15), budget int);
INSERT INTO ms_projects VALUES (1, 'Project1',  29498),(2, 'Project2',  32487),(3, 'Project3',  43909),(4, 'Project4',  15776),(5, 'Project5',  36268),(6, 'Project6',  41611),(7, 'Project7',  34003),(8, 'Project8',  49284),(9, 'Project9',  32341),(10, 'Project10',    47587),(11, 'Project11',    11705),(12, 'Project12',    10468),(13, 'Project13',    43238),(14, 'Project14',    30014),(15, 'Project15',    48116),(16, 'Project16',    19922),(17, 'Project17',    19061),(18, 'Project18',    10302),(19, 'Project19',    44986),(20, 'Project20',    19497);

CREATE TABLE ms_emp_projects(emp_id int, project_id int);
INSERT INTO ms_emp_projects VALUES (10592,  1),(10593,  2),(10594,  3),(10595,  4),(10596,  5),(10597,  6),(10598,  7),(10599,  8),(10600,  9),(10601,  10),(10602, 11),(10603, 12),(10604, 13),(10605, 14),(10606, 15),(10607, 16),(10608, 17),(10609, 18),(10610, 19),(10611, 20);

select * from ms_projects;
select * from ms_emp_projects;

select count(distinct project_id) from ms_emp_projects;


with count_emp_per_project_cte as
(
	select project_id, count(emp_id) as emp_per_project
    from ms_emp_projects
    group by 1
)

select id, title, round(budget/emp_per_project, 0) as budget_per_employee
from ms_projects
join count_emp_per_project_cte
on ms_projects.id = count_emp_per_project_cte.project_id
order by budget desc