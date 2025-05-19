drop table car_launches;
CREATE TABLE car_launches(year int, company_name varchar(15), product_name varchar(30));

INSERT INTO car_launches VALUES(2019,'Toyota','Avalon'),(2019,'Toyota','Camry'),(2020,'Toyota','Corolla'),(2019,'Honda','Accord'),(2019,'Honda','Passport'),(2019,'Honda','CR-V'),(2020,'Honda','Pilot'),(2019,'Honda','Civic'),(2020,'Chevrolet','Trailblazer'),(2020,'Chevrolet','Trax'),(2019,'Chevrolet','Traverse'),(2020,'Chevrolet','Blazer'),(2019,'Ford','Figo'),(2020,'Ford','Aspire'),(2019,'Ford','Endeavour'),(2020,'Jeep','Wrangler');
------------
select * from car_launches;

with product_launched_cte_2019 as
(
select company_name,count(*) as product_launched_2019
from car_launches
where year = 2019
group by 1
),

product_launched_cte_2020 as
(
select company_name, count(*) as product_launched_2020
from car_launches
where year = 2020
group by 1
)

select company_name, product_launched_2020 - product_launched_2019 as net
from product_launched_cte_2020
left join product_launched_cte_2019
using (company_name)
order by 2 desc;


-- select distinct company_name from car_launches;-- 