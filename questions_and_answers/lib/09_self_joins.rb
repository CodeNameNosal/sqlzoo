# == Schema Information
#
# Table name: stops
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: routes
#
#  num         :string       not null, primary key
#  company     :string       not null, primary key
#  pos         :integer      not null, primary key
#  stop_id     :integer

require_relative './sqlzoo.rb'

def num_stops
  # How many stops are in the database?
  execute(<<-SQL)
    SELECT COUNT(id)
    FROM stops;
  SQL
end

def craiglockhart_id
  # Find the id value for the stop 'Craiglockhart'.
  execute(<<-SQL)
    SELECT id
    FROM stops
    WHERE name = 'Craiglockhart';
  SQL
end

def lrt_stops
  # Give the id and the name for the stops on the '4' 'LRT' service.
  execute(<<-SQL)
    SELECT s.id, s.name
    FROM stops s
    INNER JOIN routes r
      ON (s.id = r.stop_id)
    WHERE r.num = '4'
    AND r.company = 'LRT';
  SQL
end

def connecting_routes
  # Consider the following query:
  #
  # SELECT
  #   company, num, COUNT(*)
  # FROM
  #   routes
  # WHERE
  #   stop_id='149' OR stop_id='53'
  # GROUP BY
  #   company, num;
  #
  # The query gives the number of routes that visit either London Road
  # (149) or Craiglockhart (53). Run the query and notice the two services
  # that link these stops have a count of 2. Add a HAVING clause to restrict
  # the output to these two routes.
  execute(<<-SQL)
    SELECT
      company, num, COUNT(*)
    FROM
      routes
    WHERE
      stop_id = '149' OR stop_id = '53'
    GROUP BY
      company, num
    HAVING COUNT(*) = 2
  SQL
end

def cl_to_lr
  # Consider the query:
  #
  # SELECT
  #   a.company, a.num, a.stop_id, b.stop_id
  # FROM
  #   routes a
  # JOIN
  #   routes b ON (a.company = b.company AND a.num = b.num)
  # WHERE
  #   a.stop_id = 53;
  #
  # Observe that b.stop_id gives all the places # you can get to from
  # Craiglockhart, without changing routes. Change the # query so that it
  # shows the services from Craiglockhart to London Road.
  execute(<<-SQL)
    -- SELECT a.company, a.num, a.stop_id, b.stop_id
    -- FROM routes a
    -- JOIN routes b
    --   ON (a.company = b.company AND a.num = b.num)
    -- JOIN stops sa
    --   ON (a.stop_id = sa.id)
    -- JOIN stops sb
    --   ON (b.stop_id = sb.id)
    -- WHERE sa.name = 'Craiglockhart'
    -- AND sb.name = 'London Road';
    -- (I had initially changed this to allow for querying stops by name, without seeing that this was the next question. Redid query to allow for query by id)

    SELECT a.company, a.num, a.stop_id, b.stop_id
    FROM routes a
    JOIN routes b ON (a.company = b.company AND a.num = b.num)
    WHERE a.stop_id = 53
    AND b.stop_id = 149;
  SQL
end

def cl_to_lr_by_name
  # Consider the query:
  #
  # SELECT
  #   a.company, a.num, stopa.name, stopb.name
  # FROM
  #   routes a
  # JOIN
  #   routes b ON (a.company = b.company AND a.num = b.num)
  # JOIN
  #   stops stopa ON (a.stop_id = stopa.id)
  # JOIN
  #   stops stopb ON (b.stop_id = stopb.id)
  # WHERE
  #   stopa.name = 'Craiglockhart'
  #
  # The query shown is similar to the previous one, however by joining two
  # copies of the stops table we can refer to stops by name rather than by
  # number. Change the query so that the services between 'Craiglockhart' and
  # 'London Road' are shown. If you are tired of these places try
  # 'Fairmilehead' against 'Tollcross'
  execute(<<-SQL)
    SELECT a.company, a.num, stopa.name, stopb.name
    FROM routes a
    JOIN routes b ON (a.company = b.company AND a.num = b.num)
    JOIN stops stopa ON (a.stop_id = stopa.id)
    JOIN stops stopb ON (b.stop_id = stopb.id)
    WHERE stopa.name = 'Craiglockhart'
    AND stopb.name = 'London Road';
  SQL
end

def haymarket_and_leith
  # Give a list of all the services which connect stops 115 and 137
  # ('Haymarket' and 'Leith')
  execute(<<-SQL)
    SELECT DISTINCT a.company, a.num
    FROM routes a
    JOIN routes b ON (a.company = b.company AND a.num = b.num)
    WHERE a.stop_id = 115
    AND b.stop_id = 137;
  SQL
end

def craiglockhart_and_tollcross
  # Give a list of the services which connect the stops 'Craiglockhart' and
  # 'Tollcross'
  execute(<<-SQL)
    SELECT a.company, a.num
    FROM routes a
    JOIN routes b ON (a.company = b.company AND a.num = b.num)
    JOIN stops stopa ON (a.stop_id = stopa.id)
    JOIN stops stopb ON (b.stop_id = stopb.id)
    WHERE stopa.name = 'Craiglockhart'
    AND stopb.name = 'Tollcross';
  SQL
end

def start_at_craiglockhart
  # Give a distinct list of the stops which may be reached from 'Craiglockhart'
  # by taking one bus, including 'Craiglockhart' itself. Include the company
  # and bus no. of the relevant services.
  execute(<<-SQL)
    SELECT DISTINCT s_other.name, r_other.company, r_other.num
    FROM routes r_craig
    JOIN routes r_other ON (r_craig.num = r_other.num
      AND r_craig.company = r_other.company)
      -- The AND here is extremely important
    JOIN stops s_craig ON (r_craig.stop_id = s_craig.id)
    JOIN stops s_other ON (r_other.stop_id = s_other.id)
    WHERE s_craig.name = 'Craiglockhart';
  SQL
end

def craiglockhart_to_sighthill
  # Find the routes involving two buses that can go from Craiglockhart to
  # Sighthill. Show the bus no. and company for the first bus, the name of the
  # stop for the transfer, and the bus no. and company for the second bus.
  execute(<<-SQL)
  -- STILL WORKING ON THIS ONE

    -- SELECT first.num, first.company, transfer.name, second.num, second.company
    -- FROM routes first
    -- JOIN routes second ON (first.num = second.num
    --   AND first.company = second.company)
    -- JOIN stops s_craig ON (first.stop_id = s_craig.id)
    -- JOIN stops s_sight ON (second.stop_id = s_sight.id)
    -- WHERE s_craig.name = 'Craiglockhart' AND s_sight.name = 'Sighthill';
  SQL
end
