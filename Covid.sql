--Select *
--From PorfolioProject1..CovidDeaths
--Where continent is not null --will not display null continent 
--Order by 3, 4

--Select *
--From PorfolioProject1..CovidVaccinations
--Order by 1

--Select location, date, total_cases, new_cases, total_deaths, population
--From PorfolioProject1..CovidDeaths
--Order by 1, 2

--Total Case vs Total Deaths
--Shows death percentage in USA
--Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
--From PorfolioProject1..CovidDeaths
--Where location like '%state%' --looks at specific location set like United States
--Order by 1, 2

--Total Cases vs Population
--Shows percentage of population contracted covid in USA
--Select location, date, population, total_cases, (total_cases/population)*100 as covid_percentage
--From PorfolioProject1..CovidDeaths
----Where location like '%states%' --looks at specific location set like United States
--Order by 1, 2

--Countries with highest infection rate compared to population
--Select location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population))*100 as 
--	population_infected_percentage
--From PorfolioProject1..CovidDeaths
----Where location like '%states%' --looks at specific location set like United States
--Group by location, population
--Order by population_infected_percentage desc --descending

----Shows countries with highest death count per population
--Select continent, MAX(cast(total_deaths as int)) as total_death_count --cast is to convert to int
--From PorfolioProject1..CovidDeaths
----Where location like '%states%' --looks at specific location set like United States
--Where continent is not null --will not display null continent 
--Group by continent
--Order by total_death_count desc --descending

--Shows continents with highest death count per population
--Select location, MAX(cast(total_deaths as int)) as total_death_count --cast is to convert to int
--From PorfolioProject1..CovidDeaths
----Where location like '%states%' --looks at specific location set like United States
--Where continent is null --combines and displays all continent 
--Group by location
--Order by total_death_count desc --descending


--Global numbers with aggregate functions
--Select 
--	SUM(new_cases) as total_cases, 
--	SUM(cast(new_deaths as int)) as total_deaths, 
--	SUM(cast(new_deaths as int))/NULLIF(SUM(new_cases), 0)*100 as death_percentage
--From PorfolioProject1..CovidDeaths
----Where location like '%state%' --looks at specific location set like United States
--Where continent is not null
----Group by date
--Order by 1, 2

----Shows Total Population vs Vaccinations with 2 data files
--Select dea.continent,
--	dea.location,
--	dea.date,
--	dea.population,
--	vac.new_vaccinations,
--	SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated --
--	(Rolling_People_Vaccinated/population)*100
--From PorfolioProject1..CovidDeaths dea --dea is short for this file
--Join PorfolioProject1..CovidVaccinations vac --vac is short for this file
--	On dea.location = vac.location
--	and dea.date = vac.date
--Where dea.continent is not null
--Order by 2, 3

----Using CTE
--With PopvsVac (continent, location, date, population, new_vaccinations, Rolling_People_Vaccinated)
--as
--(
--Select dea.continent,
--	dea.location,
--	dea.date,
--	dea.population,
--	vac.new_vaccinations,
--	SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated --shows increment of rolling_people_vaccinated from new vacs
--	--(Rolling_People_Vaccinated/population)*100
--From PorfolioProject1..CovidDeaths dea --dea is short for this file
--Join PorfolioProject1..CovidVaccinations vac --vac is short for this file
--	On dea.location = vac.location
--	and dea.date = vac.date
--Where dea.continent is not null
----Order by 2, 3
--)
--Select*,
--	(Rolling_People_Vaccinated/population)*100
--From PopvsVac


----Temp Table
--DROP table if exists #PercentPopulationVaccinated
--Create table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_Vaccinations numeric,
--Rolling_People_Vaccinated numeric
--)

--Insert into #PercentPopulationVaccinated
--Select dea.continent,
--	dea.location,
--	dea.date,
--	dea.population,
--	vac.new_vaccinations,
--	SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated --shows increment of rolling_people_vaccinated from new vacs
--	--(Rolling_People_Vaccinated/population)*100
--From PorfolioProject1..CovidDeaths dea --dea is short for this file
--Join PorfolioProject1..CovidVaccinations vac --vac is short for this file
--	On dea.location = vac.location
--	and dea.date = vac.date
----Where dea.continent is not null
----Order by 2, 3

--Select*,
--	(Rolling_People_Vaccinated/population)*100
--From #PercentPopulationVaccinated


--Create View to store data for later visual
Create View PercentPopulationVaccinated as
Select dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated --shows increment of rolling_people_vaccinated from new vacs
From PorfolioProject1..CovidDeaths dea --dea is short for this file
Join PorfolioProject1..CovidVaccinations vac --vac is short for this file
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2, 3

--Select*
--From PercentPopulationVaccinated