CREATE DATABASE TI_DT_LPiatek_Kosmos
GO
USE TI_DT_LPiatek_Kosmos
GO

--Poni¿sze wykomentowane linijki kodu pozwalaj¹ na usuniêcie ograniczeñ i wykasowanie wszystkich danych w tabelach. 
--Tabele w poleceniach "drop table" celowo zosta³y losowo rozmieszczone by udowodniæ, ¿e nie ma znaczenia w jakiej 
--kolejnoœci usuwamy tabele gdy nie ma ³¹cz¹cych ich zale¿noœci.

--alter table Planety drop constraint FK_PLA_Siedziba_Nazwa
--alter table Planety drop constraint CK_PLA_Stopien_Zagrozenia
--alter table Misje drop constraint FK_MIS_PLA_ID
--alter table Misje drop constraint FK_MIS_WYP_ID
--alter table Misje drop constraint FK_MIS_ROZ_ID
--alter table Dzialy drop constraint FK_DZ_PLA_ID
--alter table Wyplaty drop constraint FK_WY_SPO_ID
--alter table Pracownicy drop constraint FK_PRAC_STA_ID
--alter table Pracownicy drop constraint FK_PRAC_DZ_ID
--alter table Pracownicy drop constraint FK_PRAC_WY_ID
--alter table Pracownicy drop constraint FK_PRAC_MIS_ID
--drop table Pracownicy
--drop table Stanowisko
--drop table Wyposazenie
--drop table Wyplaty
--drop table Planety
--drop table Siedziba
--drop table Misje
--drop table Rozkazy
--drop table Sposob_Zaplaty
--drop table Dzialy


CREATE TABLE Wyposazenie
	(WYP_ID int identity(1,1) constraint PK_Wyposazenie primary key,
	WYP_NAZWA varchar(30) not null,
	WYP_Wlasciciel varchar(30) not null,
	WYP_okres_gwarancji int,
	WYP_cena numeric(20,2) not null,
	WYP_opis varchar(600) );

CREATE TABLE Rozkazy
	( ROZ_ID int identity(1,1) constraint PK_Rozkazy primary key,
	ROZ_Nazwa varchar(60) not null,
	ROZ_OPIS varchar(600) not null );

CREATE TABLE Siedziba
	(Siedziba_Nazwa varchar(60) constraint PK_Sziedziba_Nazwa primary key,
	Siedziba_Ulica varchar(30) not null,
	Siedziba_Numer int not null,
	Siedziba_Planeta varchar(60) not null,
	Siedziba_Telefon varchar(9) );

CREATE TABLE Planety
	( PLA_ID int identity(1,1) constraint PK_Planety primary key,
	PLA_Sektor varchar(30) not null,
	PLA_Nazwa varchar(30) not null,
	PLA_Siedziba_Nazwa varchar(60) constraint FK_PLA_Siedziba_Nazwa references Siedziba(Siedziba_Nazwa) not null,
	PLA_Agent varchar(30) not null,
	PLA_Stopien_Zagrozenia int constraint CK_PLA_Stopien_Zagrozenia check (PLA_Stopien_Zagrozenia between 1 and 5),
	PLA_Opis varchar(600) );

CREATE TABLE Misje
	( MIS_ID int identity(1,1) constraint PK_Misje primary key,
	MIS_PLA_ID int constraint FK_MIS_PLA_ID references Planety(PLA_ID),
	MIS_WYP_ID int constraint FK_MIS_WYP_ID references Wyposazenie(WYP_ID), 
	MIS_ROZ_ID int constraint FK_MIS_ROZ_ID references Rozkazy(ROZ_ID),
	MIS_Czas_Poczatek date default getdate() not null,
	MIS_Czas_Koniec date default (getdate()+120) not null );

CREATE TABLE Sposob_Zaplaty
	(SPO_ID int identity(1,1) constraint PK_Sposob_Zaplaty primary key,
	SPO_Nazwa varchar(40) not null,
	SPO_Bank varchar(40) not null,
	SPO_Osoba_Odpowiedzialna varchar(60) not null );

CREATE TABLE Dzialy
	(DZ_ID int identity(1,1) constraint PK_DZ_ID primary key,
	DZ_Nazwa varchar(30) not null,
	DZ_PLA_ID int constraint FK_DZ_PLA_ID references Planety(PLA_ID),
	DZ_Kierownik_Imie varchar(30) not null,
	DZ_Kierownik_Nazwisko varchar(30) not null,
	DZ_Obrazek image );

CREATE TABLE Wyplaty
	(WY_ID int identity(1,1) constraint PK_Wyplaty primary key,
	WY_SPO_ID int constraint FK_WY_SPO_ID references Sposob_Zaplaty(SPO_ID),
	WY_KWOTA money not null,
	WY_Typ varchar(100) not null );

CREATE TABLE Stanowisko
	(STA_ID int identity(1,1) constraint PK_STA_ID primary key,
	STA_Nazwa varchar(30) not null,
	STA_Opis varchar(500) );

CREATE TABLE Pracownicy
	(PRAC_ID int identity(1,1) constraint PK_PRAC_ID primary key,
	PRAC_Imie varchar(30),
	PRAC_Nazwisko varchar(30),
	PRAC_STA_ID int constraint FK_PRAC_STA_ID references Stanowisko(STA_ID) not null,
	PRAC_DZ_ID int constraint FK_PRAC_DZ_ID references Dzialy(DZ_ID) not null,
	PRAC_WY_ID int constraint FK_PRAC_WY_ID references Wyplaty(WY_ID) not null,
	PRAC_MIS_ID int constraint FK_PRAC_MIS_ID references Misje(MIS_ID),
	PRAC_Opinia varchar(500) );

insert into Sposob_Zaplaty values ('Gotówka','Mennica','Andrzej Khan');
insert into Sposob_Zaplaty values ('Przelew','Wielkopolska Filia Bankowa','Mateusz £osicki');
insert into Sposob_Zaplaty values ('Bitpieni¹dz','Internetowy Bank Centralny','Kamil Pi³eczka');
insert into Sposob_Zaplaty values ('Wyrazy uznania','Uœmiechnij siê','Zofia Szczebrzyszczykiewicz');
insert into Sposob_Zaplaty values ('Dobra robota','Centralny Bank Motywacyjny','Konrad Szopowski');

insert into Wyplaty values (1, 5200.51,'Za wykonanie zadania');
insert into Wyplaty values (2, 1000.00,'Za przedterminowe zadanie');
insert into Wyplaty values (3, 10.59,'Za us³ugi informatyczne');
insert into Wyplaty values (4, 0.10,'Premia motywacyjna');
insert into Wyplaty values (5, 50.25,'Dobra robota');
insert into Wyplaty values (5, 0.21,'Mistrzowska robota');
insert into Wyplaty values (4, 4857.45,'Za naprawienie kokpitu');
insert into Wyplaty values (3, 2458.28,'Za wykonanie zadania online');
insert into Wyplaty values (2, 1000021.51,'Za naprawienie statku');
insert into Wyplaty values (1, 975.25,'Za doprowadzenie do wystartowania promu');

insert into Stanowisko values ('Rycerz Jedi', 'Stra¿nik pokoju w galaktyce');
insert into Stanowisko values ('Mechanik', 'Naprawia rzeczy');
insert into Stanowisko values ('Astronauta', '"To ma³y krok dla cz³owieka, ale wielki krok dla ludzkoœci"');
insert into Stanowisko values ('In¿ynier kasmonautyki', 'Buduje promy, rakiety i sprawia by wzbi³y siê w powietrze');
insert into Stanowisko values ('Astronom', 'Wyszukuje nowych planet');
insert into Stanowisko values ('Fizyk Kwantowy', 'Osoba od wszelkiego rodzaju kalkulacji');
insert into Stanowisko values ('In¿ynier', 'Zna siê na rzeczy');
insert into Stanowisko values ('Lekarz', 'Pomaga astronautom, którzy byli zmuszeni awaryjnie l¹dowaæ');
insert into Stanowisko values ('Serwisant', 'Naprawia to co zosta³o z³amane');
insert into Stanowisko values ('Mistrz', 'On wie co siê zepsuje zanim to coœ siê zepsuje');

