CREATE DATABASE TI_DT_LPiatek_Kosmos
GO
USE TI_DT_LPiatek_Kosmos
GO

--Poni�sze wykomentowane linijki kodu pozwalaj� na usuni�cie ogranicze� i wykasowanie wszystkich danych w tabelach. 
--Tabele w poleceniach "drop table" celowo zosta�y losowo rozmieszczone by udowodni�, �e nie ma znaczenia w jakiej 
--kolejno�ci usuwamy tabele gdy nie ma ��cz�cych ich zale�no�ci.

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

insert into Sposob_Zaplaty values ('Got�wka','Mennica','Andrzej Khan');
insert into Sposob_Zaplaty values ('Przelew','Wielkopolska Filia Bankowa','Mateusz �osicki');
insert into Sposob_Zaplaty values ('Bitpieni�dz','Internetowy Bank Centralny','Kamil Pi�eczka');
insert into Sposob_Zaplaty values ('Wyrazy uznania','U�miechnij si�','Zofia Szczebrzyszczykiewicz');
insert into Sposob_Zaplaty values ('Dobra robota','Centralny Bank Motywacyjny','Konrad Szopowski');

insert into Wyplaty values (1, 5200.51,'Za wykonanie zadania');
insert into Wyplaty values (2, 1000.00,'Za przedterminowe zadanie');
insert into Wyplaty values (3, 10.59,'Za us�ugi informatyczne');
insert into Wyplaty values (4, 0.10,'Premia motywacyjna');
insert into Wyplaty values (5, 50.25,'Dobra robota');
insert into Wyplaty values (5, 0.21,'Mistrzowska robota');
insert into Wyplaty values (4, 4857.45,'Za naprawienie kokpitu');
insert into Wyplaty values (3, 2458.28,'Za wykonanie zadania online');
insert into Wyplaty values (2, 1000021.51,'Za naprawienie statku');
insert into Wyplaty values (1, 975.25,'Za doprowadzenie do wystartowania promu');

insert into Stanowisko values ('Rycerz Jedi', 'Stra�nik pokoju w galaktyce');
insert into Stanowisko values ('Mechanik', 'Naprawia rzeczy');
insert into Stanowisko values ('Astronauta', '"To ma�y krok dla cz�owieka, ale wielki krok dla ludzko�ci"');
insert into Stanowisko values ('In�ynier kasmonautyki', 'Buduje promy, rakiety i sprawia by wzbi�y si� w powietrze');
insert into Stanowisko values ('Astronom', 'Wyszukuje nowych planet');
insert into Stanowisko values ('Fizyk Kwantowy', 'Osoba od wszelkiego rodzaju kalkulacji');
insert into Stanowisko values ('In�ynier', 'Zna si� na rzeczy');
insert into Stanowisko values ('Lekarz', 'Pomaga astronautom, kt�rzy byli zmuszeni awaryjnie l�dowa�');
insert into Stanowisko values ('Serwisant', 'Naprawia to co zosta�o z�amane');
insert into Stanowisko values ('Mistrz', 'On wie co si� zepsuje zanim to co� si� zepsuje');

insert into Rozkazy values ('Program Apollo','L�dowanie cz�owieka na Ksi�ycu');
insert into Rozkazy values ('Program Mercury','Pierwszy program za�ogowy w wykonaniu NASA');
insert into Rozkazy values ('Program Gemini','Przetestowanie sposob�w dokowania i aktywno�ci pozapojazdowej');
insert into Rozkazy values ('Skylab','Pierwsza stacja kosmiczna NASA');
insert into Rozkazy values ('Sojuz-Apollo','Po��czenie na orbicie z radzieckim statkiem Sojuz');
insert into Rozkazy values ('Space Transportation System','Wielorazowe wykorzystanie statk�w kosmicznych');
insert into Rozkazy values ('Rozkaz 66','Masowa eliminacja cz�onk�w zakonu JEDI');
insert into Rozkazy values ('Program Shuttle-Mir','Misje wahad�owc�w na stacj� Mir');
insert into Rozkazy values ('Mi�dzynarodowa Stacja Kosmiczna','Wsp�praca wielu pa�stw w celu zorbitowania stacji kosmicznej');
insert into Rozkazy values ('Program Constellation','Ponowne wyniesienie cz�owieka na Ksi�yc');

insert into Siedziba values ('NASA', 'Kosmiczna', 12, 'Ziemia', '363146731');
insert into Siedziba values ('Agencja Bezpiecze�stwa Zewn�trznych Rubie�y', 'Grawitacyjna',18 ,'Mustafar', '542864324');
insert into Siedziba values ('Mi�dzynarodowa Stacja Kosmiczna', 'Pr�niowa',10 , 'Kosmos', '888888888');
insert into Siedziba values ('Akademia Jedi', 'Obi-Wana Kenobiego', 1, 'Curuscant', '424865324');
insert into Siedziba values ('Ksi�yc', 'S�oneczna',87 ,'Ksi�yc', '222222222');

