--Data analysis for Covid19 cases and Deaths in Top affected Countries


select * 
from PortfolioProject..CovidDeaths
Where continent is not null
order by 3, 4

select *
from CovidVaccinations
order by 3, 4

select location, date, total_cases, new_cases total_deaths, population
from CovidDeaths
order by 1, 2

--looking at Total cases vs Total deaths
--shows likelyhood of dying if you contract covid in your country

select location, date, total_cases, new_cases total_deaths, (total_deaths/total_cases)*100 as Death_Percentages
from CovidDeaths
Where location like '%states%' AND
 continent is not null
order by 1, 2

--Looking at Total cases vs Population 
--Shows what percentage got Covid

select location, date, population, total_cases, new_cases total_deaths, (total_cases/population)*100 as PercentagePopulationInfected
from CovidDeaths
--Where location like '%states%'
order by 1, 2

--Looking at the countries with highest infection Rate compared to population

select location, population, max(total_cases) as highestInfectionCount, Max((total_cases/population))*100 as PercentagePopulationInfected
from CovidDeaths
--Where location like '%states%'
Group by location, population
Order by PercentagePopulationInfected desc

--Showing countries with Highest death count per population

select location, max(cast(total_deaths AS int)) as TotalDeathCount
from CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location
Order by TotalDeathCount  desc

--Let's break things down by continent
--Showing continents with the highest death count per population

select Continent, max(cast(total_deaths AS int)) as TotalDeathCount
from CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by Continent
Order by TotalDeathCount  desc

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))
/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null 
order by 1,2


--Crating view  to store data for later visualization

--1.Creating view for Total cases vs Total deaths
Create view TotalCaseVStotalDeaths as
select location, date, total_cases, new_cases total_deaths, (total_deaths/total_cases)*100 as Death_Percentages
from CovidDeaths
Where location like '%states%' AND
 continent is not null
--order by 1, 2

--2.Creating view for Looking at Total cases vs Population
Create view TotalCasesVSpopulation as
select location, date, population, total_cases, new_cases total_deaths, (total_cases/population)*100 as PercentagePopulationInfected
from CovidDeaths
--Where location like '%states%'
--order by 1, 2

 --3.Creating view for the countries with highest infection Rate compared to population
 Create view HighestInfectionRateComparedToPopulation as
select location, population, max(total_cases) as highestInfectionCount, Max((total_cases/population))*100 as PercentagePopulationInfected
from CovidDeaths
--Where location like '%states%'
Group by location, population
--Order by PercentagePopulationInfected desc


--4.Creating view of countries with Highest death count per population
Create view HighestDeathCountPerPopulation as
select location, max(cast(total_deaths AS int)) as TotalDeathCount
from CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location
--Order by TotalDeathCount  desc

/*
Queries used for Tableau Project
*/



-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc