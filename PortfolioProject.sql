
/*

Covid 19 Data Exploration Project

*/

select *
from coviddata

--both the query works same

select *
from [Portfolio Project]..coviddata

--select *
--from coviddata
--order by 3,4

--select *
--from covidvaccinations
--order by 3,4

--Select Data that we are going to be using

Select location,date,total_cases,new_cases,total_deaths,population
From coviddata 

Select location,date,total_cases,new_cases,total_deaths,population
From coviddata 
order by 3,4

Select location,date,total_cases,new_cases,total_deaths,population
From coviddata 
order by 1,2

Select location,date,total_cases,new_cases,total_deaths,population
From coviddata 
where continent is not null
order by 1,2


--Looking at Total cases vs Total Deaths

Select location,date,total_cases,total_deaths , (total_deaths/total_cases)*100 as DeathPercentage
From coviddata 
order by 1,2

Select location,date,total_cases,total_deaths , (total_deaths/total_cases)*100 as DeathPercentage
From coviddata 
order by 1,2

-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From coviddata
where location like '%states%'
order by 1,2

Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From coviddata
where location like '%states%'
and continent is not null
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid 

Select Location, date, total_cases, population, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 as DeathPercentage
From coviddata
where location like '%states%'
order by 1,2

Select Location, date, total_cases, population, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 as PercentagePopulationInfected
From coviddata
--where location like '%states%'
order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population.

Select Location,population, MAX(total_cases) as HighestInfectionCount, MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)))*100 as PercentagePopulationInfected
From coviddata
--where location like '%states%'
Group By location,population
order by 1,2

Select Location,population, MAX(total_cases) as HighestInfectionCount, MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)))*100 as PercentagePopulationInfected
From coviddata
--where location like '%states%'
Group By location,population
order by PercentagePopulationInfected desc

--Showing countries with Highest Death Count per Population

Select Location,MAX(cast(total_deaths as int)) as TotalDeathCount
From coviddata
--where location like '%states%'
Group By location
order by TotalDeathCount desc

Select Location,MAX(cast(total_deaths as int)) as TotalDeathCount
From coviddata
--where location like '%states%'
where continent is not null
Group By location
order by TotalDeathCount desc

select *
from coviddata
where continent is not null
order by 3,4


--LET'S BREAK THINGS DOWN BY CONTINENT
--Not perfect but hiearchacy is correct by continent

Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From coviddata
--where location like '%states%'
where continent is not null
Group By continent
order by TotalDeathCount desc

-- below query is correct now
Select location,MAX(cast(total_deaths as int)) as TotalDeathCount
From coviddata
--where location like '%states%'
where continent is null
Group By location
order by TotalDeathCount desc

--Showing the continents with the highest death count per population

Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From coviddata
--where location like '%states%'
where continent is not null
Group By continent
order by TotalDeathCount desc

--GLOBAL NUMBERS


Select date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From coviddata
--where location like '%states%'
where continent is not null
order by 1,2

--This below query will also not work as there are two aggregate function within each other.
Select date, SUM(MAX(total_cases)) --, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From coviddata
--where location like '%states%'
where continent is not null
group by date
order by 1,2

--Error shown in the below query as group by is done on date and there are other parameters without aggregate function avaliable also.
Select date, SUM(new_cases), total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From coviddata
--where location like '%states%'
where continent is not null
group by date
order by 1,2

--Now this below query will work
Select date, SUM(new_cases) --, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From coviddata
--where location like '%states%'
where continent is not null
group by date
order by 1,2

--Both aggregate functions will work as data type is float , if it was varchar we have to cast like SUM(cast(new_deaths as int)) 
Select date, SUM(new_cases),SUM(new_deaths)--, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From coviddata
--where location like '%states%'
where continent is not null
group by date
order by 1,2

--This query is not working do not know why so.
Select date, SUM(new_cases)as total_cases,SUM(new_deaths)as total_deaths,SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From coviddata
--where location like '%states%'
where continent is not null
group by date
order by 1,2