insert into Planety values ('Uk�ad S�oneczny','Merkury','Ksi�yc','Andrzej Merkury',1,'Planeta najbli�ej s�o�ca. Jedna z najcieplejszych i najzimniejszych planet wewn�trznych z powodu ma�ej pr�dko�ci obrotowej')
insert into Planety values ('Uk�ad S�oneczny','Saturn','Ksi�yc','Jurij Gagarin',1,'Przepi�kne pier�cienie spowodowane du�� ilo�ci� ksi�yc�w i od�amk�w skalnych')
insert into Planety values ('Uk�ad S�oneczny','Mars','Ksi�yc','Abraham Lincolm',1,'Brat bli�niak Ziemii')
insert into Planety values ('Zewn�trzne Rubierze','Mustafar','Agencja Bezpiecze�stwa Zewn�trznych Rubie�y','Lord Vader',5,'Bardzo wysoka temperatura na powierzchni, porzucona plac�wka wydobywcza')
insert into Planety values ('Zawn�trzne Rubierze','Calipso X','Agencja Bezpiecze�stwa Zewn�trznych Rubie�y','Andrzej Sa�ata',4,'Zamieszkana przez niebezpieczne w�e')
insert into Planety values ('Zewn�trzne Rubierze','Nabuhodonozorozia','Agencja Bezpiecze�stwa Zewn�trznych Rubie�y','Miranda Blake',2,'Niezbadana dotychczas')
insert into Planety values ('J�dro Galaktyki','Coruscant','Akademia Jedi','Mistrz Yoda',3,'Serce sektoru. Du�y o�rodek handlowy')
insert into Planety values ('J�dro Galaktyki','Nabu','Akademia Jedi','Padme Amidala',1,'Spokojna planeta. Przyjacielska fauna i flora')
insert into Planety values ('J�dro Galaktyki','Gallifrey','Akademia Jedi','Doktor',2,'Gatunek humanoid�w potrafi�cych si� regenerowa�')
insert into Planety values ('Droga Mleczna','Ziemia','Mi�dzynarodowa Stacja Kosmiczna','Prezydent �wiata',5,'Coraz mniej Zielona Planeta')
insert into Planety values ('Droga Mleczna','Wenus','Mi�dzynarodowa Stacja Kosmiczna','Afrodyta',4,'Niezdolna do zamieszkania przez zbyt wysokie st�enie siarki')
insert into Planety values ('Droga Mleczna','Pluton','Mi�dzynarodowa Stacja Kosmiczna','Pluto',2,'Zimna planeta kar�owata')
insert into Planety values ('Galaktyka Andromedy','Andromeda I','NASA','Jan Jesio�ski',2,'Odleg�a planeta z du�� ilo�ci� surowc�w naturalnych')
insert into Planety values ('Galaktyka Andromedy','Andromeda IX','NASA','Spock',4,'Bogata w diament jednak niebezpieczna przez niekontrolowane burze')
insert into Planety values ('Galaktyka Andromedy','Andromeda III','NASA','Kapitan Kirk',5,'Niezdolna do eksploracji')

insert into Wyposazenie values ('Kombinezon astronauty','Agencja Lot�w Kosmicznych',2,50000.00,'Kombinezon nadaje si� do u�ytku w warunkach 0G');
insert into Wyposazenie values ('Miecz �wietlny','Rada Jedi',10,1500000.00,'Elegancka bro� na bardziej cywilizowane czasy');
insert into Wyposazenie values ('Droid protokolarny','Agencja Ludzie-Roboty',89,10.00,'To nie jest droid, kt�rego szukasz');
insert into Wyposazenie values ('Prom kosmiczny','Agencja Lot�w Kosmicznych',10,85456215.05,'Podstawowy model kosmiczny do lotu w kosmos');
insert into Wyposazenie values ('Zbiorniki z paliwem','Petroleum C.O',8,4.50,'Paliwo do wahad�owc�w');

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

insert into Dzialy values ('Dzia� technologiczny',2,'Albert','Einstein',null);
insert into Dzialy values ('Dzia� rozwoju',3,'Micha�','Andrzejewski',null);
insert into Dzialy values ('Dzia� eksploracji kosmosu',10,'Przemys�aw','Gizon',null);
insert into Dzialy values ('Dzia� do spraw kontaktu z UFO',2,'Marcelina','Ratajczyk�wna',null);
insert into Dzialy values ('Dzia� adaptacyjny',1,'Bart�omiej','Szyma�ski�',null);

insert into Pracownicy values ('Andrzej','Czepliwy',4,3,2,1,'Jako jedyny prze�y� pobyt w pr�ni bez skafandra');
insert into Pracownicy values ('Kamil','Pulikowski',1,2,5,2,'Potrafi obchodzi� si� z automatyk� pok�adow�');
insert into Pracownicy values ('Marcin','To�',2,3,3,3,'Kucharz w strefie 0G');
insert into Pracownicy values ('Anakin','Skywalker',1,2,5,2,'Podatny na ciemn� stron�');
insert into Pracownicy values ('Piotr','Ga�ek',2,2,2,4,'S�abo znosi podr�e w nadprzestrzeni');
insert into Pracownicy values ('Dominik','Kucharski',1,2,3,5,'Pok�adowy kucharz');
insert into Pracownicy values ('Anna','Zi�tara',4,3,2,6,'Astronauta, kt�rego nikt nigdy nie widzia�');
insert into Pracownicy values ('Justyna','Justy�ska',1,2,4,7,'Wykazuje du�� znajomo�� szlak�w nadprzestrzennych');
insert into Pracownicy values ('Janusz','Energetyczny',2,2,3,8,'Specjalista do spraw zasilania');
insert into Pracownicy values ('Justyna','Energetyczna',2,2,5,9,'Specjalista do spraw zwi�zanych z obcymi cywilizacjami');
insert into Pracownicy values ('Agnieszka','Kapisz',1,2,4,10,'Specjalista od silnik�w');