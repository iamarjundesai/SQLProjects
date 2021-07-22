Select *
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4

--Select *
--From PortfolioProject..CovidVacc
--Order by 3,4

--Selecting the Data we need to create a view for

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2

-- Death percentage in India

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
Where location like '%India%'
Order by 1,2

-- The total cases vs Population

Select Location, date, total_cases, Population, (total_cases/population)*100 as Infection_Percentage
From PortfolioProject..CovidDeaths
Where location like'%India%'
Order by 1,2

--Countries with highest Infection rate compared to Population

Select Location, MAX(total_cases) as Highest_Infection_Count, Population, MAX((total_cases/population))*100 as Infection_Percentage
From PortfolioProject..CovidDeaths
Group by Location, Population
Order by Infection_Percentage desc

-- Showing Highest Deathcount per population 

Select Location, MAX(cast(total_deaths as int)) as TotalDeathcount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
Order by 2 desc

-- Breaking by continent

Select continent, MAX(cast(total_deaths as int)) as TotalDeathcount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Continent
Order by 2 desc

-- Location where continent is not null

Select location, MAX(cast(total_deaths as int)) as TotalDeathcount
From PortfolioProject..CovidDeaths
Where continent is null
Group by location
Order by 2 desc

-- GLOBAL VALUES

Select SUM(new_cases) as Total_Cases_in_the_World, SUM(cast(new_deaths as int)) as Total_Deaths_In_the_World, (SUM(cast(new_deaths as int)))/SUM(new_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
--Where location like '%India%'
Where continent is not null
--Group by date
Order by 1,2

-- Total People Vaccinated

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as Counting_Total_Vacc 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacc vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


-- Using CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, Counting_Total_Vacc)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as Counting_Total_Vacc 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacc vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
) 
Select *, (Counting_Total_Vacc/Population)*100 as Percentage_of_vacc
From PopvsVac


-- Temp Table

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(200),
Location nvarchar(200),
Date datetime,
Population numeric,
new_vaccinations numeric,
Counting_Total_Vacc numeric,
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as Counting_Total_Vacc 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacc vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null

Select *, (Counting_Total_Vacc/Population)*100 as Percentage_of_vacc
From #PercentPopulationVaccinated

Select *
From #PercentPopulationVaccinated


-- Creating Views

Create View PercentPopulationvaccinatedd as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as Counting_Total_Vacc 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacc vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null

Select *
From PercentPopulationvaccinated
