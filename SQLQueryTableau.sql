--Queries used for Tableau Project


--1) Calculate total Cases, total deaths and death percentage <<DeathPercentage>> for the entair world

Select 
	SUM(new_cases) as total_cases,
	SUM(cast(new_deaths as int)) as total_deaths,
	SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidProject..CovidDeaths
where continent is not null 
ORDER BY 1,2;


--2) Calculate total deaths and total cases for each continent
-- we need to exclusif 'World', 'European Union', and 'International' from the selection

SELECT 
	Location ,
    SUM(new_cases) AS TotalCases,
    SUM(CAST(new_deaths AS int)) AS TotalDeaths
FROM CovidProject..CovidDeaths
WHERE continent is null  AND location not in ('World', 'European Union', 'International')
GROUP BY location
ORDER BY 3 DESC;


--3) Find the <<highest>> cases and infected rate, Deaths and Death rate for each location order by location and population
SELECT 
    Location,
    population AS Population,
    MAX(total_cases) AS HighestCases,
    MAX((CONVERT(float, total_cases) / population) * 100) AS HighestInfectedRate,
    MAX(total_deaths) AS HighestDeaths,
    MAX((total_deaths / CONVERT(float, total_cases)) * 100) AS HighestDeathRate
FROM CovidProject..CovidDeaths
GROUP BY Location, population
ORDER BY HighestInfectedRate DESC;


--4) Find the <<highest>> cases and infected rate, Deaths and Death rate for each location order by location and population and date

SELECT 
    Location,
    population AS Population,
	date,
    MAX(total_cases) AS HighestCases,
    MAX((CONVERT(float,total_cases) /population ) * 100) AS HighestInfectedRate,
	MAX(total_deaths) AS HighestDeaths,
	MAX((total_deaths / CONVERT(float, total_cases)) * 100) AS HighestDeathRate
FROM CovidProject..CovidDeaths
GROUP BY Location, population,date	
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


