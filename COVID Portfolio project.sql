--Total vaccinations vs population
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.date) as RollingVaccinations
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USING CTE
with PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingVaccinations)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.date) as RollingVaccinations
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
)

select *, (RollingVaccinations/Population)*100 as VaccinationPercentatge
from PopVsVac


--temp table
DROP Table if exists #VaccinationVsPopulation
CREATE TABLE #VaccinationVsPopulation
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Rolling_Vaccinations numeric
)

insert into #VaccinationVsPopulation
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.date) as RollingVaccinations
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date


select *, (Rolling_Vaccinations/Population)*100 as VaccinationPercentatge
from #VaccinationVsPopulation



--Views
create view PercentagePopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.date) as RollingVaccinations
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

--query off of our view
select location
from PercentagePopulationVaccinated
order by location