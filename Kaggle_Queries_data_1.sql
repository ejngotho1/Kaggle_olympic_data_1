--Kaggle Data


--11.  Fetch the top 5 athletes who have won the most gold medals.
--Select * From [dbo].[athlete_events]
;with t1 as
    (
	Select Name,Medal 
	From [dbo].[athlete_events]
	Where 1=1
	 --and Name like '"Michael Fred Phelps' 
	 and Medal like '%Gold%'
	 and Medal not like '%NA%'
	),
t2 as  (
	 Select name, COUNT(1) gold_medal_cnt
	 From t1
	 Group by Name
	 ), --select * from t2 order by gold_medal_cnt desc
t3 as 
	 (Select Name, gold_medal_cnt, 
	  DENSE_RANK() over(Order by gold_medal_cnt desc) as rnk
	  From t2
	  )--select * from t3 Where rnk <= 5 order by gold_medal_cnt desc
Select Name, gold_medal_cnt
From t3 Where rnk <= 5
order by gold_medal_cnt desc
------------------------------------------------------------------------------------------------
--12. Top 5 athletes who have won the most medals (gold/silver/bronze).
    with t1 as
	      --I used this CTE to PIVOT the medal rows into Column

            (select name--, count(1) as total_medals,
			          ,count(case when Medal like '%Gold%' then 'Gold' end) as Gold,
					  count(case when Medal like'%Silver%' then 'Silver' end) as Silver,
					  count(case when Medal like'%Bronze%' then 'Bronze' end) as Bronze
            from [dbo].[athlete_events]
            where 1=1
			  --and medal in ('Gold', 'Silver', 'Bronze')
			  --and Name = 'Robert Tait McKenzie'
			  --and Medal not like '%NA%'
            group by name
            --order by Gold desc
			),
        t2 as
		-- this CTE gives me the total of the medals
            (select Name,gold,silver,bronze, (Gold+Silver+Bronze) as tot_medal
            from t1),
        t3 as
		 --this CTE ranks the columns in ascending order
			(
			select t2.*, DENSE_RANK() over(order by tot_medal desc) as rnk
			from t2
			)
    select name,gold,silver,bronze,  tot_medal
    from t3
    where rnk <= 5;

-------------------------------------------------------------------------------------------------------
--13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
-- means 5 countries with most medals
--Select * From [dbo].[athlete_events]
--Select * From [dbo].[noc_regions]
with t1 as (
	Select Medal, n.region as Country
	From [dbo].[athlete_events] e
	Join [dbo].[noc_regions] n on e.NOC = n.NOC
	Where Medal like '%Gold%' or Medal like'%Silver%' or Medal like'%Bronze%' 
	),
t2 as (
	Select Country, COUNT(Medal) as medal_cnt
	From t1
	group by Country 
	) ,--select * from t2 order by medal_cnt desc
t3 as (
	Select Country, medal_cnt,DENSE_RANK() over(Order by medal_cnt desc) as rnk
	From t2
	)
Select Country, medal_cnt
From t3
Where rnk <= 5
--------------------------------------------------------------------------------------------------------
--14. List down total gold, silver and bronze medals won by each country.

with t1 as (
     --using this CTE to PIVOT medal rows into Columns
	Select Medal, n.region as Country,
		  case when Medal like '%Gold%' then 'Gold' end as Gold,
		  case when Medal like '%Silver%' then 'Silver' end as Silver,
		  case when Medal like '%Bronze%' then 'Bronze' end as Bronze
	From [dbo].[athlete_events] e
	Join [dbo].[noc_regions] n on e.NOC = n.NOC
	--Where Medal like '%Gold%' or Medal like'%Silver%' or Medal like'%Bronze%' 
	--group by Medal, n.region
	),
t2 as (
	--counting the medals for each country
	Select Country, COUNT(Gold) as gold_cnt,COUNT(Silver) as silver_cnt,COUNT(Bronze) as bronze_cnt
	From t1
	group by Country 
	) 
select * , gold_cnt+silver_cnt+bronze_cnt as total
from t2 
order by gold_cnt desc
-----------------------------------------------------------------------------------------------------------------------
--15. List down total gold, silver and bronze medals won by each country corresponding to each olympic games.
-- need medals ( gold, silver, bronze)
-- need country from regions
-- need games

with t1 as (
		Select distinct Medal, Games, n.region as country,
				case when Medal like '%Gold%' then 'Gold' end as Gold,
				case when Medal like'%Silver%' then 'Silver' end as Silver,
				case when Medal like'%Bronze%' then 'Bronze' end as Bronze
		From [dbo].[athlete_events] e
		Join [dbo].[noc_regions] n on e.NOC = n.NOC
		Where Medal like '%Gold%' or Medal like'%Silver%' or Medal like'%Bronze%' 
		--Order by Games
		),
