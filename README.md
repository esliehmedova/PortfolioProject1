# COVID-19 Data Exploration (SQL)

A data exploration project using global COVID-19 data on cases, deaths and vaccinations. The goal is to practice SQL on a real-world dataset and add a complete project to my portfolio.

## Tools

- **MySQL** and **MySQL Workbench** for the queries
- **Python (pandas + SQLAlchemy)** for loading the data into MySQL

## Data

Two Excel files based on Our World in Data's COVID-19 dataset:

- `CovidDeaths.xlsx` – cases, deaths and population by country and date
- `CovidVaccinations.xlsx` – vaccinations by country and date

They were loaded into MySQL as two tables: `coviddeaths` and `covidvaccinations`.

## Files

| File | Contents |
|---|---|
| `project1.sql` | All queries for the analysis |
| View section | `SELECT * FROM portfolioprojects.percentpopulationvaccinated;` – reads the saved view for later visualization |
| `import_data.py` | Loads the Excel files into MySQL with pandas |

## What the queries cover

- **Death percentage** – how likely someone with COVID was to die, using Azerbaijan as an example
- **Infection rate** – what percentage of the population got COVID
- **Countries with the highest infection rate** compared to population
- **Highest death counts** by country and by continent
- **Global numbers** – total cases, deaths and death percentage by date
- **Population vs. vaccinations** – a running total of vaccinations per country

## SQL skills used

- Aggregate functions (`SUM`, `MAX`) with `GROUP BY`
- Joins between the deaths and vaccinations tables
- Window functions (`SUM() OVER (PARTITION BY ... ORDER BY ...)`) for running totals
- CTEs (`WITH ... AS`)
- Temporary tables
- Views for storing results for visualization
- Changing column data types (`ALTER TABLE`, `NULLIF`, `CAST`)

## Notes and lessons learned

- **Data types matter.** The first import stored numbers as text, so sorting was alphabetical (`9999` came after `999964`). The numeric columns had to be converted before the results made sense.
- **Regional settings can damage CSV files.** Saving the data as CSV in Excel with non-English number settings broke the decimals (`17.142857` became `17.142.857`) and turned some numbers into dates. Loading the original Excel files directly with pandas solved this.
- **Faster import with Python.** The MySQL Workbench import wizard inserts rows one by one and took over an hour. Loading with pandas `to_sql` took a few minutes.
- **MySQL vs. SQL Server syntax.** The project follows a tutorial written for SQL Server, so some parts were adapted, for example `CREATE TEMPORARY TABLE` instead of `#TableName`.
- Rows where `continent` is empty are groupings like "World" or "Europe", not countries, so they are filtered out with `WHERE continent IS NOT NULL`.