insert into Rozkazy values ('Program Apollo','L¹dowanie cz³owieka na Ksiê¿ycu');
insert into Rozkazy values ('Program Mercury','Pierwszy program za³ogowy w wykonaniu NASA');
insert into Rozkazy values ('Program Gemini','Przetestowanie sposobów dokowania i aktywnoœci pozapojazdowej');
insert into Rozkazy values ('Skylab','Pierwsza stacja kosmiczna NASA');
insert into Rozkazy values ('Sojuz-Apollo','Po³¹czenie na orbicie z radzieckim statkiem Sojuz');
insert into Rozkazy values ('Space Transportation System','Wielorazowe wykorzystanie statków kosmicznych');
insert into Rozkazy values ('Rozkaz 66','Masowa eliminacja cz³onków zakonu JEDI');
insert into Rozkazy values ('Program Shuttle-Mir','Misje wahad³owców na stacjê Mir');
insert into Rozkazy values ('Miêdzynarodowa Stacja Kosmiczna','Wspó³praca wielu pañstw w celu zorbitowania stacji kosmicznej');
insert into Rozkazy values ('Program Constellation','Ponowne wyniesienie cz³owieka na Ksiê¿yc');

insert into Siedziba values ('NASA', 'Kosmiczna', 12, 'Ziemia', '363146731');
insert into Siedziba values ('Agencja Bezpieczeñstwa Zewnêtrznych Rubie¿y', 'Grawitacyjna',18 ,'Mustafar', '542864324');
insert into Siedziba values ('Miêdzynarodowa Stacja Kosmiczna', 'Pró¿niowa',10 , 'Kosmos', '888888888');
insert into Siedziba values ('Akademia Jedi', 'Obi-Wana Kenobiego', 1, 'Curuscant', '424865324');
insert into Siedziba values ('Ksiê¿yc', 'S³oneczna',87 ,'Ksiê¿yc', '222222222');

insert into Planety values ('Uk³ad S³oneczny','Merkury','Ksiê¿yc','Andrzej Merkury',1,'Planeta najbli¿ej s³oñca. Jedna z najcieplejszych i najzimniejszych planet wewnêtrznych z powodu ma³ej prêdkoœci obrotowej')
insert into Planety values ('Uk³ad S³oneczny','Saturn','Ksiê¿yc','Jurij Gagarin',1,'Przepiêkne pierœcienie spowodowane du¿¹ iloœci¹ ksiê¿yców i od³amków skalnych')
insert into Planety values ('Uk³ad S³oneczny','Mars','Ksiê¿yc','Abraham Lincolm',1,'Brat bliŸniak Ziemii')
insert into Planety values ('Zewnêtrzne Rubierze','Mustafar','Agencja Bezpieczeñstwa Zewnêtrznych Rubie¿y','Lord Vader',5,'Bardzo wysoka temperatura na powierzchni, porzucona placówka wydobywcza')
insert into Planety values ('Zawnêtrzne Rubierze','Calipso X','Agencja Bezpieczeñstwa Zewnêtrznych Rubie¿y','Andrzej Sa³ata',4,'Zamieszkana przez niebezpieczne wê¿e')
insert into Planety values ('Zewnêtrzne Rubierze','Nabuhodonozorozia','Agencja Bezpieczeñstwa Zewnêtrznych Rubie¿y','Miranda Blake',2,'Niezbadana dotychczas')
insert into Planety values ('J¹dro Galaktyki','Coruscant','Akademia Jedi','Mistrz Yoda',3,'Serce sektoru. Du¿y oœrodek handlowy')
insert into Planety values ('J¹dro Galaktyki','Nabu','Akademia Jedi','Padme Amidala',1,'Spokojna planeta. Przyjacielska fauna i flora')
insert into Planety values ('J¹dro Galaktyki','Gallifrey','Akademia Jedi','Doktor',2,'Gatunek humanoidów potrafi¹cych siê regenerowaæ')
insert into Planety values ('Droga Mleczna','Ziemia','Miêdzynarodowa Stacja Kosmiczna','Prezydent Œwiata',5,'Coraz mniej Zielona Planeta')
insert into Planety values ('Droga Mleczna','Wenus','Miêdzynarodowa Stacja Kosmiczna','Afrodyta',4,'Niezdolna do zamieszkania przez zbyt wysokie stê¿enie siarki')
insert into Planety values ('Droga Mleczna','Pluton','Miêdzynarodowa Stacja Kosmiczna','Pluto',2,'Zimna planeta kar³owata')
insert into Planety values ('Galaktyka Andromedy','Andromeda I','NASA','Jan Jesioñski',2,'Odleg³a planeta z du¿¹ iloœci¹ surowców naturalnych')
insert into Planety values ('Galaktyka Andromedy','Andromeda IX','NASA','Spock',4,'Bogata w diament jednak niebezpieczna przez niekontrolowane burze')
insert into Planety values ('Galaktyka Andromedy','Andromeda III','NASA','Kapitan Kirk',5,'Niezdolna do eksploracji')