t2 as (Select games, country,  COUNT(Gold) as gold_cnt,COUNT(Silver) as silver_cnt,COUNT(Bronze) as bronze_cnt
	   From  t1
	   group by games, country
	   )
Select * From t2
Order by games,gold_cnt desc
----------------------------------------------------------------------------------------
--16.  Identify which country won the most gold, most silver and most bronze medals in each olympic games.
--need country
--need medals(gold,silver,bronze)
--need games
Select  distinct Games
		,concat(FIRST_VALUE(country) over(partition by games order by games, gold desc),'-',
				FIRST_VALUE(gold) over(partition by games order by games, gold desc)) as max_gold

		,concat(FIRST_VALUE(country) over(partition by games order by games, silver desc),'-',
				FIRST_VALUE(silver) over(partition by games order by games, silver desc)) as max_silver

        ,concat(FIRST_VALUE(country) over(partition by games order by games, silver desc),'-',
				FIRST_VALUE(bronze) over(partition by games order by games, bronze desc)) as max_bronze
From
(
		Select games,country,COUNT(Gold) as gold, COUNT(Silver) as silver, COUNT(Bronze) as bronze
		from (
				Select games, Medal , n.region as country
						,case when Medal like 'Gold' then 'Gold' end as Gold
						,case when Medal like 'Silver' then 'Silver' end as Silver
						,case when Medal like 'Bronze' then 'Bronze' end as Bronze
				From [dbo].[athlete_events] e
				Join [dbo].[noc_regions] n on e.NOC = n.NOC
			   )sub
		group by Games, country
--order by Games, gold desc, silver desc, bronze desc
)sub
order by Games,max_gold desc, max_silver desc, max_bronze desc

--************************************ALT*************************************************************-
;
with t1 as (
		Select games,country,COUNT(Gold) as gold, COUNT(Silver) as silver, COUNT(Bronze) as bronze
		from (
				Select games, Medal , n.region as country
						,case when Medal like 'Gold' then 'Gold' end as Gold
						,case when Medal like 'Silver' then 'Silver' end as Silver
						,case when Medal like 'Bronze' then 'Bronze' end as Bronze
				From [dbo].[athlete_events] e
				Join [dbo].[noc_regions] n on e.NOC = n.NOC
				Where 1=1
				   --and n.region = 'usa'
				   --and Games = '2016 Summer'
				   --and Medal not like 'NA'
				   )sub
		group by Games, country
		),
t2 as (
		Select  distinct Games
		,concat(FIRST_VALUE(country) over(partition by games order by games, gold desc),'-',
				FIRST_VALUE(gold) over(partition by games order by games, gold desc)) as max_gold

		,concat(FIRST_VALUE(country) over(partition by games order by games, silver desc),'-',
				FIRST_VALUE(silver) over(partition by games order by games, silver desc)) as max_silver

        ,concat(FIRST_VALUE(country) over(partition by games order by games, silver desc),'-',
				FIRST_VALUE(bronze) over(partition by games order by games, bronze desc)) as max_bronze
From t1
		)
Select games, max_gold, max_silver, max_bronze
From t2
Order by games, max_gold desc, max_silver desc, max_bronze desc

--***************************************************************************************************************************
------------------------------------------------------------------------------------------------------------------------------
--17. Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
--need country
--need medals(gold,silver,bronze)
--need games

with t1 as (	
	Select distinct Medal, Games, n.region as country,
	   -- we need to pivot so that we get gold silver and bronze
			case when Medal like '%Gold%' then 'Gold' end as Gold,
			case when Medal like'%Silver%' then 'Silver' end as Silver,
			case when Medal like'%Bronze%' then 'Bronze' end as Bronze
	From [dbo].[athlete_events] e
	Join [dbo].[noc_regions] n on e.NOC = n.NOC
	Where 1=1
	   --and Medal like '%Gold%' or Medal like'%Silver%' or Medal like'%Bronze%'
	   and Medal not like '%NA%'
	   --and Games = '2016 Summer'
	group by Medal, Games, n.region
	--Order by Games
	),
t2 as (
       Select games, country,  COUNT(Gold) as gold_cnt,COUNT(Silver) as silver_cnt,COUNT(Bronze) as bronze_cnt,
	                           COUNT(Gold)+COUNT(Silver)+COUNT(Bronze) as tot_medal
	   From  t1
	   group by games, country
	   ),   	  -- select * from t2 order by Games, gold_cnt desc,silver_cnt desc,bronze_cnt desc
