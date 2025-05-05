/*
 Print the unique names of all individuals who were an actor in a movie
 where that actor was in a movie with someone who acted in a movie that
 included Kevin Bacon but not in any movie as an actor with Kevin Bacon.
 */

/*
 ===== Temporary Tables =====
 baconTitles
 actedWithBacon
 actedTitles
 actedWithActed
 ============================
 */

/*
 All titles that Kevin Bacon is in
 */
create temp table baconTitles as
select p.tconst
from titlePrincipals p
join nameBasics b on p.nconst = b.nconst
where b.primaryname = 'Kevin Bacon' and p.category = 'actor';

/*
 All Actors that are in a Kevin Bacon title
 */
create temp table actedWithBacon as
select distinct p.nconst
from baconTitles b
join titlePrincipals p on b.tconst = p.tconst
where p.category = 'actor'
  and p.nconst not in (select nconst from nameBasics where primaryname = 'Kevin Bacon');

/*
 All titles that actors who are in a Kevin Bacon
 title have acted in
 */
create temp table actedTitles as
select distinct p.tconst
from actedWithBacon awb, titlePrincipals p
where awb.nconst = p.nconst
  and p.category = 'actor';

/*
 All actors who have been in a title with an actor
 who had been in a Kevin Bacon title, but not in a
 Kevin Bacon title themselves
 */
create temp table actedWithActed as
select distinct n.primaryname
from nameBasics n join titlePrincipals p on n.nconst = p.nconst,
     actedTitles at
where p.tconst = at.tconst
  and n.nconst = p.nconst
  and p.category = 'actor'
  and n.nconst not in (select nconst from actedWithBacon)
  and at.tconst not in (select tconst from baconTitles);