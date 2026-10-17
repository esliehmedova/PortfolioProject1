select * 
from portfolioprojects.covidvaccinations;

/*
drop table if exists portfolioprojects.coviddeaths;
drop table if exists portfolioprojects.coviddeaths_backup;
drop table if exists portfolioprojects.covidvaccinations; 
*/

alter table portfolioprojects.covidvaccinations
drop column `Unnamed: 4`;

SELECT CONCAT('ALTER TABLE portfolioprojects.covidvaccinations ',
       GROUP_CONCAT(CONCAT('DROP COLUMN `', column_name, '`') SEPARATOR ', '), ';')
FROM information_schema.columns
WHERE table_schema = 'portfolioprojects'
  AND table_name = 'covidvaccinations'
  AND column_name LIKE 'Unnamed%'; 
  
ALTER TABLE portfolioprojects.covidvaccinations DROP COLUMN `Unnamed: 10`, DROP COLUMN `Unnamed: 11`, DROP COLUMN `Unnamed: 12`, DROP COLUMN `Unnamed: 13`, DROP COLUMN `Unnamed: 14`, DROP COLUMN `Unnamed: 15`, DROP COLUMN `Unnamed: 16`, DROP COLUMN `Unnamed: 17`, DROP COLUMN `Unnamed: 18`, DROP COLUMN `Unnamed: 19`, DROP COLUMN `Unnamed: 20`, DROP COLUMN `Unnamed: 21`, DROP COLUMN `Unnamed: 22`, DROP COLUMN `Unnamed: 23`, DROP COLUMN `Unnamed: 24`, DROP COLUMN `Unnamed: 3`, DROP COLUMN `Unnamed: 5`, DROP COLUMN `Unnamed: 6`, DROP COLUMN `Unnamed: 7`, DROP COLUMN `Unnamed: 8`, DROP COLUMN `Unnamed: 9`;


  
select * from portfolioprojects.covidvaccinations; 
  
describe portfolioprojects.coviddeaths; 

set sql_safe_updates = 0;

update portfolioprojects.coviddeaths
set total_deaths = null
where total_deaths = '';

alter table portfolioprojects.coviddeaths
modify total_deaths bigint;

show columns from portfolioprojects.coviddeaths;

select column_name
from information_schema.columns
where table_schema = 'portfolioprojects' and table_name = 'coviddeaths'
order by ordinal_position;

select group_concat(column_name order by ordinal_position separator ', ')
from information_schema.columns
where table_schema = 'portfolioprojects' and table_name = 'coviddeaths';

create table portfolioprojects.coviddeaths_backup as
select * from portfolioprojects.coviddeaths;

set sql_safe_updates = 0;



update portfolioprojects.coviddeaths set
  population = nullif(trim(population), ''),
  total_cases = nullif(trim(total_cases), ''),
  new_cases = nullif(trim(new_cases), ''),
  new_cases_smoothed = nullif(trim(new_cases_smoothed), ''),
  total_deaths = nullif(trim(total_deaths), ''),
  new_deaths = nullif(trim(new_deaths), ''),
  new_deaths_smoothed = nullif(trim(new_deaths_smoothed), ''),
  total_cases_per_million = nullif(trim(total_cases_per_million), ''),
  new_cases_per_million = nullif(trim(new_cases_per_million), ''),
  new_cases_smoothed_per_million = nullif(trim(new_cases_smoothed_per_million), ''),
  total_deaths_per_million = nullif(trim(total_deaths_per_million), ''),
  new_deaths_per_million = nullif(trim(new_deaths_per_million), ''),
  new_deaths_smoothed_per_million = nullif(trim(new_deaths_smoothed_per_million), ''),
  reproduction_rate = nullif(trim(reproduction_rate), ''),
  icu_patients = nullif(trim(icu_patients), ''),
  icu_patients_per_million = nullif(trim(icu_patients_per_million), ''),
  hosp_patients = nullif(trim(hosp_patients), ''),
  hosp_patients_per_million = nullif(trim(hosp_patients_per_million), ''),
  weekly_icu_admissions = nullif(trim(weekly_icu_admissions), ''),
  weekly_icu_admissions_per_million = nullif(trim(weekly_icu_admissions_per_million), ''),
  weekly_hosp_admissions = nullif(trim(weekly_hosp_admissions), ''),
  weekly_hosp_admissions_per_million = nullif(trim(weekly_hosp_admissions_per_million), ''),
  continent = nullif(trim(continent), '');
  
  describe portfolioprojects.coviddeaths;
  
  select * from portfolioprojects.coviddeaths;
  
  select new_cases_smoothed, length(new_cases_smoothed)
