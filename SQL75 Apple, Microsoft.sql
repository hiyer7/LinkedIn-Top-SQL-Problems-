#https://lnkd.in/g7WamkWP

CREATE TABLE linkedin.fact_event (id BIGINT PRIMARY KEY, time_id DATETIME, user_id VARCHAR(50), customer_id VARCHAR(50), client_id VARCHAR(50), event_type VARCHAR(50), event_id BIGINT);

INSERT INTO linkedin.fact_event (id, time_id, user_id, customer_id, client_id, event_type, event_id) VALUES (1, '2024-02-01 10:00:00', 'U1', 'C1', 'CL1', 'video call received', 101), (2, '2024-02-01 10:05:00', 'U1', 'C1', 'CL1', 'video call sent', 102), (3, '2024-02-01 10:10:00', 'U1', 'C1', 'CL1', 'message sent', 103), (4, '2024-02-01 11:00:00', 'U2', 'C2', 'CL2', 'voice call received', 104), (5, '2024-02-01 11:10:00', 'U2', 'C2', 'CL2', 'voice call sent', 105), (6, '2024-02-01 11:20:00', 'U2', 'C2', 'CL2', 'message received', 106), (7, '2024-02-01 12:00:00', 'U3', 'C3', 'CL1', 'video call sent', 107), (8, '2024-02-01 12:15:00', 'U3', 'C3', 'CL1', 'voice call received', 108), (9, '2024-02-01 12:30:00', 'U3', 'C3', 'CL1', 'voice call sent', 109), (10, '2024-02-01 12:45:00', 'U3', 'C3', 'CL1', 'video call received', 110);

select * from fact_event;

select distinct event_type from fact_event;

#'video call received', 'video call sent', 'voice call received', 'voice call sent'
with four_events_cte as
(
select user_id, client_id, 
count(*) as numerator
from fact_event
where event_type in ('video call received', 'video call sent', 'voice call received', 'voice call sent')
group by 1,2),

total_cte as
(
select user_id, client_id,
		count(*) as denomenator 
from fact_event
        group by 1,2)
        
select fec.user_id, fec.client_id,
		(numerator/denomenator)*100 as pc
from four_events_cte fec
join total_cte
using(user_id,client_id)
#where (numerator/denomenator)*100 > 50;

#select * from total_cte;
		
        
        