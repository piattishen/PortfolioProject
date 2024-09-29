-- global numbers -- Tableau1
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases) *100 as DeathPercentage
from CovidDeaths
where continent is not null
-- group by date
order by 1,2

-- global numbers except world, european union, international -- tabelau table 2
select location, sum(new_deaths) as TotalDeathCount
from CovidDeaths
where continent is null
and location not in ('World','European Union','International')
Group by location
order by TotalDeathCount desc

-- country highest infection per population -- tableau table3
select location, population, max(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PercentPopulationInfected
from CovidDeaths
group by location, population
order by PercentPopulationInfected desc

-- country percentage of population with time -- tableau table 4
select location, Population, date, max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentagePopulationInfected
from CovidDeaths
group by Location, population, date
order by PercentagePopulationInfected desc