/*
 Determine the top 5 actors, writers, or producers who have worked on
 the same movie as Kevin Bacon by how many times they worked on movies
 with Kevin Bacon (excluding Kevin Bacon himself).
 */

 /*
 ===== Temporary Tables =====
 baconMovies
 eligiblePeople
 ============================
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

select n.primaryname, count(distinct p.tconst) as baconMovies
from titleprincipals p
    join eligiblePeople e on p.nconst = e.nconst
    join nameBasics n on n.nconst = e.nconst
    join baconMovies b on b.tconst = p.tconst
where (p.category = 'actor' or p.category = 'writer' or p.category = 'producer')
group by n.primaryname
order by baconMovies desc
limit 5;
