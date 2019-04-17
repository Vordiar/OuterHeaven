USE TI_DT_LPiatek_Kosmos
GO

----Widoki----

--Widok 1--
--Celem jest wy�wietlenie pracownik�w, misje jakie wykonuj� (wraz z czasem na ich wykonanie i rozkazem), na jakiej planecie si� znajduj� 
--i jakie wyposa�enie posiadaj�. Zatem widok ten powstaje ze z��czenia 5 tabel: Pracownicy, Misje, Planety, Wyposazenie i Rozkazy.

create view Widok1
as select p.PRAC_Imie as 'Imi� pracownika', p.PRAC_Nazwisko as 'Nazwisko pracownika', m.MIS_Czas_Poczatek as 'Data rozpocz�cia misji', 
m.MIS_Czas_Koniec as 'Data zako�czenia misji', pla.PLA_Nazwa as 'Nazwa planety', w.WYP_NAZWA as 'Wyposa�enie', r.ROZ_Nazwa as 'Rozkaz' 
from Pracownicy as p inner join Misje as m on p.PRAC_Mis_ID=m.MIS_ID inner join Planety as pla on m.MIS_PLA_ID=pla.PLA_ID inner join 
Wyposazenie as w on m.MIS_WYP_ID=w.WYP_ID inner join Rozkazy as r on m.MIS_ROZ_ID=r.ROZ_ID;
--select * from Widok1

--Widok 2--
--Celem jest wy�wietlenie podstawowych informacji o pracowniku: jego imienia i nazwiska, stanowiska jakie zajmuje, w jakim dziale pracuje i na jakiej
--planecie si� ten dzia� mie�ci, jego wyp�aty i sposobu w jaki j� otrzymuje. Widok powstaje ze z��czenia 6 tabel: Planety, Dzialy, Wyplaty, Sposob_Zaplaty,
--Pracownicy i Stanowisko.

create view Widok2
as select p.PRAC_Imie+' '+p.PRAC_Nazwisko as 'Imi� i nazwisko pracownika', s.STA_Nazwa as 'Stanowisko', w.WY_KWOTA as 'Kwota wyp�aty',
spo.SPO_Nazwa as 'Spos�b zap�aty', d.DZ_Nazwa as 'Nazwa dzia�u', pla.PLA_Nazwa as 'Planeta z siedzib� dzia�u' from Pracownicy as p inner join Stanowisko as s 
on p.PRAC_STA_ID=s.STA_ID inner join Wyplaty as w on p.PRAC_WY_ID=w.WY_ID inner join Sposob_Zaplaty as spo on w.WY_SPO_ID=spo.SPO_ID inner join Dzialy as d on 
p.PRAC_DZ_ID=d.DZ_ID inner join Planety as pla on d.DZ_PLA_ID=pla.PLA_ID;
--select * from Widok2

--Widok 3--
--Celem jest wy�wietlenie najwa�niejszych informacji z tabeli Planety. Widok ten nie zawiera z��czenia tabel.

create view Widok3
as select PLA_Nazwa as 'Nazwa planety', PLA_Sektor as 'Sektor', PLA_Agent as 'Agent na planecie', PLA_Opis as 'Opis planety', 
PLA_Stopien_Zagrozenia as 'Stopie� zagro�enia na planecie' from Planety
--select * from Widok3

--Poni�sze linijki kodu pozwalaj� na usuni�cie widoku.
--drop view Widok1
--drop view Widok2
--drop view Widok3


----Procedury----

--Procedura 1--
--Celem procedury jest awaryjne usuni�cie ca�ej zawarto�ci bazy danych, czyli wszystkich tabeli razem z ich zawarto�ci�. Warunkiem jest podanie has�a.

