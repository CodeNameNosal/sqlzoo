# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
    SELECT m.title
    FROM castings c
    INNER JOIN movies m
      ON (c.movie_id = m.id)
    INNER JOIN actors a
      ON (c.actor_id = a.id)
    WHERE a.name = 'Harrison Ford';
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
    SELECT m.title
    FROM castings c
    INNER JOIN movies m
      ON (c.movie_id = m.id)
    INNER JOIN actors a
      ON (c.actor_id = a.id)
    WHERE a.name = 'Harrison Ford'
    AND c.ord <> 1;
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
    SELECT m.title, a.name AS star
    FROM castings c
    INNER JOIN movies m
      ON (c.movie_id = m.id)
    INNER JOIN actors a
      ON (c.actor_id = a.id)
    WHERE c.ord = 1
    AND m.yr = 1962;
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
    SELECT m.yr, count(m.title)
    FROM castings c
    INNER JOIN movies m
      ON (c.movie_id = m.id)
    INNER JOIN actors a
      ON (c.actor_id = a.id)
    WHERE a.name = 'John Travolta'
    GROUP BY m.yr
    HAVING count(m.title) >= 2;
  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
    SELECT m.title, a.name
    FROM castings c
    INNER JOIN movies m
      ON (c.movie_id = m.id)
    INNER JOIN actors a
      ON (c.actor_id = a.id)
    WHERE c.ord = 1
    AND m.title IN (
      SELECT m.title
      FROM castings c
      INNER JOIN movies m
        ON (c.movie_id = m.id)
      INNER JOIN actors a
        ON (c.actor_id = a.id)
      WHERE a.name = 'Julie Andrews'
    );
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
    SELECT pro_actors.person
    FROM (
      SELECT actors.name as person, COUNT(castings.movie_id) AS tally
      FROM actors
      INNER JOIN castings
      ON (actors.id = castings.actor_id)
      WHERE castings.ord = 1
      GROUP BY actors.name
    ) AS pro_actors
    WHERE pro_actors.tally >= 15
    ORDER BY pro_actors.person;
  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
    SELECT m.title, COUNT(c.actor_id) as actor_count
    FROM castings c
    INNER JOIN movies m
      ON (c.movie_id = m.id)
    WHERE m.yr = 1978
    GROUP BY m.title
    ORDER BY actor_count DESC, m.title;
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have worked with 'Art Garfunkel'.
  execute(<<-SQL)
    SELECT a.name
    FROM actors a
    INNER JOIN castings c ON (a.id = c.actor_id)
    WHERE c.movie_id IN (
      -- find all movie_id's of movies Garfunkel has been in
      SELECT c.movie_id
      FROM castings c
      INNER JOIN actors garf ON (garf.id = c.actor_id)
      WHERE garf.name = 'Art Garfunkel'
    )
    AND a.name <> 'Art Garfunkel';
  SQL
end
