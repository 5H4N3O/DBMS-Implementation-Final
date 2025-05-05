/*
 Print the unique names of movies that are more than two
 links away from Kevin Bacon that were released in 2020 or later.
 */

/*
 ===== Temporary Tables =====
 directMovies
 oneLinkPeople
 oneLinkMovies
 twoLinkPeople
 twoLinkMovies
 ============================
 */

/*
 A movie is directly linked to Kevin Bacon if Kevin Bacon
 was an actor, director, or producer of that movie.
 */
create temp table directMovies as
select tconst
from titlePrincipals p
join nameBasics b on p.nconst = b.nconst
where b.primaryname = 'Kevin Bacon'
  and (p.category = 'actor' or p.category = 'director' or p.category = 'producer');

/*
 A movie is one link away from Kevin Bacon if it is not
 directly linked to Kevin Bacon AND if has an actor, director,
 or producer who was also in a movie directly linked to Kevin Bacon
 (at any time in the past).
 */
create temp table oneLinkPeople as
select distinct p.nconst
from directMovies d
join titlePrincipals p on d.tconst = p.tconst
where (p.category = 'actor' or p.category = 'director' or p.category = 'producer')
  and p.nconst not in (select nconst from nameBasics where primaryname = 'Kevin Bacon');

create temp table oneLinkMovies as
select distinct p.tconst
from titlePrincipals p join oneLinkPeople olp on olp.nconst = p.nconst
where (p.category = 'actor' or p.category = 'director' or p.category = 'producer')
  and p.tconst not in (select tconst from directMovies);

/*
 A movie is two links away from Kevin Bacon if it is not directly
 linked or one link away from Kevin Bacon and if it has an actor, director,
 or producer who is in a movie one link away from Kevin Bacon.
 */
create temp table twoLinkPeople as
select distinct p.nconst
from oneLinkMovies olm
join titlePrincipals p on olm.tconst = p.tconst
where (p.category = 'actor' or p.category = 'director' or p.category = 'producer')
  and p.nconst not in (select nconst from nameBasics where primaryname = 'Kevin Bacon')
  and p.nconst not in (select nconst from oneLinkPeople);

create temp table twoLinkMovies as
select distinct p.tconst
from titlePrincipals p join twoLinkPeople tlp on tlp.nconst = p.nconst
where (p.category = 'actor' or p.category = 'director' or p.category = 'producer')
  and p.tconst not in (select tconst from directMovies)
  and p.tconst not in (select tconst from oneLinkMovies);

/*
 Print the unique names of movies that are more than two
 links away from Kevin Bacon that were released in 2020 or later.
 */
select distinct primaryTitle as title, startyear as releaseYear
 from titleBasics t
 where t.startyear >= 2020
   and t.tconst not in (select tconst from directMovies)
   and t.tconst not in (select tconst from oneLinkMovies)
   and t.tconst not in (select tconst from twoLinkMovies);