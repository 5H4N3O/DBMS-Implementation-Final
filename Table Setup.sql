/*
 github Link: https://github.com/5H4N3O/DBMS-Implementation-Final.git
 */

/**
  Imported name.basics.tsv as nameBasics
  Imported title.basics.tsv as tempTitleBasics
  Imported titlePrincipals.tsv as titlePrinciples
 */

/*
 leave out the titles from title.basics.tsv
 that have 1 for the value isAdult.
 */
create table titleBasics as
select *
from temptitlebasics t
where t.isadult = 0;

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

/* === Fixing nameBasics primaryProfession and knownForTitles === */
alter table nameBasics
add constraint nameBasics_pk primary key (nconst);

create table professions (
    profession varchar(30) primary key
);

insert into professions (profession) values
('accountant'),
('actor'),
('actress'),
('animation_department'),
('archive_footage'),
('archive_sound'),
('art_department'),
('art_director'),
('assistant'),
('assistant_director'),
('camera_department'),
('casting_department'),
('casting_director'),
('choreographer'),
('cinematographer'),
('composer'),
('costume_department'),
('costume_designer'),
('director'),
('editor'),
('editorial_department'),
('electrical_department'),
('executive'),
('legal'),
('location_management'),
('make_up_department'),
('manager'),
('miscellaneous'),
('music_artist'),
('music_department'),
('podcaster'),
('producer'),
('production_department'),
('production_designer'),
('production_manager'),
('publicist'),
('script_department'),
('set_decorator'),
('sound_department'),
('soundtrack'),
('special_effects'),
('stunts'),
('talent_agent'),
('transportation_department'),
('visual_effects'),
('writer');

create table nameProfessions (
    nconst varchar(12) not null,
    profession varchar(30) not null,
    primary key (nconst, profession),
    foreign key (nconst) references nameBasics(nconst)
);

INSERT INTO nameProfessions (nconst, profession)
SELECT nconst, TRIM(profession) AS profession
FROM (
    SELECT nconst, unnest(string_to_array(primaryProfession, ',')) AS profession
    FROM nameBasics
    WHERE primaryProfession IS NOT NULL
) AS split_professions
WHERE profession <> '';

create table nameKnownForTitles (
    nconst varchar(12) not null,
    knownForTitle varchar(12) not null,
    primary key (nconst, knownForTitle),
    foreign key (nconst) references nameBasics(nconst),
    foreign key (knownForTitle) references titleBasics(tconst)
);

INSERT INTO nameKnownForTitles (nconst, knownForTitle)
SELECT nconst, TRIM(knownForTitle) AS knownForTitle
FROM (
    SELECT nconst, unnest(string_to_array(knownForTitles, ',')) AS knownForTitle
    FROM nameBasics
    WHERE knownForTitles IS NOT NULL
) AS split_titles, titleBasics b
WHERE knownForTitle <> '' and b.tconst = knownForTitle;
/* ================================================================ */

/* === Persistent Tables === */
select * from nameBasics;
select * from titleBasics;
select * from titlePrincipals;

select * from genres;
select * from titleGenres;
select * from professions;
select * from nameProfessions;
select * from nameKnownForTitles;
select * from tempTitleBasics;