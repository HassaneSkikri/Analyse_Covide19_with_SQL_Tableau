# COVID-19 Analysis Project

## Overview

This project focuses on analyzing COVID-19 data using SQL queries and visualizing the results using Tableau public. We will explore various aspects of the COVID-19 pandemic, including total cases, total deaths, infection rates, vaccination rates, and more. The data is sourced from the CovidProject database.

you can see the final version [here](https://public.tableau.com/app/profile/hassane.skikri/vizzes)
## SQL Queries

### Query 1 - View All Data in the CovidDeaths Table

This query retrieves all data from the CovidDeaths table, providing a comprehensive view of the dataset.

### Query 2 - visualize the important Data

This query selects key data from the CovidDeaths table, including location, date, population, total cases, new cases, total deaths, and new deaths.

### Query 3 - Calculate Total Deaths and Total Cases for the Entire World

This query calculates the total deaths and total cases for the entire world, aggregating the data where the continent is not null.

### Query 4 - Calculate Total Deaths and Total Cases for Each Location

This query calculates the total deaths and total cases for each location, grouping the data by location and ordering it by total deaths.

### Query 5 - Calculate the Death Percentage for Morocco

This query calculates the death percentage for Morocco, showing how it evolves over time.

### Query 6 - Calculate Infected Percentage for Morocco

This query calculates the infected percentage for Morocco, displaying the percentage of the population infected over time.

### Query 7 - Find the Location with the Highest Cases and Infected Rate

This query identifies the location with the highest cases and infected rate, excluding 'World,' 'European Union,' and 'International' from the selection.

### Query 8 - Find the Location with the Highest Deaths and Death Rate

This query identifies the location with the highest deaths and death rate.

### Query 9 - Calculate Total Cases and Deaths by Continent

This query calculates total cases and deaths by continent, excluding 'World,' 'European Union,' and 'International' from the selection.

### Query 10 - Calculate Total Deaths, Cases, Percentage Cases, and Percentage Deaths for Each Date

This query provides an overview of total deaths, cases, percentage cases, and percentage deaths for each date.

### Query 11 - View the Covid Vaccination Table

This query retrieves all data from the CovidVaccinations table.

### Query 12 - Join the Two Tables and Calculate the Total Vaccination Rate

This query joins the CovidDeaths and CovidVaccinations tables and calculates the total vaccination rate for each location.

### Query 13 - Calculate Total Vaccination for Each Day

This query calculates the total vaccination for each day.

### Query 14 - Using Temp Table to Calculate Vaccination Rate

This query uses a temporary table to calculate the vaccination rate for each location.

### Query 15 - Creating a View to Store Data for Later Visualizations

This query creates a view named VaccinatedRate to store data for later visualizations.

## Tableau Public Query

In Tableau, we can create various visualizations using the following SQL queries:

### Tableau Query 1 - Calculate Total Cases, Total Deaths, and Death Percentage for the Entire World

This query calculates total cases, total deaths, and the death percentage for the entire world.

### Tableau Query 2 - Calculate Total Deaths and Total Cases for Each Continent

This query calculates total deaths and total cases for each continent, excluding 'World,' 'European Union,' and 'International.'

### Tableau Query 3 - Find the Location with the Highest Cases, Infected Rate, Deaths, and Death Rate

This query identifies the location with the highest cases, infected rate, deaths, and death rate.

### Tableau Query 4 - Find the Location with the Highest Cases, Infected Rate, Deaths, and Death Rate by Date

This query identifies the location with the highest cases, infected rate, deaths, and death rate, considering date as a parameter.

## Conclusion

The COVID-19 analysis project using SQL and Tableau Public provides a comprehensive understanding of the pandemic's impact. It covers aspects such as total cases, total deaths, infection rates, vaccination rates, and more.


## the final result:
### Covid Cases
![Covid Cases](images/Covid_cases.png)

### Covid Deaths
![Covid Deaths](images/Covid_Deaths.png)
Thank you 
