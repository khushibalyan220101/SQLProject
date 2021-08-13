Select *
From PortfolioProject..covidDeaths
where continent is not null
order by 3,4

--Select *
--From PortfolioProject..covidVaccinations
--order by 3,4
--Select data

Select location, date, total_cases, new_cases, total_deaths,population
From PortfolioProject..covidDeaths
where continent is not null
order  by 1,2

--Total cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..covidDeaths
Where location like 'India'
and continent is not null
order  by 1,2

--Total cases vs Population
--Shows what percentage of population got Covid
Select location, date, population, total_cases, (total_cases/population)*100 as PopulationPercentInfected
From PortfolioProject..covidDeaths
--Where location like 'India'
where continent is not null
order  by 1,2

--Countries with highest infection rate compared to population
Select location, population, MAX(total_cases) as HighestInfectionCount, MaX((total_cases/population))*100 as PopulationPercentInfected
From PortfolioProject..covidDeaths
--Where location like 'India'
where continent is not null
Group by location, population
order  by PopulationPercentInfected desc

--Countries with Highest Death Count per Population
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..covidDeaths
where continent is not null
--Where location like 'India'
Group by location
order  by TotalDeathCount desc

--Analyze continent wise
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..covidDeaths
where continent is not null
--Where location like 'India'
Group by continent
order  by TotalDeathCount desc

--Can also find continents with the highest death count per population

--Global numbers
Select SUM(new_cases) as CasesTillDate,SUM(cast(new_deaths as int)) as DeathsTillDate,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..covidDeaths
Where continent is not null
--Group by date
order  by 1,2


--Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location order by dea.location 
,dea.date) as RollingPeopleVaccinated
From PortfolioProject..covidVaccinations vac
Join PortfolioProject..covidDeaths dea
On dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null
order by 2,3



--Use CTE
With PopvsVac (Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location order by dea.location 
,dea.date) as RollingPeopleVaccinated
From PortfolioProject..covidVaccinations vac
Join PortfolioProject..covidDeaths dea
On dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/Population)*100 as TotalPercentVaccinatedByLocation
From PopvsVac


--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location order by dea.location 
,dea.date) as RollingPeopleVaccinated
From PortfolioProject..covidVaccinations vac
Join PortfolioProject..covidDeaths dea
	On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
--order by 2,3

Select * 
From PercentPopulationVaccinated