Create procedure ShutDownEverything @haslo varchar(21)
as
begin
if @haslo like 'Nic nie trwa wiecznie' alter table Planety drop constraint FK_PLA_Siedziba_Nazwa
if @haslo like 'Nic nie trwa wiecznie' alter table Planety drop constraint CK_PLA_Stopien_Zagrozenia
if @haslo like 'Nic nie trwa wiecznie' alter table Misje drop constraint FK_MIS_PLA_ID
if @haslo like 'Nic nie trwa wiecznie' alter table Misje drop constraint FK_MIS_WYP_ID
if @haslo like 'Nic nie trwa wiecznie' alter table Misje drop constraint FK_MIS_ROZ_ID
if @haslo like 'Nic nie trwa wiecznie' alter table Dzialy drop constraint FK_DZ_PLA_ID
if @haslo like 'Nic nie trwa wiecznie' alter table Wyplaty drop constraint FK_WY_SPO_ID
if @haslo like 'Nic nie trwa wiecznie' alter table Pracownicy drop constraint FK_PRAC_STA_ID
if @haslo like 'Nic nie trwa wiecznie' alter table Pracownicy drop constraint FK_PRAC_DZ_ID
if @haslo like 'Nic nie trwa wiecznie' alter table Pracownicy drop constraint FK_PRAC_WY_ID
if @haslo like 'Nic nie trwa wiecznie' alter table Pracownicy drop constraint FK_PRAC_MIS_ID
if @haslo like 'Nic nie trwa wiecznie' drop table Pracownicy
if @haslo like 'Nic nie trwa wiecznie' drop table Stanowisko
if @haslo like 'Nic nie trwa wiecznie' drop table Wyposazenie
if @haslo like 'Nic nie trwa wiecznie' drop table Wyplaty
if @haslo like 'Nic nie trwa wiecznie' drop table Planety
if @haslo like 'Nic nie trwa wiecznie' drop table Siedziba
if @haslo like 'Nic nie trwa wiecznie' drop table Misje
if @haslo like 'Nic nie trwa wiecznie' drop table Rozkazy
if @haslo like 'Nic nie trwa wiecznie' drop table Sposob_Zaplaty
if @haslo like 'Nic nie trwa wiecznie' drop table Dzialy
if @haslo not like 'Nic nie trwa wiecznie' print 'Haslo niew�a�ciwe'
if @haslo like 'Nic nie trwa wiecznie' print 'Pomy�lnie usuni�to wszystkie dane. Nic nie trwa wiecznie.'
if @@error=0 print 'Nie wykryto b��d�w. Procedura zako�czona sukcesem.'
end

--Przed aktywowaniem procedury prosz� sprawdzi� pozosta�e, poniewa� ta wykasuje wszystkie dane.
--execute ShutDownEverything 'Nic nie trwa wiecznie'

--Procedura 2--
--Celem procedury jest wy�wietlenie pracownik�w, kt�rym ko�czy si� termin na wykonanie powierzonego im zadania. Je�eli pracownikowi zostanie poni�ej 20 dni
--na wykonanie zadania jego dane zostan� wy�wietlone

Create procedure Koniec_terminu 
as
begin
declare @data int
select @data=datediff(day,getdate(),Mis_Czas_Koniec) from Misje inner join Pracownicy on MIS_ID=PRAC_MIS_ID
if @data<20
select p.Prac_Imie as 'Imi� pracownika', p.Prac_Nazwisko as 'Nazwisko pracownika', @data as 'Ilo�� dni do zako�czenia misji' from Pracownicy as p inner join Misje
on p.PRAC_MIS_ID=MIS_ID where datediff(day,getdate(),Mis_Czas_Koniec)<20
else print '�aden z pracownik�w nie ma nagl�cych termin�w zako�czenia misji'
end
		--Teraz po wymuszeniu procedury wy�wietli si� komunikat '�aden z pracownik�w nie ma nagl�cych termin�w zako�czenia misji'
--exec Koniec_terminu
		--Je�eli dodamy jednak po jednej warto�ci do misji i pracownika:
--insert into Misje values (7,2,4,'2012-01-10', '2016-05-08');
--insert into Pracownicy values ('Galileo','Galilei',1,2,4,11,'Uwa�a, �e Ziemia jest centrum wszech�wiata.');
		--Wy�wietli si� inna warto�, poniewa� dodany pracownik 
--exec Koniec_terminu

--Procedura 3--
--Celem procedury jest wy�apanie b��d�w, kt�re powstaj� po niew�a�ciwym wprowadzeniu danych. W tym celu celowo przed sprawdzeniem procedury wprowadz� z�e dane
--do tabeli Rozkazy. W tym przypadku b�dzie to zamiana warto�ci liczbowej (w ROZ_ID) na warto�� tekstow�.

