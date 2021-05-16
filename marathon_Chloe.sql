-- script réponses
-- Andy (Chloé) Guyard

use marathon;


    -- DML - SIMPLE

-- 1
select CO_NOM, CO_SEXE
from coureur;

-- 2
select *
from club
where CL_VILLE = 'Bordeaux'
order by CL_NOM;

-- 3
select CO_NOM, CO_PRENOM, IN_TEMP_ANNONCE, IN_TEMP_EFFECTUE
from coureur, inscription
where CO_ID = IN_COUREUR_FK
	and CO_NOM = 'Villani';

-- 4
select CO_NOM, CO_PRENOM, CO_NAISSANCE
from coureur
where CO_SEXE = 1
order by CO_NAISSANCE desc
limit 4;

-- 5
select CO_NOM, CO_PRENOM
from coureur
where CO_NOM regexp '[o]';

-- 6
select *
from coureur
where CO_SEXE = 2
    and CO_NAISSANCE between '1922-06-15' and '1950-10-18'
order by CO_NAISSANCE;

-- 7
select CL_VILLE
from club
group by CL_VILLE
order by CL_VILLE;

-- 8
select EP_HEURE as 'heure de départ'
from epreuve
where EP_DATE regexp '^(2016-04)'
order by EP_HEURE;

-- 9
select CA_ID, CA_LIBELLE
from categorie_age
where 21 between CA_AGEDEB and CA_AGEFIN;

-- 10
select CO_NOM, CO_NAISSANCE
from coureur
where CO_PRENOM regexp '^(S|B)'
	and CO_NOM regexp '[w]';


    -- DML - AVANCE

-- 1
select date_format(EP_DATE, '%W %D %M') as 'jour et mois'
from epreuve
where EP_DATE regexp '^(2016)';

-- 2
select concat(CO_NOM, ' ', CO_PRENOM) as 'nom et prénom', IN_AGE
from coureur, inscription
where CO_ID = IN_COUREUR_FK
	  and CO_SEXE = 1
group by CO_ID;

-- 3
select TY_LIBELLE, date_format(EP_DATE, '%W %D %M %Y') as "date de l'épreuve", EP_HEURE
from epreuve, type_epreuve
where EP_TYPE_FK = TY_ID
	and EP_DATE regexp '^(2016)'
    and EP_HEURE < '14:00:00';

-- 4
select CO_NOM, CO_PRENOM, CO_NAISSANCE, replace(replace (CO_SEXE, '2', 'Femme'), '1', 'Homme') as 'sexe'
from coureur
where CO_NAISSANCE between '1930-01-01' and '1960-12-31'
order by CO_NAISSANCE;

    -- manière alternative
-- select CO_NOM, CO_PRENOM, CO_NAISSANCE,
--     case CO_SEXE 
--         when '2' then 'Femme' 
--         else 'Homme' 
--     end as sexe
-- from coureur
-- where CO_NAISSANCE between '1930-01-01' and '1960-12-31'
-- order by CO_NAISSANCE;

-- 5
select CL_NOM
from club
where CL_NOM not like 'Les%';

-- 6
select concat(CO_NOM, ' ', CO_PRENOM) as 'nom et prénom', CO_NAISSANCE
from coureur
where CO_NAISSANCE like '%-01-%' or CO_NAISSANCE like '%-04-%';

-- 7 (énoncé similaire à celui de la question 6)
select concat(CO_NOM, ' ', CO_PRENOM) as 'nom et prénom', CO_NAISSANCE
from coureur
where CO_NAISSANCE like '%-01-%' or CO_NAISSANCE like '%-04-%';

-- 8 
select *
from categorie_age
where CA_LIBELLE like 'M%' or CA_LIBELLE like 'B%';

-- 9
select left(CL_NOM, 15) as 'club name (15 char max)'
from club
where CL_VILLE = 'Bordeaux';

-- 10
select CO_NOM, replace(CO_PRENOM, 'é', 'e') as 'prénom'
from coureur;


    -- DML - JOINTURES

-- 1
select MA_NOM, CH_NOM, CH_DATEDEB
from manifestation, championnat
where CH_ID = MA_CHAMP_FK;

-- 2
select CO_NOM, CO_PRENOM, CL_NOM, AD_ANNEE
from coureur, club, adhesion
where CO_ID = AD_COUREUR_FK
	and AD_CLUB_FK = CL_ID
    and CO_SEXE = 2
    and AD_ANNEE = 2015;

-- 3
select CO_NOM, CO_PRENOM, IN_TEMP_EFFECTUE
from coureur, inscription, epreuve, manifestation, type_epreuve
where CO_ID = IN_COUREUR_FK
	and EP_ID = IN_EPREUVE_FK
    and TY_ID = EP_TYPE_FK
    and MA_ID = EP_MANIF_FK
	and MA_NOM = 'Marathon de Bordeaux'
    and TY_LIBELLE = 'Semi marathon'
    and EP_DATE regexp '^(2016)'
order by CO_NOM;

-- 4
select CO_NOM, CO_PRENOM
from coureur, club, adhesion, inscription, epreuve, manifestation
where CO_ID =  AD_COUREUR_FK
    and AD_CLUB_FK = CL_ID
    and CO_ID = IN_COUREUR_FK
    and IN_EPREUVE_FK = EP_ID
    and EP_MANIF_FK = MA_ID
	and CL_NOM = 'La foulée arcachonnaise'
    and MA_NOM = 'Marathon de Bordeaux'