insert into Wyposazenie values ('Kombinezon astronauty','Agencja Lotów Kosmicznych',2,50000.00,'Kombinezon nadaje siê do u¿ytku w warunkach 0G');
insert into Wyposazenie values ('Miecz Œwietlny','Rada Jedi',10,1500000.00,'Elegancka broñ na bardziej cywilizowane czasy');
insert into Wyposazenie values ('Droid protokolarny','Agencja Ludzie-Roboty',89,10.00,'To nie jest droid, którego szukasz');
insert into Wyposazenie values ('Prom kosmiczny','Agencja Lotów Kosmicznych',10,85456215.05,'Podstawowy model kosmiczny do lotu w kosmos');
insert into Wyposazenie values ('Zbiorniki z paliwem','Petroleum C.O',8,4.50,'Paliwo do wahad³owców');

insert into Misje values (2,2,1,default, default);
insert into Misje values (7,2,7,default, default);
insert into Misje values (10,4,5,default, default);
insert into Misje values (3,3,3,default, default);
insert into Misje values (12,5,9,default, default);
insert into Misje values (13,1,8,default, default);
insert into Misje values (15,3,7,default, default);
insert into Misje values (8,5,6,default, default);
insert into Misje values (9,1,5,default, default);
insert into Misje values (7,2,4,default, default);

insert into Dzialy values ('Dzia³ technologiczny',2,'Albert','Einstein',null);
insert into Dzialy values ('Dzia³ rozwoju',3,'Micha³','Andrzejewski',null);
insert into Dzialy values ('Dzia³ eksploracji kosmosu',10,'Przemys³aw','Gizon',null);
insert into Dzialy values ('Dzia³ do spraw kontaktu z UFO',2,'Marcelina','Ratajczykówna',null);
insert into Dzialy values ('Dzia³ adaptacyjny',1,'Bart³omiej','Szymañskiœ',null);

insert into Pracownicy values ('Andrzej','Czepliwy',4,3,2,1,'Jako jedyny prze¿y³ pobyt w pró¿ni bez skafandra');
insert into Pracownicy values ('Kamil','Pulikowski',1,2,5,2,'Potrafi obchodziæ siê z automatyk¹ pok³adow¹');
insert into Pracownicy values ('Marcin','Toœ',2,3,3,3,'Kucharz w strefie 0G');
insert into Pracownicy values ('Anakin','Skywalker',1,2,5,2,'Podatny na ciemn¹ stronê');
insert into Pracownicy values ('Piotr','Ga³ek',2,2,2,4,'S³abo znosi podró¿e w nadprzestrzeni');
insert into Pracownicy values ('Dominik','Kucharski',1,2,3,5,'Pok³adowy kucharz');
insert into Pracownicy values ('Anna','Ziêtara',4,3,2,6,'Astronauta, którego nikt nigdy nie widzia³');
insert into Pracownicy values ('Justyna','Justyñska',1,2,4,7,'Wykazuje du¿¹ znajomoœæ szlaków nadprzestrzennych');
insert into Pracownicy values ('Janusz','Energetyczny',2,2,3,8,'Specjalista do spraw zasilania');
insert into Pracownicy values ('Justyna','Energetyczna',2,2,5,9,'Specjalista do spraw zwi¹zanych z obcymi cywilizacjami');
insert into Pracownicy values ('Agnieszka','Kapisz',1,2,4,10,'Specjalista od silników');