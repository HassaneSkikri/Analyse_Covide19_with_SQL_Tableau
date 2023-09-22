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

