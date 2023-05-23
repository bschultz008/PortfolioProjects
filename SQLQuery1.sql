select *
from PortfolioProject..CovidDeaths$
where continent is not null
Order by 3,4;


--Select *
--From PortfolioProject..CovidVaccinations$
--Order by 3,4;

--Select the data that we are going to be using


SELECT Location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths$
order by 1, 2;

--Looking at the total cases vs total deaths
--Shows the liklehood of dying if you contract covid in your country
SELECT Location,date,total_cases,total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where location like '%fric%'
order by 1, 2;

--Looking at the total cases vs the population
SELECT Location,date,total_deaths,total_cases,population, (total_cases/population) * 100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
where location like '%states%'
order by 1, 2;

--Looking at countries with highest infection rate compared to population
SELECT	location, 
		population, 
		max(total_cases) as highestInfectionCount, 
		max(total_cases/population) * 100 as PercentPopulationInfected
		
from PortfolioProject..CovidDeaths$
--where location like '%states%'
group by location,population
order by PercentPopulationInfected desc;

--Showing the countries with the highest death count per population


SELECT	location, 
		max(cast(total_deaths as int)) as TotalDeathCount
		from PortfolioProject..CovidDeaths$
		where continent is not null
--where location like '%states%'
group by location
order by TotalDeathCount desc;


--We are going to do this by the continent now
SELECT	location, 
		max(cast(total_deaths as int)) as TotalDeathCount
		from PortfolioProject..CovidDeaths$
		where continent is not null
--where location like '%states%'
group by location
order by TotalDeathCount desc;


--Global numbers

SELECT	date, 
		SUM(new_cases) as total_cases,
		sum(cast(new_deaths as int)) as total_deaths,
		sum(cast(new_deaths as int))/sum(new_cases) * 100 DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
group by date
order by 1, 2;


--Number of total cases, total deaths, and death percentage across the world
SELECT	date, 
		SUM(new_cases) as total_cases,
		sum(cast(new_deaths as int)) as total_deaths,
		sum(cast(new_deaths as int))/sum(new_cases) * 100 DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
--group by date
order by 1, 2;

--looking at total population vs vaccinations 
select	dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVacs
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3



--USE CTE

with PopvsVac  (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVacs)
as
(select dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVacs
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVacs/Population)*100
From PopvsVac








--TEMP TABLE
DROP TABLE  if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVacs numeric
)


Insert into #PercentPopulationVaccinated
select dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVacs
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVacs/Population)*100
From #PercentPopulationVaccinated



--Create view to store data for late visualizations

Create view PercentPopulationVaccinated as
select  dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVacs
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3