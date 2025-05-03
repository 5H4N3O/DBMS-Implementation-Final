/*
 leave out the titles from title.basics.tsv
 that have 1 for the value isAdult.
 */
create table titleBasics as
select *
from temptitlebasics
where isadult = 0;

