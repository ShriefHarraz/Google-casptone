
--- joining all the yearly datset in one table to clean and explor it easily ---
 
      ---- creating a temp table to combine and store our yearly dataset table ----

drop table if exists #yearly_data
create table #yearly_data
(
ride_id varchar(50),
rideable_type varchar(50),
started_at varchar(50),
ended_at varchar(50),
start_station_name varchar(255),
start_station_id varchar(50),
end_station_name varchar(255),
end_station_id varchar(50),
start_lat varchar(50),
end_lat varchar(50),
start_lng varchar(50),
end_lng varchar(50),
member_casual varchar(50)
)
INSERT INTO #yearly_data

select * 
from [dbo].[June2020]
union
select * 
from [dbo].[July2020]
union
select * 
from [dbo].[Aug2020]
union
select * 
from [dbo].[SEP2020]
union
select * 
from [dbo].[oct2020]
union
select * 
from [dbo].[Nov2020]
union
select * 
from [dbo].[Dec2020]
union
select * 
from [dbo].[Jan2021]
union
select * 
from [dbo].[Feb2021]
union
select * 
from [dbo].[march2021]
union
select * 
from [dbo].[April2021]


   ---- checking all our data from the yearly dataset temp table ----
select *
from #yearly_data

  ----   creatin another temp table to store our clean data to explor and analyze it later ---

   ----  creating three columns to extract the ride duration, day of the week, month of the year -----
drop table if exists #clean_data
create table #clean_data
(
ride_id varchar(50),
rideable_type varchar(50),
started_at	VARCHAR(50),
ended_at VARCHAR(50) ,
ride_duration numeric,
day_of_theWeek varchar(50),
month_of_the_year varchar(50),
start_station_name varchar(255),
start_station_id varchar(50),
end_station_name varchar(255),
end_station_id varchar(50),
start_lat varchar(50),
end_lat varchar(50),
start_lng varchar(50),
end_lng varchar(50),
member_casual varchar(50)
)
INSERT INTO #clean_data


select ride_id, rideable_type, started_at  , ended_at , DATEDIFF(MINUTE,started_at, ended_at) as ride_duration,	DATENAME(WEEKDAY, started_at)AS day_of_theWeek, datename(month,started_at) as month_of_the_year, start_station_name,start_station_id,
end_station_name,end_station_id, start_lat,end_lat, start_lng, end_lng, member_casual
from #yearly_data
where len(ride_id) = 16
and start_station_name <> ''
and end_station_name <> ''

         ----- checking ride duration for check if there is any outliers ---
select max(ride_duration) max ,min(ride_duration) min 
from #clean_data  ----  min(ride_duration) is coming in - which is incorrect ----

    ---- checking all our new data set which is stored in our temp table ----
select *
from #clean_data
where ride_duration >0

                      ----  start to analyze our data ---

	 --- question # 1 what is the total number of members & casuals riders ---

select member_casual, count (*) total_member_casual
from #clean_data
where ride_duration >0
group by member_casual --- good for viz ---
 

    -----  question # 2 which rideable_type members & casuals are riding ---


select rideable_type, count (member_casual) as member
from #clean_data 
where member_casual = 'member'
and ride_duration >0
group by rideable_type

select rideable_type, count (member_casual) as casual
from #clean_data 
where member_casual = 'casual'
and ride_duration >0
group by rideable_type

  -----   question # 3 what is the average ride duration between members & casuals ---

  select member_casual, AVG(ride_duration) avg_duration 
  from #clean_data
  where ride_duration >0
  group by member_casual --- interesting -- nice to plot 

  ----  question # 4  which days of the week member & casual ride differantly ---
 
select day_of_theWeek, count (member_casual) as casual
from #clean_data 
where member_casual = 'casual'
and ride_duration >0
group by day_of_theWeek
order by casual desc

select day_of_theWeek, count (member_casual) as member
from #clean_data 
where member_casual = 'member'
and ride_duration >0
group by day_of_theWeek
order by member desc  -- nice to plot --

    ----  question # 5 which month of the year they are using our cyclstic the most ---
select month_of_the_year  ,  count (member_casual) as casual
from #clean_data 
where member_casual = 'casual'
and ride_duration >0
group by month_of_the_year
order by casual desc  

--
select month_of_the_year  ,  count (member_casual) as member
from #clean_data 
where member_casual = 'member'
and ride_duration >0
group by month_of_the_year
order by member desc  -- nice to plot --


    ----  question 6 which areas members & casuals ride from ---

select member_casual, start_station_name,start_lat, end_lng,end_lat,start_lng
from #clean_data
where member_casual = 'casual'
and ride_duration >0
 

select member_casual,start_station_name,end_station_name, start_lat, end_lng,end_lat,start_lng
from #clean_data
where member_casual = 'member' 
and ride_duration >0 --- nice to plot to identify from where riders usally start using our bikes --



