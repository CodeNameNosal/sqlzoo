require_relative './sqlzoo.rb'

def example_join
  SqlZooDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      movie
    JOIN
      casting ON movie.id = casting.movieid
    JOIN
      actor ON casting.actorid = actor.id
    WHERE
      actor.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared
  SqlZooDatabase.instance.execute(<<-SQL)
    SELECT
      movie.title
    FROM
      movie
    JOIN
      casting ON casting.movieid = movie.id
    JOIN
      actor ON actor.id = casting.actorid
    WHERE
      actor.name = 'Harrison Ford';
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  SqlZooDatabase.instance.execute(<<-SQL)
    SELECT
      movie.title
    FROM
      movie
    JOIN
      casting ON casting.movieid = movie.id
    JOIN
      actor ON actor.id = casting.actorid
    WHERE
      (actor.name = 'Harrison Ford' AND casting.ord != 1);
  SQL
end

def films_and_stars_from_sixty_two 
  # List the films together with the leading star for all 1962 films.
  SqlZooDatabase.instance.execute(<<-SQL)
    SELECT
      movie.title, actor.name
    FROM
      movie
    JOIN
      casting ON casting.movieid = movie.id
    JOIN
      actor ON actor.id = casting.actorid
    WHERE
      (movie.yr = 1962 AND casting.ord = 1);
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta', show the year and the
  # number of movies he made each year for any year in which he made more than
  # 2 movies.
  SqlZooDatabase.instance.execute(<<-SQL)
    SELECT
      movie.yr, COUNT(*)
    FROM
      movie
    JOIN
      casting ON casting.movieid = movie.id
    JOIN
      actor ON actor.id = casting.actorid
    WHERE
      actor.name = 'John Travolta'
    GROUP BY
      movie.yr
    HAVING
      COUNT(*) > 2;
  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  SqlZooDatabase.instance.execute(<<-SQL)
    SELECT
      DISTINCT m1.title, a1.name
    FROM (
        SELECT
          movie.*
        FROM
          movie
        JOIN
          casting ON casting.movieid = movie.id
        JOIN
          actor ON actor.id = casting.actorid
        WHERE
          actor.name = 'Julie Andrews'
      ) AS m1
    JOIN (
        SELECT
          actor.*, casting.movieid AS movieid
        FROM
          actor
        JOIN
          casting ON casting.actorid = actor.id
        WHERE
          casting.ord = 1
      ) AS a1 ON m1.id = a1.movieid
    ORDER BY
      m1.title;
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 30
  # starring roles.
  SqlZooDatabase.instance.execute(<<-SQL)
    SELECT
      actor.name
    FROM
      actor
    JOIN
      casting ON casting.actorid = actor.id
    JOIN
      movie ON movie.id = casting.movieid
    WHERE
      casting.ord = 1
    GROUP BY
      actor.name
    HAVING
      COUNT(*) >= 30;
  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast.
  SqlZooDatabase.instance.execute(<<-SQL)
    SELECT
      movie.title, COUNT(*)
    FROM
      movie
    JOIN
      casting ON casting.movieid = movie.id
    JOIN
      actor ON actor.id = casting.actorid
    WHERE
      movie.yr = 1978
    GROUP BY
      movie.id
    ORDER BY
      COUNT(*) DESC, movie.id ASC;
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have worked with 'Art Garfunkel'.
  SqlZooDatabase.instance.execute(<<-SQL)
    SELECT
      a1.name
    FROM (
        SELECT
          movie.*
        FROM
          movie
        JOIN
          casting ON casting.movieid = movie.id
        JOIN
          actor ON actor.id = casting.actorid
        WHERE
          actor.name = 'Art Garfunkel'
      ) AS m1
    JOIN (
        SELECT
          actor.*, casting.movieid
        FROM
          actor
        JOIN
          casting ON casting.actorid = actor.id
        WHERE
          actor.name != 'Art Garfunkel'
      ) AS a1 ON m1.id = a1.movieid;
  SQL
end
