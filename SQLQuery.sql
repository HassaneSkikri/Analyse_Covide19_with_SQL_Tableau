-- View all data in the CovidDeaths table

SELECT * 
FROM CovidProject..CovidDeaths;

-- Select important data with aliases for better readability
SELECT 
    location AS Location,
    date AS Date,
    population AS Population,
    total_cases AS TotalCases,
    new_cases AS NewCases,
    total_deaths AS TotalDeaths,
    new_deaths AS NewDeaths
FROM CovidProject..CovidDeaths
ORDER BY Location, Date;

-- Calculate total deaths and total cases for the entier world

SELECT 
    SUM(new_cases) AS TotalCases,
    SUM(CAST(new_deaths AS int)) AS TotalDeaths  --we use CAST because new_deaths is nvarchar
FROM CovidProject..CovidDeaths
WHERE continent is not null;

-- Calculate total deaths and total cases for each location

SELECT 
	Location ,
    SUM(new_cases) AS TotalCases,
    SUM(CAST(new_deaths AS int)) AS TotalDeaths
FROM CovidProject..CovidDeaths
GROUP BY location
ORDER BY 3;

--note that if you scroll to the end of that query you will find that the total cases and deathes for the row 'world' is the same as the preveas quiery

-- Calculate death percentage __PercentageRate__ " for Morocco"

SELECT 
    location AS Location,
    date AS Date,
    population AS Population,
    total_cases AS TotalCases,
    total_deaths AS TotalDeaths,
    ROUND((CAST(total_deaths AS float) / total_cases ) * 100, 4) AS DeathPercentage
FROM CovidProject..CovidDeaths
WHERE location LIKE '%Morocco%'
ORDER BY Location, Date;

-- Calculate infected percentage __PercentageRate__ "for Morocco"
SELECT 
    location AS Location,
    date AS Date,
    population AS Population,
    total_cases AS TotalCases,
    ROUND((CAST(total_cases AS float) / population) * 100, 4) AS InfectedPercentage
FROM CovidProject..CovidDeaths
WHERE location LIKE '%Morocco%'
ORDER BY Location, Date;

-- Find the location with the <<highest>> cases and infected rate
SELECT 
    Location,
    population AS Population,
    MAX(total_cases) AS HighestCases,
    MAX((CONVERT(float,total_cases) /population ) * 100) AS HighestInfectedRate
FROM CovidProject..CovidDeaths
WHERE continent is not null
GROUP BY Location, population
ORDER BY HighestInfectedRate DESC;

-- Find the location with the highest deaths and death rate

SELECT 
    Location,
    population AS Population,
    MAX(CAST(total_deaths AS int)) AS HighestDeaths,
    MAX((CAST(total_deaths AS float) / total_cases) * 100) AS HighestDeathRate
FROM CovidProject..CovidDeaths
GROUP BY Location, population
ORDER BY HighestDeathRate DESC;


-- Calculate total cases and deaths by continent
SELECT
    location AS Continent,
    SUM(new_cases ) AS TotalCasesInContinent,
    SUM(CAST(new_deaths AS int)) AS TotalDeathsInContinent
FROM
    CovidProject..CovidDeaths
WHERE continent IS NULL
GROUP BY
    location
ORDER BY
    TotalDeathsInContinent DESC;

--what is the total deaths,cases, percentage cases and percentage deaths for each date
SELECT
    date AS Date,
    SUM(new_cases) AS TotalCases,
    SUM(CAST(new_deaths AS int)) AS TotalDeaths,
    CASE 
        WHEN SUM(new_cases) = 0 THEN 0 -- Handle division by zero
        ELSE (SUM(new_cases) / NULLIF(SUM(population), 0)) * 100
    END AS InfectedPercentage,
    CASE
        WHEN SUM(new_cases) = 0 THEN 0 -- Handle division by zero
        ELSE (SUM(CAST(new_deaths AS float)) / SUM(new_cases)) * 100
    END AS DeathPercentage
FROM
    CovidProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY Date;




-----------------------------------------------------

--view the covid vaccination table
SELECT *
FROM CovidProject..CovidVaccinations;


--join the two tables
--calculate the total vaccination for each day for each location 
--calculate the total vaccination rate


WITH CTE_TABLE
AS
(
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS TotalVaccinated
    FROM
        CovidProject..CovidDeaths dea
    JOIN
        CovidProject..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
    WHERE
        dea.continent IS NOT NULL
)

Select *, (TotalVaccinated/Population)*100 AS TotalVaccinationRate
From CTE_TABLE
ORDER BY 1,2;

--what is the total vaccination for each day 

SELECT
    dea.date,
    SUM(CAST(vac.new_vaccinations AS INT)) AS total_vaccination
FROM
    CovidProject..CovidDeaths dea
JOIN
    CovidProject..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
GROUP BY
    dea.date
ORDER BY
    dea.date;


-- Using Temp Table 

--first i need to (deletes) the table. This step ensures that i start with a clean state
DROP Table if exists #VaccinatedRate

Create Table #VaccinatedRate
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population float,
	New_vaccinations float,
	TotalVaccinated float
)

Insert into #VaccinatedRate
Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as TotalVaccinated
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

Select *, (TotalVaccinated/Population)*100 AS VaccinationRate
From #VaccinatedRate




-- Creating View to store data for later visualizations

CREATE VIEW VaccinatedRate AS
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as TotalVaccinated
FROM CovidProject..CovidDeaths dea
JOIN CovidProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;


