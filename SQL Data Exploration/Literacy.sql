select * from literacy;
select * from population;

-- Number of rows in our dataset
select count(*) from literacy;

-- dataset for Madhyapradesh and Gujarat only
select * from literacy 
where State in ('Gujarat' , 'Madhya Pradesh');

-- Total Population Of india
select sum(population) 'Total Population' from population;

-- Average Growth Percentage of India
select avg(Growth) 'Average Growth %' from literacy;

-- Average Growth Percentage Statewise
select State,avg(Growth) 'Average Growth %' from literacy
group by State
Order by `Average Growth %` desc;

-- Average Sex_ratio Statewise
select state, round(avg(Sex_Ratio),0) 'Sex Ratio'  from literacy
group by State;

-- State Avg Literacy Rate > 90
Select State ,avg(Literacy) 'Average Literacy' from literacy
group by State Having `Average Literacy`>90
order by `Average Literacy`;

-- top 3 States With Highest Growth
select state , avg(Growth) 'Average Growth'from literacy
group by state
order by `Average Growth` desc
limit 3;

-- Bottom 3 States With Highest Growth
select state , avg(Growth) 'Average Growth'from literacy
group by state
order by `Average Growth` 
limit 3;

-- Creating Temporary Table 
CREATE TEMPORARY TABLE  if not exists Topstates(
State Varchar(27) , 
topstate float
);

Insert into Topstates
select state , avg(Literacy) from literacy
group by state order by avg(Literacy) desc;

select distinct * from Topstates order by topstate desc;


CREATE TEMPORARY TABLE  if not exists bottomstates(
State Varchar(27) , 
bottomstate float
);

Insert into bottomstates
select state , avg(Literacy) from literacy
group by state order by avg(Literacy) ;

select distinct * from bottomstates order by bottomstate ;

-- Top 3 and bottom 3 states in terms of Literacy Using Union Operator
Select * from(
select distinct * from Topstates order by topstate desc limit 3)a

Union
Select * from (
select distinct * from bottomstates order by bottomstate limit 3)b ;

-- States Starting with letter a
select distinct State from literacy where State like 'a%' or State like 'm%'
order by State;

-- Getting No of Males and Females through Sex_ratio
Select l.District , l.State , Round(Population/(1+Sex_Ratio/1000)) 'Males',
Population-Round(Population/(1+Sex_Ratio/1000)) 'Females'
From population p
join literacy l on l.District=p.District;

-- Getting No of Males and Females through Sex_ratio Statewise
Select  l.State , sum(Round(Population/(1+Sex_Ratio/1000))) 'Males',
sum(Population-Round(Population/(1+Sex_Ratio/1000))) 'Females'
From population p
join literacy l on l.District=p.District
group by l.State
order by l.State;

-- Total number of Male,Female also Literate And Iliterate People
Select l.District , l.State , Round(Population/(1+Sex_Ratio/1000)) 'Males',
Population-Round(Population/(1+Sex_Ratio/1000)) 'Females' , 
round(Population*Literacy/100) 'Total Literate People',
round(Population - (Population*Literacy/100)) 'Total Iliterate People'
From population p
join literacy l on l.District=p.District;

-- Total number of Male,Female also Literate And Iliterate People Statewise
Select  l.State , sum(Round(Population/(1+Sex_Ratio/1000))) 'Males',
sum(Population-Round(Population/(1+Sex_Ratio/1000))) 'Females' , 
sum(round(Population*Literacy/100)) 'Total Literate People',
sum(round(Population - (Population*Literacy/100))) 'Total Iliterate People'
From population p
join literacy l on l.District=p.District
group by l.State
order by l.State;

-- Geting Previous Census Population Using Growth Rate
select l.District , l.State , 
round(Population/(1+Growth/100)) 'Previous Census Population Count',
Population 'Current Census Population Count',
Growth 'Growth %'
from literacy l
join population p on p.District=l.District;

-- Geting Previous Census Population Using Growth Rate StateWise
select  l.State , 
sum(round(Population/(1+Growth/100))) 'Previous Census Population Count',
sum(Population) 'Current Census Population Count',
Avg(Growth) 'Growth %'
from literacy l
join population p on p.District=l.District
group by l.state
order by l.State;

-- Geting Previous Census total Population of india Using Growth Rate 
select sum(round(Population/(1+Growth/100))) 'Previous Census Population Count',
sum(Population) 'Current Census Population Count',
Avg(Growth) 'Growth %'
from literacy l
join population p on p.District=l.District;

-- Getting Area per person During Previous and current Census Using Column Area_km2 
select sum(round(Population/(1+Growth/100))) 'Previous Census Population Count',
sum(Population) 'Current Census Population Count',
sum(Area_km2)/sum(round(Population/(1+Growth/100))) 'Area Per Person During Previous Census',
sum(Area_km2)/sum(Population) 'Area Per Person During Current Census',
sum(Area_km2)
from literacy l
join population p on p.District=l.District;

-- Top 3 Districts From Each State With Highest Literacy Rate Using Window Function
select * from 
(Select District , State , Literacy , 
rank() over(partition by State order by Literacy desc)Rnk from literacy)a
where a.Rnk in (1,2,3);


