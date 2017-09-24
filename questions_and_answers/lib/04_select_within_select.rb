# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

def example_select_with_subquery
  execute(<<-SQL)
    SELECT
      name
    FROM
      countries
    WHERE
      population > (
        SELECT
          population
        FROM
          countries
        WHERE
          name='Romania'
        )
  SQL
end

def larger_than_russia
  # List each country name where the population is larger than 'Russia'.
  execute(<<-SQL)
    SELECT name FROM countries WHERE population > (SELECT population FROM countries WHERE name = 'Russia');
  SQL
end

def richer_than_england
  # Show the countries in Europe with a per capita GDP greater than
  # 'United Kingdom'.
  execute(<<-SQL)
    SELECT name FROM countries WHERE gdp/population > (SELECT gdp/population FROM countries WHERE name = 'United Kingdom') AND continent = 'Europe';
  SQL
end

def neighbors_of_b_countries
  # List the name and continent of countries in the continents containing
  # 'Belize', 'Belgium'.
  execute(<<-SQL)
    SELECT name, continent FROM countries WHERE continent IN (SELECT continent FROM countries WHERE name IN ('Belize', 'Belgium'))
  SQL
end

def population_constraint
  # Which country has a population that is more than Canada but less than
  # Poland? Show the name and the population.
  execute(<<-SQL)
    SELECT name, population FROM countries WHERE
      population > (SELECT population FROM countries WHERE name = 'Canada')
    AND population < (SELECT population FROM countries WHERE name = 'Poland')
  SQL
end

# To get a well rounded view of the important features of SQL you should move
# on to the next tutorial concerning aggregates.

# To gain an absurdly detailed view of one insignificant feature of the
# language, read on.

# We can use the word ALL to allow >= or > or < or <=to act over a list.

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
    SELECT name FROM countries WHERE gdp > ALL(SELECT gdp FROM countries WHERE gdp is not null AND continent = 'Europe');
  SQL
end

# We can refer to values in the outer SELECT within the inner SELECT. We can
# name the tables so that we can tell the difference between the inner and
# outer versions.

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
    SELECT continent, name, area FROM countries WHERE area IN (SELECT max(area) FROM countries WHERE area is not null GROUP BY continent);
  SQL
end

# BONUS QUESTIONS: these are difficult questions that utilize techniques not
# covered in prior sections:

def sparse_continents
  # Find each country that belongs to a continent where all populations are
  # less than 25,000,000. Show name, continent and population.
  execute(<<-SQL)
    SELECT name, continent, population FROM countries where continent NOT IN (SELECT continent FROM countries WHERE population >= 25000000);
  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
    -- SELECT name, continent
    -- FROM countries first
    -- WHERE population > 3 * (
    --   SELECT avg(population)
    --   FROM countries second
    --   WHERE first.continent = second.continent
    --   GROUP BY continent
    -- );
    -- My initial way above. I was thinking that it had wanted 3 times the average population of the continent.


    SELECT first.name, first.continent
    FROM countries first
    WHERE first.population > ALL (
      SELECT second.population * 3
      FROM countries second
      WHERE first.continent = second.continent
      AND first.name <> second.name
    );
  SQL
end
