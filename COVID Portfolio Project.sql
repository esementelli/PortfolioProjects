select *
from PortfolioProject..CovidDeaths
order by 3,4
select *
from PortfolioProject..CovidVaccinations
order by 3,4

 --looking at total cases vs total deaths

select location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
order by 2
desc

select location,  MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopInfected, population
 from PortfolioProject..CovidDeaths
 where location like '%states%'
 group by location, population
 order by PercentagePopInfected desc



 --Showing Continents with highest death count per population

select location, MAX(cast  (total_deaths as int)) as DeathCountPop 
from PortfolioProject..CovidDeaths
where continent is  null
group by location
order by DeathCountPop desc

--Looking at Global Numbers

select  date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int) ) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage, 
total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths
where continent is not null
group by date 
order by 1,2

select * 
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date

-- look at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(NUMERIC,vac.new_vaccinations)) OVER (PARTITION by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3 

 --USE CTE

WITH pop_vs_vac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(NUMERIC,vac.new_vaccinations)) OVER (PARTITION by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3 
)
select *, (RollingPeopleVaccinated/population)*100 as PercVac
from pop_vs_vac

 --TEMP Table
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
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

-- Creating View to storedate for later visualization

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 







 
