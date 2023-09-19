--COVID DATA ANALYSIS PROJECT 2023
-- 1. 
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From portfolio_project..['Covid-death$']
--Where location like '%India%'
where continent is not null 
--Group By date
order by 1,2


--Delete unwanted rows
SELECT Distinct location
FROM portfolio_project..['Covid-death$']
SELECT *
FROM portfolio_project..['Covid-death$']
WHERE location= ('Low income')
DELETE FROM portfolio_project..['Covid-death$']
WHERE location = ('Low income')
SELECT *
FROM portfolio_project..['Covid-death$']
WHERE location= ('High income')
DELETE FROM portfolio_project..['Covid-death$']
WHERE location = ('High income')
DELETE FROM portfolio_project..['Covid-death$']
WHERE location = ('Lower middle income')
DELETE FROM portfolio_project..['Covid-death$']
WHERE location = ('Upper middle income')

--2. 

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From portfolio_project..['Covid-death$'] 
Group by location
order by TotalDeathCount desc

-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolio_project..['Covid-death$']
----Where location like '%India%'
Group by Location, Population
order by PercentPopulationInfected desc

-- 4.
DELETE FROM portfolio_project..['Covid-death$']
Where Population < total_cases


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolio_project..['Covid-death$']
--Where location like '%India%'
Group by Location, Population, date
order by PercentPopulationInfected desc


--5
Select dea.continent, dea.location, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From portfolio_project..['Covid-death$'] dea
Join portfolio_project..['Covid-vaccinations$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3

--6
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From portfolio_project..['Covid-death$']
--Where location like '%India%'
where continent is not null 
--Group By date
order by 1,2