group by CO_ID;

-- 5
select CO_NOM, CO_PRENOM
from coureur
	left join adhesion
    on CO_ID = AD_COUREUR_FK
where AD_COUREUR_FK is null
group by CO_ID;

-- 6 (une seule correspondance dans la BDD)
select CO_NOM, CO_PRENOM, IN_TEMP_EFFECTUE
from coureur, inscription, epreuve, manifestation
where CO_ID = IN_COUREUR_FK
	and IN_EPREUVE_FK = EP_ID
    and EP_MANIF_FK = MA_ID
    and MA_NOM = 'Marathon du Médoc'
    and EP_DATE regexp '^(2016)'
order by IN_TEMP_EFFECTUE
limit 2;

-- 7
select CO_NOM, CO_PRENOM
from coureur, inscription, categorie_age
where CO_ID = IN_COUREUR_FK
	and IN_CATEG_AGE_FK = CA_ID
	and CO_SEXE = 2
	and IN_CATEG_AGE_FK in (select CA_ID
		from coureur, categorie_age
        where CA_LIBELLE = 'Masters'
        );

-- 8 
select CO_NOM, CO_PRENOM
from coureur
left join inscription
	on CO_ID = IN_COUREUR_FK
where IN_COUREUR_FK is null;

-- 9
select CO_NOM, CO_PRENOM
from coureur, adhesion, club
where CO_ID = AD_COUREUR_FK
	and AD_CLUB_FK = CL_ID
	and CL_NOM = 'Les scientifiques font du sport'
    and AD_ANNEE = '2016'
order by CO_NOM;

-- 10
select CO_NOM, CO_PRENOM, IN_TEMP_EFFECTUE
from coureur, inscription, epreuve, type_epreuve
where CO_ID = IN_COUREUR_FK
	and IN_EPREUVE_FK = EP_ID
    and EP_TYPE_FK = TY_ID
    and TY_LIBELLE = 'Semi marathon'
	and IN_TEMP_EFFECTUE >= '03:00:00'
group by CO_ID;


    -- DML - AGREGATION 

-- 1 (zéro résultat : il n'y a pas de Marathon de Bordeaux en 2015 dans cette BDD)
select CL_NOM, count(CO_ID) as 'nombre de membres'
from coureur, adhesion, club, inscription, epreuve, manifestation
where CO_ID = AD_COUREUR_FK
	and AD_CLUB_FK = CL_ID
    and CO_ID = IN_COUREUR_FK
    and IN_EPREUVE_FK = EP_ID
    and EP_MANIF_FK = MA_ID
    and MA_NOM = 'Marathon de Bordeaux'
    and EP_DATE regexp '^(2015)'
group by CL_ID;

-- 2 (zéro résultat : il n'y a pas de Marathon de Bordeaux en 2015 dans cette BDD)
select CL_NOM, count(CO_ID) as 'nombre de coureurs'
from coureur, adhesion, club, inscription, epreuve, manifestation
where CO_ID = AD_COUREUR_FK
	and AD_CLUB_FK = CL_ID
    and CO_ID = IN_COUREUR_FK
    and IN_EPREUVE_FK = EP_ID
    and EP_MANIF_FK = MA_ID
    and MA_NOM = 'Marathon de Bordeaux'
    and CL_VILLE = 'Bordeaux'
    and EP_DATE regexp '^(2015)'
group by CL_ID;

-- 3
select distinct EP_ID, avg(IN_TEMP_EFFECTUE) as 'temps moyen'
from inscription, epreuve
where EP_ID = IN_EPREUVE_FK
group by EP_ID;

-- 4 (zéro résultat : il n'y a pas de Marathon de Bordeaux en 2015 dans cette BDD)
select EP_ID, CO_NOM, min(IN_TEMP_EFFECTUE)
from coureur, inscription, epreuve, manifestation
where CO_ID = IN_COUREUR_FK
	and IN_EPREUVE_FK = EP_ID
    and EP_MANIF_FK = MA_ID
    and MA_NOM = 'Marathon de Bordeaux'
 	and EP_DATE regexp '^(2015)'
    and IN_TEMP_EFFECTUE not like '00:00:00'
group by EP_ID;
    -- ID_EP et 'meilleur temps' sont exact, mais pas les noms


    -- DML

-- 1
update coureur
set CO_NAISSANCE = '1948-01-20'
where CO_ID = 1;

-- 2
insert into manifestation (MA_NOM, MA_CHAMP_FK)
values ('Marathon de La Rochelle', 2);

insert into epreuve (EP_DATE, EP_HEURE, EP_TYPE_FK, EP_MANIF_FK, EP_NB)
values ('2016-11-27', '09:00:00', 1, 4, 98),
	    ('2016-11-27', '09:00:00', 2, 4, 98);

-- 3
insert into coureur (CO_NOM, CO_PRENOM, CO_NAISSANCE, CO_SEXE)
values ('Mandelbrot', 'Benoit', '1924-11-24', 1);

-- 4
update inscription
set IN_TEMP_EFFECTUE = dateadd(minute, -1, IN_TEMP_EFFECTUE)
where IN_EPREUVE_FK = 3 and IN_DATE regexp '^(2015)';

-- 5 
delete from inscription
where IN_EPREUVE_FK = 3 or IN_EPREUVE_FK = 4;