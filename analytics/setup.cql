CREATE KEYSPACE "Oberweis" WITH replication = 
    {'class': 'SimpleStrategy', 'replication_factor': 1} ;

USE "Oberweis"; 

CREATE TABLE "daily_purchases" (
    time timestamp,
    person text,
    item text,
    amount int,
    primary key (time, person)
);

CREATE TABLE "person" (
    id text,
    name text,
    age int,
    primary key (id)
);

INSERT INTO person (id, name, age)
    VALUES('ylaurent', 'Yves Laurent', 23);
INSERT INTO person (id, name, age)
    VALUES('cchanel', 'Coco Chanel', 130);
INSERT INTO person (id, name, age)
    VALUES('tford', 'Tom Ford', 57);
INSERT INTO person (id, name, age)
    VALUES('pcardin', 'Pierre Cardin', 72);




INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-01 01:00', 'ylaurent', 'mille feuille', 5);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-01 00:00', 'ylaurent', 'croissant', 1);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-03 12:00', 'ylaurent', 'mille feuille', 3);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-03 15:00', 'ylaurent', 'eclair mocca', 2);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-03 04:00', 'ylaurent', 'jalousie', 1);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-05 07:00', 'ylaurent', 'coup de coeur', 15);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-05 08:00', 'ylaurent', 'mille feuille', 2);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-05 03:00', 'ylaurent', 'macaron', 13);
 
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-01 01:00', 'cchanel', 'croissant', 10);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-01 00:00', 'cchanel', 'mille fuille', 12);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-03 12:00', 'cchanel', 'croissant', 2);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-03 15:00', 'cchanel', 'jalousie', 2);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-03 04:00', 'cchanel', 'jalousie', 8);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-05 07:00', 'cchanel', 'eclair mocca', 7);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-05 08:00', 'cchanel', 'macaron', 20);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-05 03:00', 'cchanel', 'coup de coeur', 3);
 
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-01 01:00', 'pcardin', 'croissant', 11);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-01 00:00', 'pcardin', 'croissant', 23);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-03 12:00', 'pcardin', 'jalousie', 12);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-03 15:00', 'pcardin', 'jalousie', 5);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-03 04:00', 'pcardin', 'croissant', 6);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-05 07:00', 'pcardin', 'mille feuille', 17);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-05 08:00', 'pcardin', 'mille feuille', 2);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-05 03:00', 'pcardin', 'mille feuille', 4);
 
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-02 08:00', 'pcardin', 'eclair mocca', 11);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-02 04:00', 'pcardin', 'rivoli', 23);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-04 02:00', 'pcardin', 'eclair mocca', 12);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-04 15:00', 'pcardin', 'jalousie', 5);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-04 04:00', 'pcardin', 'coup de coeur', 6);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-05 02:00', 'pcardin', 'pain au chocolat', 17);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-05 18:00', 'pcardin', 'croissant', 2);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-05 21:00', 'pcardin', 'mille feuille', 14);
 
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-02 09:00', 'tford', 'rivoli', 1);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-02 14:00', 'tford', 'rivoli', 3);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-04 10:00', 'tford', 'macaron', 2);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-04 05:00', 'tford', 'rivoli', 5);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-04 19:00', 'tford', 'pain au chocolat', 16);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-05 21:00', 'tford', 'croissant', 13);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-05 08:00', 'tford', 'rivoli', 8);
INSERT INTO daily_purchases (time, person, item, amount)
    VALUES('2013-01-05 16:00', 'tford', 'rivoli', 4);
