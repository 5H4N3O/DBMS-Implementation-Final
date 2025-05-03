/*
 leave out the titles from title.basics.tsv
 that have 1 for the value isAdult.
 */
create table titleBasics as
select *
from temptitlebasics
where isadult = 0;

/* ========== Fixing titleBasics genres ========== */
alter table titleBasics
add constraint titleBasics_pk primary key (tconst);

create table genres (
    genre varchar(30) primary key
);

insert into genres (genre) values
('Action'),
('Adult'),
('Adventure'),
('Animation'),
('Biography'),
('Comedy'),
('Crime'),
('Documentary'),
('Drama'),
('Family'),
('Fantasy'),
('Film-Noir'),
('Game-Show'),
('History'),
('Horror'),
('Music'),
('Musical'),
('Mystery'),
('News'),
('Reality-TV'),
('Romance'),
('Sci-Fi'),
('Short'),
('Sport'),
('Talk-Show'),
('Thriller'),
('War'),
('Western');

create table titleGenres (
    tconst varchar(12) not null,
    genre varchar(30) not null,
    primary key (tconst, genre),
    foreign key (tconst) references titleBasics(tconst)
);

insert into titleGenres (tconst, genre)
select tconst, trim(genre) as genre
from (
    select tconst, unnest(string_to_array(genres, ',')) as genre
    from titleBasics
    where genres is not null
     ) as split_genres
where genre <> '';
/* ================================================================ */
