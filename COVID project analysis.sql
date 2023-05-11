--viewing the death records and ordering it by location and date
select *
from projectportfolio.dbo.CovidDeaths
where continent is  not null
order by 3,4
--viewing the vaccination record and ordering it by location and date
--select *
--from projectportfolio.dbo.CovidVaccinations
--order by 3,4

--picking the columns we wiil work with
select location, date, total_cases,new_cases, total_deaths,population
from projectportfolio.dbo.CovidDeaths
where continent is not null
order by 1,2
--total cases vs total death
--shows probabily of death if you contract covid in your country
select location, date, total_cases,total_deaths ,(total_deaths/total_cases* 100) as death_per_case
from projectportfolio.dbo.CovidDeaths
where location ='China'
order by 1,2

--total cases vs population
select location, date,population , total_cases,(total_cases/population* 100) as case_per_population
from projectportfolio.dbo.CovidDeaths
where location ='China'
order by 1,2

-- countries with te highest infection rate in raltion to population
select location,population , max(total_cases) as highest_infCount,(max(total_cases)/population* 100) as ptge_ofPop_infected
from projectportfolio.dbo.CovidDeaths
where continent is not null
group by location, population
order by ptge_ofPop_infected desc

--countries with the highest death count in relation with the population
select location , max(cast(total_deaths as int)) as totaldeathCount
from projectportfolio.dbo.CovidDeaths
where continent is not null
group by location
order by totaldeathCount desc

--continents with the highest death count in relation with the population
select continent , max(cast(total_deaths as int)) as totaldeathCount
from projectportfolio.dbo.CovidDeaths
where continent is not null
group by continent
order by totaldeathCount desc

--simplyfing things by continent--correct
select location , max(cast(total_deaths as int)) as totaldeathCount
from projectportfolio.dbo.CovidDeaths
where continent is null
group by location
order by totaldeathCount desc

--getting global numbers
select date, sum(new_cases), sum(cast(new_deaths as int))
from projectportfolio.dbo.CovidDeaths
where continent is not null
group by date 
order by 1,2

--getting global numbers
select date, sum(new_cases) as total_inf_cases,sum(cast(new_deaths as int)) as total_deaths_cases, sum(cast(new_deaths as int))/sum(new_cases) as death_percentage
from projectportfolio.dbo.CovidDeaths
where continent is not null
group by date 
order by 1,2

--total number of infection cases, death cases and 
select  sum(new_cases) as total_inf_cases,sum(cast(new_deaths as int)) as total_deaths_cases
from projectportfolio.dbo.CovidDeaths
where continent is not null
-- group by date 
order by 1,2

--total population vs vaccination- created view for this
create view  popVSvac as
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location, cd.date) as rollupvac
from CovidVaccinations cv
join CovidDeaths cd 
on cv.location=cd.location and cv.date=cd.date 
where cd.continent is not null --and cv.location = 'Canada'

select *, (rollupvac/population)*100  as perc_of_popVacinated
from popVSvac 






