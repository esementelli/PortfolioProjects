--select *
--from PortfoliProject..CovidDeaths$
--order by 3,4
--select *
--from PortfoliProject..CovidVaccinations$
--order by 3,4

-- looking at total cases vs total deaths

--select location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--from PortfoliProject..CovidDeaths$
--order by 2
--desc

--select location,  MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopInfected, population
-- from PortfoliProject..CovidDeaths$
--location like '%states%'
-- where location like %states$'
-- group by location, population
-- order by PercentagePopInfected desc



-- Showing Continents with highest death count per population

--select location, MAX(cast  (total_deaths as int)) as DeathCountPop 
--from PortfoliProject..CovidDeaths$
--where continent is  null
--group by location
--order by DeathCountPop desc

--Looking at Global Numbers

--select  date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int) ) as tota_cases, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
----total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
--from PortfoliProject..CovidDeaths$
--where continent is not null
--group by date 
--order by 1,2

--select * 
--from PortfoliProject..CovidDeaths$ dea
--join PortfoliProject..CovidVaccinations$ vac
--on dea.location = vac.location
--and dea.date = vac.date

-- look at Total Population vs Vaccinations

--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--from PortfoliProject..CovidDeaths$ dea
--join PortfoliProject..CovidVaccinations$ vac
--on dea.location = vac.location
--and dea.date = vac.date
--where dea.continent is not null
--order by 2,3 

--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(NUMERIC,vac.new_vaccinations)) OVER (PARTITION by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--from PortfoliProject..CovidDeaths$ dea 
--join PortfoliProject..CovidVaccinations$ vac
--on dea.location = vac.location
--and dea.date = vac.date
--where dea.continent is not null
--order by 2,3 

-- USE CTE

WITH pop_vs_vac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(NUMERIC,vac.new_vaccinations)) OVER (PARTITION by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfoliProject..CovidDeaths$ dea 
join PortfoliProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3 
)
select *, (RollingPeopleVaccinated/population)*100 as PercVac
from pop_vs_vac

-- TEMP Table
DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(NUMERIC,vac.new_vaccinations)) OVER (PARTITION by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfoliProject..CovidDeaths$ dea 
join PortfoliProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

-- Creating View to storedate for later visualization

CREATE view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(NUMERIC,vac.new_vaccinations)) OVER (PARTITION by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfoliProject..CovidDeaths$ dea 
join PortfoliProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select *
from PercentPopulationVaccinated





 
