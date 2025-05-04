/*
 Determine the top 5 actors, writers, or producers who have
 worked on the same movie as Kevin Bacon by the proportion of
 their projects they worked on movies with Kevin Bacon vs how
 many projects they worked on (but only report for people who
 have worked on at least 5 movie projects).
 */

create temp table baconMovies as
select tconst
from titlePrincipals p
join nameBasics b on p.nconst = b.nconst
where b.primaryname = 'Kevin Bacon';

create temp table eligiblePeople as
select distinct p.nconst
from baconMovies b
join titlePrincipals p on b.tconst = p.tconst
where (p.category = 'actor' or p.category = 'writer' or p.category = 'producer')
  and p.nconst not in (select nconst from nameBasics where primaryname = 'Kevin Bacon');

select q1.name, ((q2.baconMovies*1.0)/q1.totalMovies) as baconProportion
from(
    select n.primaryname as name, count(distinct p.tconst) as totalMovies
    from titleprincipals p join eligiblePeople e on p.nconst = e.nconst
    join nameBasics n on n.nconst = e.nconst
    where (p.category = 'actor' or p.category = 'writer' or p.category = 'producer')
    group by n.primaryname
    having count(distinct p.tconst) >=5
    ) as q1,
    (
    select n.primaryname as name, count(distinct p.tconst) as baconMovies
    from titleprincipals p
    join eligiblePeople e on p.nconst = e.nconst
    join nameBasics n on n.nconst = e.nconst
    join baconMovies b on b.tconst = p.tconst
    where (p.category = 'actor' or p.category = 'writer' or p.category = 'producer')
    group by n.primaryname
    ) as q2
where q1.name = q2.name
order by baconProportion desc
limit 5;

/* Testing */
select distinct p.tconst, n.primaryname
from titleprincipals p, nameBasics n
where n.primaryname = 'Carly Norris-Kahane' and n.nconst = p.nconst;

select distinct p.tconst, n.primaryname
from titleprincipals p, namebasics n
where n.primaryname = 'Kevin Bacon' and n.nconst = p.nconst
  and p.tconst in (select distinct p.tconst from titleprincipals p, nameBasics n where n.primaryname = 'Carly Norris-Kahane' and n.nconst = p.nconst);
/* should be 8 */