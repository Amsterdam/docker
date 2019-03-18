Docker
======

Images specifiek voor Datapunt development. 
Deze images zijn direct gebaseerd op de officiële images, maar hebben een aantal hulp-scriptjes om alles wat makkelijker te maken. 


Gebruik
=======

Voor import processen op de datapunt infra:
------------------------------------------

Geef in de .jenkins_import/docker-compose.yml de volgende environment parameter mee:

    extra_hosts:
      ## ADMIN SERVER HOSTNAME ##: ## ADMIN SERVER IP ##

Dit zorgt er voor dat de importer binnen de eigen infra de download van de laatste backup kan doen.
Doe je dit niet, dan weet de importer binnen docker niet waar de admin.datapunt.amsterdam.nl server staat.

Voor lokale ontwikkelaars:
-------------------------

Binnen de projecten (of met deze Docker) kan je lokaal een actuele Acceptatie database of Elastic index inladen.
Zorg dat als je lokaal de docker-compose gebruikt dat je private key deze locatie heeft: 

    ~/.ssh/datapunt.key
    
Zo kan je dan de database of elastic updaten:    

```
docker-compose run postgres update-db.sh <database> <username>
```

of

```
docker-compose run elasticsearch5|elasticsearch6 update-el.sh <indexnaam> <username>
```

**LET OP:** mocht je elastic dockers hergebruiken dan moet je nu apart je indices opruimen:

```
docker-compose run elasticsearch5|elasticsearch6 clean-el.sh
docker-compose run elasticsearch5|elasticsearch6 update-el.sh <indexnaam> <username>
```

*LET OOK OP: de mogelijkheid meerdere index-namen mee te geven is komen te vervallen.*

---

Bijvoorbeeld:

```
docker-compose run postgres update-db.sh basiskaart szaat
```

- afvalophaalgebieden
- bag
- basiskaart
- bbga
- catalogus
- handelsregister
- ibprojecten
- metadata
- milieuthemas
- monumenten
- nap
- overlastgebieden
- panorama
- parkeervakken
- predictiveparking
- reistijdenauto
- sportparken
- tellus
- zorg


```
docker-compose run elasticsearch5 update-el.sh bag szaat
```

Opties:
- bag
- ds_bag_index
- ds_hr_index
- handelsregister
- meetbouten
- scans