Create procedure Wylapywanie_bledow
as
begin try
UPDATE Rozkazy
SET ROZ_OPIS=20 where ROZ_ID='Mleko';
if @@error=0 select 'Nie znaleziono b��d�w'
end try
begin catch
Select
ERROR_NUMBER() as ErrorNumber,
ERROR_SEVERITY() as ErrorSeverity,
ERROR_STATE() as ErrorState,
ERROR_PROCEDURE() as ErrorProcedure,
ERROR_LINE() as ErrorLine,
ERROR_MESSAGE() as ErrorMessage;
end catch;

--Sprawdzenie procedury. Warto zauwa�y�, �e nie wy�wietli� si� dodatkowo tekst ('Nie znaleziono b��d�w'), poniewa� znaleziono b��dy.
--exec Wylapywanie_bledow


----Funkcje----

--Funkcja 1--
--Podana funkcja po wyzwoleniu ma wy�wietla� czym zajmuje si� aktualnie pracownik. W celu szybszego znalezienia konkretnych informacji proces selekcji 
--b�dzie odbywa� si� za pomoc� ID.

create function Informacje_Pracownik(@id_pracownika int)
returns table
as
return
(
select p.PRAC_Imie as 'Imi� pracownika', p.PRAC_Nazwisko as 'Nazwisko pracownika', m.MIS_Czas_Poczatek as 'Czas rozpocz�cia misji', m.MIS_Czas_Koniec as
'Data zako�czenia misji',datediff(day,m.MIS_Czas_Poczatek,m.Mis_Czas_Koniec) as 'Ilo�� dni przeznaczona na wykonanie misji', pla.PLA_Nazwa as 'Nazwa planety',
w.WYP_NAZWA as 'Nazwa wyposa�enia', r.ROZ_Nazwa as 'Nazwa rozkazu' from Pracownicy as p inner join Misje as m on p.PRAC_Mis_ID=m.MIS_ID inner join Planety as pla 
on m.MIS_PLA_ID=pla.PLA_ID inner join Wyposazenie as w on m.MIS_WYP_ID=w.WYP_ID inner join Rozkazy as r on m.MIS_ROZ_ID=r.ROZ_ID where p.PRAC_ID=@id_pracownika
)

--Sprawdzenie funkcji:
--select * from Informacje_Pracownik(6)

--Funkcja 2--
--Funkcja b�dzie pokazywa�a wszystkie informacje o planecie po podaniu jej nazwy.

create function Planeta(@planeta varchar(30))
returns table
as
return
(
select p.PLA_Nazwa as 'Nazwa planety', p.PLA_Sektor as 'Sektor, w kt�rym znajduje si� planeta', p.PLA_Agent as 'Agent na planecie', p.PLA_Opis as 'Opis planety',
m.MIS_Czas_Poczatek as 'Data rozpocz�cia misji na planecie', p.PLA_Siedziba_Nazwa as 'Planeta, na kt�rej znajduje si� centrala' 
from Planety as p inner join Misje as m on p.PLA_ID=m.MIS_PLA_ID where p.PLA_Nazwa like (@planeta) 
)

--Sprawdzenie funkcji:
--select * from Planeta('Ziemia')

--Funkcja 3--
--Pokazuje ile misji przydzielono na planecie okre�lonego dnia. Je�eli wybierzemy dat� podczas kt�rej misje nie zosta�y przydzielone wy�wietl� si� puste kolumny.

create function Ilosc_Misji(@data date)
returns table
as
return
(
select count(m.MIS_Czas_Poczatek) as 'Ilo�� misji przydzielona w danym dniu', p.PLA_Nazwa as 'Nazwa planety' from Misje as m inner join Planety as p on 
m.MIS_PLA_ID=p.PLA_ID where MIS_Czas_Poczatek=@data group by p.PLA_Nazwa
)

--Sprawdzenie funkcji:
--select * from Ilosc_Misji(getdate()) --zamiast getdate() mo�na poda� dowoln� warto�� np ('2016-04-24')


----Wyzwalacze----

--Wyzwalacz 1--
--Wyzwalacz, kt�ry po dodaniu nowej planety wy�wietli komunikat oraz sprawdzi czy planeta nie istnieje ju� w rejestrze. Je�eli planeta b�dzie istnia�a w rejestrze
--jej dodawanie zako�czy si� niepowodzeniem.