from portfolioprojects.coviddeaths
where new_cases_smoothed not regexp '^-?[0-9]+(\\.[0-9]+)?([eE][-+]?[0-9]+)?$'
limit 20; 

-- Select data that we are going to use 

select country, date, total_cases, new_cases, total_deaths, population
from portfolioprojects.coviddeaths
order by 1,2; 

-- I am going to look at total cases and total deaths 

select country, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from portfolioprojects.coviddeaths
where country = 'Azerbaijan'
order by 1,2; 

-- Let's look at total cases vs population
-- Show what percentage of the population got covid
select country, date, total_cases, population, (total_cases/population)*100 as CasePercentage
from portfolioprojects.coviddeaths
where country = 'Azerbaijan'
order by 1,2; 

-- Let's look at countries with the highes rate infection comared to population

select country, population, max(total_cases) as HighestCaseRate
from portfolioprojects.coviddeaths
group by country, population
order by HighestCaseRate; 

-- All those queries above are for the tables i just deleted because the types changed while importing and order functioin was not working well. 
-- So we continue with corrected two tables finally.

 -- Select data that we are going to use 
 
select * from portfolioprojects.coviddeaths;
select * from portfolioprojects.covidvaccinations;

select location, date, total_cases, new_cases, total_deaths, population
from portfolioprojects.coviddeaths
order by 1,2; 

-- I am going to look at total cases and total deaths 

select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from portfolioprojects.coviddeaths
where location = 'Azerbaijan'
order by 1,2; 

-- Let's look at total cases vs population
-- Show what percentage of the population got covid
select location, date, total_cases, population, (total_cases/population)*100 as CasePercentage
from portfolioprojects.coviddeaths
where location = 'Azerbaijan'
order by 1,2; 

-- Let's look at countries with the highes rate infection comared to population

select location, population, max(total_cases) as HighestCaseRate
from portfolioprojects.coviddeaths
group by location, population
order by HighestCaseRate; 

-- Showing countries with highest death count per population 

-- Let's break things down by continent

select continent, location, max(total_deaths) as TotalDeathCount
from portfolioprojects.coviddeaths
where continent is not null
group by continent, location
order by TotalDeathCount desc; 

select continent, max(total_deaths) as TotalDeathCount
from portfolioprojects.coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc; 

-- Global numbers

select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from portfolioprojects.coviddeaths
where continent is not null
group by date
order by 1, 2; 

-- Joining tables

select * 
from portfolioprojects.coviddeaths dea
join portfolioprojects.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date;

-- looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations)
over (Partition by dea.location order by dea.location, dea.date)  
from portfolioprojects.coviddeaths dea
join portfolioprojects.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2, 3; 

-- I will use CTE because i want to do some caculation on the column i have just created

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations)
over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolioprojects.coviddeaths dea
join portfolioprojects.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
-- order by 2, 3
)
select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac;  
 
-- Temp Table

use portfolioprojects;

drop temporary table if exists PercentPopulationVaccinated;

create temporary table PercentPopulationVaccinated
(
  continent varchar(255),
  location varchar(255),
  date datetime,
  population double,
  new_vaccinations double,
  RollingPeopleVaccinated double
);

insert into PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       sum(vac.new_vaccinations) over (partition by dea.location order by dea.date)
from portfolioprojects.coviddeaths dea
join portfolioprojects.covidvaccinations vac
  on dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null;

select *, (RollingPeopleVaccinated / population) * 100 as PercentVaccinated
from PercentPopulationVaccinated;

-- Creating view to store date for later visualization

Create View PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       sum(vac.new_vaccinations) over (partition by dea.location order by dea.date)
from portfolioprojects.coviddeaths dea
join portfolioprojects.covidvaccinations vac
  on dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
order by 2,3; 
 
 
 
 
 
 
 
 
 
 
 
 
 
 




