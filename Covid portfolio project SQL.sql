select *
from PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 3,4

-- select *
--from PortfolioProject.dbo.CovidVaccinations
--order by 1,2

-- total death vs total case
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%state%'
order by 1,2

-- total cases vs population
select Location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
from CovidDeaths
where location like '%state%'
order by 1,2

-- highest infection rate
select Location, MAX(total_cases) as HighestInfectionCount, population, 
MAX((total_cases/population))*100 as PercentageOfPopulation
from CovidDeaths
-- where location like '%state%'
group by Location, population
order by PercentageOfPopulation Desc

-- county with highest death per population
select Location, Max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
-- where location like '%state%'
where continent is not null
group by Location
order by TotalDeathCount Desc

-- Continent 
select location, Max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
-- where location like '%state%'
where continent is null
group by location
order by TotalDeathCount Desc

-- continent with highest death count
select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
-- where location like '%state%'
where continent is not null
group by continent
order by TotalDeathCount Desc

-- global numbers
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases) *100 as DeathPercentage
from CovidDeaths
where continent is not null
-- group by date
order by 1,2

-- total population vs vaccinations

-- CTE
with PopvsVac(continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (Partition by dea.location order by dea.location,
dea.date) as RollingReopleVaccinated
from dbo.covidDeaths dea
join dbo.covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
-- order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


-- temp table
drop table if exists #PercentPopulationVaccinated
create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (Partition by dea.Location order by dea.location,
dea.date) as RollingReopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
-- where dea.continent is not null

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


-- create view to store data for later visualization
create view PercentagePopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (Partition by dea.Location order by dea.location,
dea.date) as RollingReopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *
from PercentagePopulationVaccinated