create trigger sprawdz_planety
on Planety
instead of insert
as
set nocount on
if exists(select * from inserted as i inner join Planety as p ON p.PLA_Nazwa=i.PLA_Nazwa)
begin
raiserror('Planeta istnieje ju� w bazie danych. Dodawanie planety zako�czone niepowodzeniem', 16, 1)
rollback tran
end
else begin
insert into Planety (PLA_Sektor, PLA_Nazwa, PLA_Siedziba_Nazwa, PLA_Agent, PLA_Stopien_Zagrozenia, PLA_Opis)
select PLA_Sektor, PLA_Nazwa, PLA_Siedziba_Nazwa, PLA_Agent, PLA_Stopien_Zagrozenia, PLA_Opis from inserted
print 'Pomy�lnie dodano now� planet�. Gratulujemy odkrycia!'
end

--Sprawdzenie wyzwalacza poni�ej. Za pierwszym razem planeta zostanie pomy�lnie dodana. Je�eli jednak spr�buje si� j� doda� jeszcze raz wy�wietli si� b��d.--
--insert into Planety values ('Uk�ad S�oneczny','Neptun','Ksi�yc','Miko�aj Kopernik',1,'Gazowy olbrzym. 8 w kolejno�ci od S�o�ca planeta.')

--Wyzwalacz 2--
--Celem wyzwalacza jest nadanie komunikatu po dodaniu nowego pracownika pokazuj�cy ��czn� ilo�� zatrudnionych pracownik�w.

create trigger Pracowniczy
on Pracownicy
after insert
as
begin
declare @ilosc_pracownikow int
set @ilosc_pracownikow=(select count(*) from Pracownicy)
select 'Pomy�lnie dodano nowego pracownika.Gratulujemy! To ju�'+' '+convert(char(3),@ilosc_pracownikow)+''+'zatrudniona osoba!' as 'Ilo�� pracownik�w'
end

--Sprawdzenie wyzwalacza:
--insert into Pracownicy values ('�ukasz','Pi�tek',1,2,5,2,'Posiada do�wiadczenie w tworzeniu bazy danych w j�zyku SQL.');

--Wyzwalacz 3--
--Celem wyzwalacza jest wy�wietlenie wszystkich posiadanych przedmiot�w w tabeli 'Wyposa�enia' po dodaniu nowego. Dodatkowym atrybutem jest 3 sekundowe op�nienie.

create trigger wait_for_it
on Wyposazenie
after insert
as
waitfor delay '000:00:03'
select WYP_NAZWA as 'Nazwa', WYP_Wlasciciel as 'W�a�ciciel', WYP_okres_gwarancji as 'Okres gwarancji',
WYP_cena as 'Cena za wyposa�enie', WYP_opis as 'Opis', ' \ (�.�) / Gratulujemy wyboru wyposa�enia.' as 'Komentarz' from Wyposazenie
go

--Sprawdzenie wyzwalacza:--
--insert into Wyposazenie values ('Zbiornik z powietrzem','Agencja Lot�w Kosmicznych',2,100.00,'Zbiorniki z powietrzem przeznaczone dla astronaut�w.');

--Wyzwalacz dodatkowy--
--Celem wyzwalacza jest zablokowanie jakichkolwiek zmian w bazie danych. Nie b�dzie mo�na: dodawa�, usuwa� ani modyfikowa� tabel. Nale�y jednak uwa�a�, poniewa�
--zablokuje to ingerencj� w tabele na ca�ym serwerze.

create trigger JustPullTheTrigger
on all server
for create_table, alter_table, drop_table
as
begin
print 'Mo�liwo�� ingerencji w struktur� bazy danych zosta�a zablokowana. Prosimy nie dodawa�/usuwa�/modyfikowa� tabeli.'
rollback
end

--Sprawdzenie wyzwalacza:--
--CREATE TABLE Dolary
--	(DO_ID int identity(1,1) constraint PK_Dolary primary key,
--	DO_NAZWA varchar(30) not null,
--	DO_Wlasciciel varchar(30) not null,
--	DO_okres_gwarancji int,
--	DO_cena numeric(20,2) not null,
--	DO_opis varchar(600) );

--W celu usuni�cia wyzwalacza nale�y przej�� w zak�adk� 'Server Objects' w 'Object Explorer' a nast�pnie usun�� go z katalogu Triggers. 