Select SUM(new_cases)as total_cases,SUM(new_deaths)as total_deaths,SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From coviddata
--where location like '%states%'
where continent is not null
--group by date
order by 1,2

--Below all queries are same and will produce same output.
select *
from covidvaccinations
--or
select *
from [Portfolio Project]..covidvaccinations
--or
select *
from [Portfolio Project].dbo.covidvaccinations

--Using Joins 
select *
from coviddata data
Join covidvaccinations vacc
ON data.location=vacc.location
and data.date=vacc.date

--Looking at Total Population vs Vaccinations

select data.continent,data.location,data.date,data.population,vacc.new_vaccinations
from coviddata data
Join covidvaccinations vacc
ON data.location=vacc.location
and data.date=vacc.date

select data.continent,data.location,data.date,data.population,vacc.new_vaccinations
from coviddata data
Join covidvaccinations vacc
ON data.location=vacc.location
and data.date=vacc.date
order by 1,2,3

--this is the final query
select data.continent,data.location,data.date,data.population,vacc.new_vaccinations
from coviddata data
Join covidvaccinations vacc
ON data.location=vacc.location
and data.date=vacc.date
where data.continent is not null
order by 1,2,3

select data.continent,data.location,data.date,data.population,vacc.new_vaccinations
from coviddata data
Join covidvaccinations vacc
ON data.location=vacc.location
and data.date=vacc.date
where data.continent is not null
order by 2,3

select data.continent,data.location,data.date,data.population,vacc.new_vaccinations,
SUM(cast(vacc.new_vaccinations as int)) OVER (Partition by data.location)
from coviddata data
Join covidvaccinations vacc
ON data.location=vacc.location
and data.date=vacc.date
where data.continent is not null
order by 2,3

--In casting int replaced by bigint as int was throwing arithmetic overflow error converting espression to data type int 
select data.continent,data.location,data.date,data.population,vacc.new_vaccinations,
SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by data.location)
from coviddata data
Join covidvaccinations vacc
ON data.location=vacc.location
and data.date=vacc.date
where data.continent is not null
order by 2,3

--Add the cumulative data of the new_vaccinations which is the rolling count.
select data.continent,data.location,data.date,data.population,vacc.new_vaccinations,
SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by data.location Order by data.location,data.date) as RollingPeopleVaccinated
from coviddata data
Join covidvaccinations vacc
ON data.location=vacc.location
and data.date=vacc.date
where data.continent is not null
order by 2,3

select data.continent,data.location,data.date,data.population,vacc.new_vaccinations,
SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by data.location Order by data.location,data.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from coviddata data
Join covidvaccinations vacc
ON data.location=vacc.location
and data.date=vacc.date
where data.continent is not null
order by 2,3

--USE CTE
--Here the values inside CTE should be same as in select statement.
With PopvsVac(Continent,Location,date,Population,new_vaccinations,RollingPeopleVaccinated)
as 
(
select data.continent,data.location,data.date,data.population,vacc.new_vaccinations,
SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by data.location Order by data.location,data.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from coviddata data
Join covidvaccinations vacc
ON data.location=vacc.location
and data.date=vacc.date
where data.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/Population)*100 as RollingPercentage
From PopvsVac


--TEMP TABLE(temp table not running)
DROP Table if exists #PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select data.continent,data.location,data.date,data.population,vacc.new_vaccinations,
SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by data.location Order by data.location,data.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from coviddata data
Join covidvaccinations vacc
ON data.location=vacc.location
and data.date=vacc.date
where data.continent is not null
--order by 2,3

Select *,(RollingPeopleVaccinated/population)*100 as RollingPercentage
From #PercentPopulationVaccinated
+

--Creating view to store data for later visualization
Create View PercentPopulationVaccinated as
select data.continent,data.location,data.date,data.population,vacc.new_vaccinations,
SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by data.location Order by data.location,data.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from coviddata data
Join covidvaccinations vacc
ON data.location=vacc.location
and data.date=vacc.date
where data.continent is not null
--order by 2,3


Select *
from PercentPopulationVaccinated