t3 as (
	   select distinct games,
	         concat(first_value(country) over (partition by games order by games asc, gold_cnt desc),'-',
			        first_value(gold_cnt) over(partition by games order by games asc, gold_cnt desc)) as max_gold,

			 concat(first_value(country) over (partition by games order by games asc, silver_cnt desc),'-',
			        first_value(silver_cnt) over(partition by games order by games asc, silver_cnt desc)) as max_silver,

			 concat(first_value(country) over (partition by games order by games asc, bronze_cnt desc),'-',
			        first_value(bronze_cnt) over(partition by games order by games asc, bronze_cnt desc)) as max_bronze,

			 concat(first_value(country) over (partition by games order by games asc, tot_medal desc),'-',
			        first_value(tot_medal) over(partition by games order by games asc, tot_medal desc)) as most_total_medal
	   From t2 --where Games = '1896 summer'
	   )
	   Select *  From t3 order by Games
------------------------------------------------------------------------------------------------------------------------------
 --18. Which countries have never won gold medal but have won silver/bronze medals?
 --need country
--need medals(gold,silver,bronze)
------------------------------------------------------------------------------------------------------------------------------
 
with t1 as (
		Select distinct Medal, n.region as country,
				case when Medal like '%Gold%' then 'Gold' end as Gold,
				case when Medal like'%Silver%' then 'Silver' end as Silver,
				case when Medal like'%Bronze%' then 'Bronze' end as Bronze
		From [dbo].[athlete_events] e
		Join [dbo].[noc_regions] n on e.NOC = n.NOC
		Where 1=1
		  and Medal like '%Gold%' or Medal like'%Silver%' or Medal like'%Bronze%' 
		  --and Medal not like '%NA%'
		--Order by Games
		),
t2 as (Select country,  COUNT(Gold) as gold_cnt,COUNT(Silver) as silver_cnt,COUNT(Bronze) as bronze_cnt
	   From  t1
	   group by country
	   )
Select * From t2 
where gold_cnt  = 0 and silver_cnt > 0 and bronze_cnt > 0
Order by silver_cnt desc, bronze_cnt desc
------------------------------------------------------------------------------------------------------------
--19.  In which Sport/event, Germany has won highest medals.
Select top 1 [event], event_gld+event_slv+event_br as total_medal
from
(
	Select [event],COUNT(gold) event_gld, COUNT(Silver) as event_slv, COUNT(Bronze) as event_br
	From
	(
		Select distinct [Event], Medal, n.region as country,
				case when Medal like '%Gold%' then 'Gold' end as Gold,
				case when Medal like'%Silver%' then 'Silver' end as Silver,
				case when Medal like'%Bronze%' then 'Bronze' end as Bronze
		From [dbo].[athlete_events] e
		Join [dbo].[noc_regions] n on e.NOC = n.NOC
		Where 1=1
		  and n.region = 'Germany'
		  and Medal not like '%NA%' --or Medal like'%Silver%' or Medal like'%Bronze%'
	)sub
	group by Event
)sub1
Order by total_medal desc
------------------------------------------------------------------------------------------------------------------------
--20. Break down all olympic games where India won medal for Hockey and how many medals in each olympic games
--need country
--need medals(gold,silver,bronze)
--event
--games

Select distinct games, medal, COUNT(Gold) as gold,COUNT(Silver) as silver,COUNT(Bronze) as bronze,
                     (COUNT(Gold) + COUNT(Silver) + COUNT(Bronze)) as tot_medal
from
(
	Select distinct games, Medal, Event, n.region as Country,
	            case when Medal like '%Gold%' then 'Gold' end as Gold,
				case when Medal like'%Silver%' then 'Silver' end as Silver,
				case when Medal like'%Bronze%' then 'Bronze' end as Bronze
	From [dbo].[athlete_events] e
	Join [dbo].[noc_regions] n on e.NOC = n.NOC
	Where 1=1
		--and Medal like '%Gold%' or Medal like'%Silver%' or Medal like'%Bronze%' 
		--and Medal not like '%NA%'
		and n.region = 'USA'
		and Event like '%Basket%'
) sub
group by Games, Medal
Order by Games
--------------------------------------------------------------------------------------------------------------
Select *
From [dbo].[athlete_events] e
	Join [dbo].[noc_regions] n on e.NOC = n.NOC
	Where 1=1
		--and Medal like '%Gold%' or Medal like'%Silver%' or Medal like'%Bronze%' 
		--and Medal not like '%NA%'
		and n.region = 'USA'
		and Event like '%Basket%'
		and Games = '2004 summer'
		










