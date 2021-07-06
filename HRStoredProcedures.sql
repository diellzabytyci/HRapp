-- PROCEDURAT PER Mesazhin
-------------------------------------------------
go
create procedure MesazhiInsert
@Emri varchar(30),
@Mbiemri varchar(30),
@Email varchar(30),
@Teksti varchar(1000)

as
insert Mesazhi 

(
Emri,
Mbiemri,
Email,
Teksti,
DataEKrijimit
)

values

(
@Emri,
@Mbiemri,
@Email,
@Teksti,
getdate()
)

GO

-- PROCEDURAT PER PUNETORIN
-------------------------------------------------
create procedure DeleteFilialetPunetorit
@idpunetori int
as
delete from FilialetEPunetorit
where IDPunetori=@IDPunetori
go
-------------------------------------------------
go
create procedure GetPozitaForPunetori
@idpunetori int 
as
select puna.Pozita as 'Pozita'
from Punetori p inner join Kontrata k 
				on p.IDPunetori=k.Punetori 
					inner join Puna puna
					on k.Puna=puna.IDPuna
where p.IDPunetori=@idpunetori
go
-------------------------------------------------
go
create procedure Punetoriinsert
@Emri varchar(30),
@Mbiemri varchar(30),
@Email varchar(30),
@Gjinia varchar(1),
@Adresa int,
@Departamenti int,
@KrijuarNga int,
@IDLeternjoftimi bigint,
@Datlindja date

as
insert Punetori 

(
Emri,
Mbiemri,
Email,
Gjinia,
Adresa,
Departamenti,
KrijuarNga,
IDLeternjoftimi,
Datlindja,
DataERegjistrimit,
aktive
)

values

(
@Emri,
@Mbiemri,
@Email,
@Gjinia,
@Adresa,
@Departamenti,
@KrijuarNga,
@IDLeternjoftimi,
@Datlindja,
getdate(),
1
)

GO
-------------------------------------------------
create procedure PunetoriUserinsert
@IDPunetori int,
@Fjalekalimi nvarchar(200),
@UserGroup int

as
insert PunetoriUser 

(
IDPunetori,
Fjalekalimi,
UserGroup
)

values

(
@IDPunetori,
@Fjalekalimi,
@UserGroup
)

GO
-------------------------------------------------
create procedure PunetoriUserupdate
@IDPunetori int,
@Fjalekalimi nvarchar(300),
@UserGroup int

as

update PunetoriUser set

Fjalekalimi = @Fjalekalimi,
UserGroup = @UserGroup

WHERE IDPunetori = @IDPunetori

GO
-------------------------------------------------
create procedure Punetoriupdate

@IDPunetori int,
@Emri varchar(20),
@Mbiemri varchar(20),
@Email varchar(30),
@Gjinia varchar(1),
@Adresa int,
@ModifikuarNga int,
@IDLeternjoftimi bigint

as

update Punetori set

Emri = @Emri,
Mbiemri = @Mbiemri,
Email = @Email,
Gjinia = @Gjinia,
ModifikuarNga = @ModifikuarNga,
IDLeternjoftimi=@IDLeternjoftimi

WHERE IDPunetori = @IDPunetori

GO
-------------------------------------------------
create procedure PunetoriselectByID

@IDPunetori int

as

select * from Punetori where IDPunetori = @IDPunetori AND aktive = 1
GO
-------------------------------------------------
create procedure PunetorigetFiliali

@IDPunetori int

as

select fep.IDFiliali as 'Filiali' from FilialetEPunetorit fep
where fep.IDPunetori = @IDPunetori
GO
-------------------------------------------------
create procedure PunetoretSelectByEmriOrMbiemri

@search varchar(50)

as

select * from Punetori where 
emri + ' ' + mbiemri like @search + '%' AND aktive = 1
GO
-------------------------------------------------
CREATE procedure PunetoriselectByEmail

@search varchar(50)

as

select * from Punetori where

Email LIKE @search + '%' AND aktive = 1

GO
-------------------------------------------------
CREATE procedure PunetoriselectByGjinia

@search varchar(1)

as

select * from Punetori where

Gjinia LIKE @search + '%' AND aktive = 1

GO
-------------------------------------------------
CREATE procedure PunetoriselectByNrTelefonit

@search varchar(50)

as

select p.* from PunetoriKontakt pk inner join Punetori p on Pk.Punetori = p.IDPunetori
where Punetori LIKE @search + '%' AND p.aktive = 1

GO
-------------------------------------------------
create procedure PunetoriselectByIDLeternjoftimi

@IDLeternjoftimi bigint

as

select * from Punetori where

IDLeternjoftimi =@IDLeternjoftimi AND aktive = 1

GO
-------------------------------------------------
CREATE procedure PunetoretSelectByVendbanimi

@search varchar(50)

as

select p.* from Adresa a inner join Punetori p on a.IDAdresa = p.Adresa

where a.Shteti LIKE @search + '%' OR
a.Qyteti LIKE @search + '%' OR
a.NumriIHyrjes LIKE @search + '%' OR
a.Rruga LIKE @search + '%'
AND p.aktive = 1

GO
-------------------------------------------------
CREATE procedure PunetoretSelectByDataERegjistrimit

@search varchar(50)

as

select * from Punetori where

DataERegjistrimit LIKE @search + '%' AND aktive = 1

GO
-------------------------------------------------
CREATE procedure PunetoriselectPunetoretByDepartamenti

@search varchar(50)

as

select * from Punetori p inner join Departamenti d
on p.Departamenti = d.IDDepartamenti
where d.Emri LIKE @search + '%' AND p.aktive = 1

GO
-------------------------------------------------
CREATE procedure PunetoriselectPunetoretByFiliali

@search varchar(50)

as

select * from Punetori p join FilialetEPunetorit fp join Filiali f 
on f.IDFiliali = fp.IDFiliali
on p.IDPunetori = fp.IDPunetori
where f.emri like @search + '%' AND p.aktive = 1

GO
-------------------------------------------------
create procedure SelectAllPunetoretByDepartamenti
@IDDepartamenti int

as

Select * from Punetori where Departamenti = @IDDepartamenti
go
-------------------------------------------------
create procedure SelectAllNumratByPunetoriID
@IDPunetori int
as
Select NumriTelefonit as 'Numri' From PunetoriKontakt
where Punetori = @IDPunetori
go
-------------------------------------------------
create procedure PunetoriGeneratePassword 
@IDPunetori int,
@Fjalekalimi varchar(30)

as

UPDATE PunetoriUser set Fjalekalimi = @Fjalekalimi
where IDPunetori = @IDPunetori
go
-------------------------------------------------

--PROCEDURAT PER KERKIM TE PERGJITHSHEM
-------------------------------------------------
CREATE procedure SelectAllPunetoretBySearch

@search varchar(30)

as

select p.* from Punetori p inner join PunetoriKontakt pk on p.IDPunetori = pk.Punetori inner join Adresa a on p.Adresa = a.IDAdresa

where
(p.IDPunetori LIKE @search + '%' OR
p.Emri LIKE @search + '%' OR
p.Mbiemri LIKE @search + '%' OR
p.Email LIKE @search + '%' OR
p.Gjinia LIKE @search + '%' OR

pk.NumriTelefonit LIKE @search + '%' OR

a.Shteti LIKE @search + '%' OR
a.Qyteti LIKE @search + '%' OR
a.Rruga LIKE @search + '%' OR
a.NumriIHyrjes LIKE @search + '%' OR

IDLeternjoftimi LIKE @search + '%' OR
DataERegjistrimit LIKE @search + '%' OR
Departamenti LIKE @search + '%') AND
aktive = 1

GO
-------------------------------------------------

CREATE procedure SelectAllMesazhetBySearch

@search varchar(30)

as

select * from Mesazhi 

where
Emri LIKE @search + '%' OR
Email LIKE @search + '%' OR
Mbiemri LIKE @search + '%' OR
DataEKrijimit LIKE @search + '%'


GO
-------------------------------------------------
CREATE procedure SelectDepartamentetBySearch

@search varchar(30)

as

select * from Departamenti where

(IDDepartamenti LIKE @search + '%' OR
Emri LIKE @search + '%') AND aktive = 1

GO
-------------------------------------------------
CREATE procedure SelectAllFilialetBySearch

@search varchar(50)

as

select * from Filiali f inner join Adresa a on f.Adresa = a.IDAdresa

where
(emri LIKE @search + '%' OR

a.shteti LIKE @search + '%' OR
a.qyteti LIKE @search + '%' OR
a.Rruga LIKE @search + '%' OR
a.NumriIHyrjes LIKE @search + '%' OR

f.numrikontaktues LIKE @search + '%' OR
f.email LIKE @search + '%' OR
f.krijuarnga LIKE @search + '%' OR
f.ModifikuarNga LIKE @search + '%')
AND f.aktive = 1
GO
-------------------------------------------------

-- PROCEDURAT PER DEPARTAMENTIN
-------------------------------------------------
create procedure DepartametEFilialitOnDeleteByDepartamenti
@iddepartamenti int 
as
delete from Departamentet_E_Filialit 
where ID_Departamenti=@iddepartamenti
go
--------------------------------------------------
create procedure SelectAllDepartamentiNames
as 
select emri from Departamenti 
go
-----------------------------------------------

CREATE procedure SelectManagerOfDepartament

@IDDepartamenti int

as

select Menaxheri from Departamenti where IDDepartamenti = @IDDepartamenti
GO
-------------------------------------------------
create procedure DepartamentiselectByID

@IDDepartamenti int

as

select * from Departamenti where IDDepartamenti = @IDDepartamenti AND aktive = 1
GO
-------------------------------------------------
create procedure DepartamentiselectByEmri

@Emri varchar(30)

as

select * from Departamenti where Emri = @Emri AND aktive = 1
GO
-------------------------------------------------
create procedure Departamentiinsert

@Emri varchar(30),
@KrijuarNga int

as
insert Departamenti

(
Emri,
KrijuarNga,
DataERegjistrimit,
aktive
)

values

(
@Emri,
@KrijuarNga,
GetDate(),
1

)

GO
-------------------------------------------------
CREATE procedure Departamentiupdate

@IDDepartamenti int,
@Emri varchar(30),
@Menaxheri int,
@ModifikuarNga int

as

update Departamenti set

Emri = @Emri,
Menaxheri = @Menaxheri,
ModifikuarNga = @ModifikuarNga

WHERE IDDepartamenti = @IDDepartamenti

GO
-------------------------------------------------
create procedure GetNrPunetoreve
@IDDepartamenti int 
as
select count(*) as 'NrIPunetoreve' from Departamenti d inner join Punetori p
on d.IDDepartamenti = p.Departamenti
where d.IDDepartamenti = @IDDepartamenti  AND p.aktive = 1
GO
-------------------------------------------------
create procedure GetNrFilialeve
@IDDepartamenti int

as
select count(*) as 'NrIFilialeve' from Filiali f join DepartamentetEFilialit def on f.IDFiliali = def.IDFiliali 
where def.IDDepartamenti = @IDDepartamenti
GO
-------------------------------------------------

-- PROCEDURA PER FILIALIN
-------------------------------------------------
create procedure selectAdresaForFiliali
@idfiliali	int 
as
select a.* from Adresa a inner join Filiali f on a.IDAdresa=f.Adresa
where f.IDFiliali=@idfiliali
go
-------------------------------------------------
create procedure GetListeEFilialeve
as
select f.IDFiliali as 'IDFiliali',emri as 'Emri',f.email as 'Email',a.Qyteti as'Qyteti'
from Filiali f inner join Adresa a
				on f.Adresa=a.IDAdresa
go

------------------------------------------------
create procedure filialiselectByEmri
@search varchar(255) 
as
select f.*,a.*
from Filiali f inner join Adresa a
				on f.Adresa=a.IDAdresa
where f.emri=@search and aktive=1
go
-----------------------------------------
CREATE procedure filialiinsert
@Emri varchar(30),
@Adresa int,
@numrikontaktues varchar(20),
@email varchar(30),
@zyre int,
@KrijuarNga int

as
insert filiali

(
Emri,
Adresa,
Numrikontaktues,
email,
zyre,
KrijuarNga,
DataERegjistrimit,
aktive
)

values

(
@Emri,
@Adresa,
@Numrikontaktues,
@email,
@zyre,
@KrijuarNga,
GetDate(),
1
)

GO
-------------------------------------------------
create procedure filialiupdate

@IDfiliali int,
@Emri varchar(30),
@Adresa int,
@Numrikontaktues varchar(20),
@email varchar(30),
@zyre int,
@ModifikuarNga int

as

update filiali set

Emri = @Emri,
Adresa = @Adresa,
Numrikontaktues = @Numrikontaktues,
Email = @Email,
zyre = @zyre,
ModifikuarNga = @ModifikuarNga

WHERE IDfiliali = @IDfiliali

GO
-------------------------------------------------
create procedure filialiselectByID

@IDfiliali int

as

select * from filiali where IDfiliali = @IDfiliali  AND aktive = 1
go
-------------------------------------------------
--Zgjedh te gjitha departamentet te cilat i posdeon nje Filial
create procedure SelectDepartamentsByFiliali

@IDfiliali int

as

select * from Departamenti d inner join DepartamentetEFilialit def
on d.IDDepartamenti = def.IDDepartamenti
where def.IDFiliali = @IDfiliali
go
-------------------------------------------------
CREATE PROCEDURE FilialiselectByQyteti

@search varchar(30)
as

SELECT * from Filiali f inner join Adresa a on f.Adresa = a.IDAdresa
where a.qyteti like @search + '%' AND f.aktive = 1

GO
-------------------------------------------------
create procedure FilialetEPunetoritInsert
@IDPunetori int,
@IDFiliali int
as
Insert FilialetEPunetorit
(
IDPunetori,
IDFiliali,
DataERegjistrimit
)

values(
@IDPunetori,
@IDFiliali,
GETDATE()
)
GO
-------------------------------------------------
create procedure filialiselectByDepartamentiName

@Departamenti Varchar(30)

as

select f.* from Filiali f join DepartamentetEFilialit df join Departamenti d 
on df.IDDepartamenti = d.IDDepartamenti
on f.IDFiliali = df.IDFiliali 
where d.Emri = @Departamenti

GO
-------------------------------------------------
create procedure filialiselectByDepartamenti

@Departamenti int

as

select f.* from Filiali f join DepartamentetEFilialit df
on f.IDFiliali = df.IDFiliali
where df.IDDepartamenti = @Departamenti
GO
-------------------------------------------------
create procedure SelectAllFilialetByEmri

@search varchar(30)

as

select * from filiali where emri = @search  AND aktive = 1

GO
-------------------------------------------------
create procedure SelectAllFilialetNamesByIDPunetori

@IDPunetori int

as

select f.emri from FilialetEPunetorit fp inner join Filiali f
on fp.IDFiliali = f.IDFiliali AND fp.IDPunetori = @IDPunetori

GO
-------------------------------------------------
create procedure SelectAllForDropDownFiliali

as
select IDFiliali,emri
from filiali
where aktive = 1
go
-------------------------------------------------
create procedure SelectAllPunetoretByPuna

@search varchar(30)

as

Select p.emri, p.Mbiemri, p.IDPunetori from Punetori p inner join Kontrata k on p.IDPunetori = k.Punetori
inner join Puna pu on k.Puna = pu.IDPuna
where pu.Pozita like @search + '%' AND k.aktive = 1 AND p.aktive = 1

GO
-------------------------------------------------
CREATE procedure SelectPunetByDepartament

@Departamenti varchar(30)
as

select p.IDPuna,p.Pozita
from Puna p inner join departamenti d on
			IDDepartamenti=Departamenti
where emri like @Departamenti +'%' AND d.aktive = 1 AND p.aktive = 1
GO
-------------------------------------------------
CREATE procedure SelectWithoutManager

@Departamenti varchar(30)

as

select idpuna,pozita 
from Puna inner join Departamenti d on
		Departamenti=IDDepartamenti
where d.Emri=@Departamenti AND d.aktive = 1
group by idpuna,pozita
having pozita not in (select pozita 
						from Puna
						group by pozita
						having pozita='menaxher'
						)

GO
-------------------------------------------------

-- PROCEDURA PER PUNEN
-------------------------------------------------
create procedure Punaupdate
@idpuna int,
@pozita varchar(250),
@modifikuarnga int
as
update Puna set 
Pozita=@pozita,
@modifikuarnga=@modifikuarnga
where IDPuna=@idpuna
go
-------------------------------------------------
create procedure PunaEkziston
@pozita varchar(255),
@departamenti int
as
select * from Puna 
where Pozita=@pozita and Departamenti=@departamenti
go
-------------------------------------------------
create procedure Punainsert


@Pozita varchar(30),
@departamenti int,
@KrijuarNga int

as

insert Puna 

(
Departamenti,
Pozita ,
KrijuarNga,
DataERegjistrimit
)

values

(
@departamenti,
@Pozita,
@KrijuarNga,
GETDATE() 
)
go
-------------------------------------------------
CREATE procedure SelectAllPunet

as

select * from Puna
where aktive = 1
GO
-------------------------------------------------
create procedure PunaselectByID

@IDPuna int

as

select * from Puna where IDPuna = @IDPuna AND aktive = 1
GO
-------------------------------------------------
CREATE procedure PunaselectByEmri

@search varchar(50)

as

select * from Puna
where Pozita = @search AND aktive = 1
go
-------------------------------------------------
create procedure PunaselectBySearch

@search varchar(30)

as

select * from Puna where

IDPuna LIKE @search + '%' OR
Pozita LIKE @search + '%' OR
Departamenti LIKE @search + '%' OR
DataERegjistrimit LIKE @search + '%' AND aktive = 1
Go
-------------------------------------------------
CREATE procedure PunaselectByDepartamenti

@search varchar(30)

as

select p.* from Puna p join Departamenti d
on p.Departamenti = d.IDDepartamenti
where d.Emri like @search + '%' AND p.aktive = 1
GO
-------------------------------------------------
create procedure MerrAktetPerKontraten
@idkontrata int 
as
select a.* from Kontrata k inner join Aneksi a
				on k.IDKontrata=a.Kontrata
where IDKontrata=@idkontrata
go 
-------------------------------------------------

-- PROCEDURA PER KONTRATE
-------------------------------------------------
create procedure kontratainsert
@DataEFillimit date,
@DataESkadimit date,
@pauza int,
@LeshuarNga int,
@Punetori int,
@ParaJavetELeshimit int,
@PagaPerOre int,
@OretEPunesDitore int,
@DitetJavore int,
@PerqindjaEBonusOreve int,
@nderrimi int,
@Puna int

as
insert Kontrata

(
DataEFillimit,
DataESkadimit,
pauza,
PagaPerOre,
LeshuarNga,
Punetori,
Dataeregjistrimit,
PerqindjaEBonusOreve,
Nderrimi,
Puna,
ParaJavetELeshimit,
OretEPunesDitore,
DitetJavore
)

values

(
@DataEFillimit,
@DataESkadimit,
@pauza,
@PagaPerOre,
@LeshuarNga,
@Punetori,
getdate(),
@PerqindjaEBonusOreve,
@nderrimi,
@Puna,
@ParaJavetELeshimit,
@OretEPunesDitore,
@DitetJavore
)

GO
-------------------------------------------------
create procedure KontrataselectByID

@IDKontrata int

as

select * from Kontrata where IDKontrata = @IDKontrata AND aktive = 1
GO
-------------------------------------------------
create procedure KontrataselectByPunetoriID

@IDPunetori int

as

select * from Kontrata where Punetori = @IDPunetori AND aktive = 1
GO
-------------------------------------------------
CREATE procedure selectPunaByDepartamentPozita

@Pozita varchar,
@Departamenti int
as
select idpuna from puna
where Pozita like @Pozita+'%' and Departamenti = @Departamenti AND aktive = 1

GO
-----------------------------------------------
create procedure KontrataUpdate
@idkontrata int,
@DataEFillimit date,
@DataESkadimit date,
@pauza int,
@ParaJavetELeshimit int,
@PagaPerOre int,
@OretEPunesDitore int,
@DitetJavore int,
@PerqindjaEBonusOreve int,
@nderrimi int,
@Puna int
as
update Kontrata set
DataEFillimit=@DataEFillimit,
DataESkadimit=@DataESkadimit,
Pauza=@pauza,
ParaJavetELeshimit=@ParaJavetELeshimit,
PagaPerOre=@PagaPerOre,
OretEPunesDitore=@OretEPunesDitore,
DitetJavore=@DitetJavore,
PerqindjaEBonusOreve=@PerqindjaEBonusOreve,
Nderrimi=@nderrimi,
puna=@Puna
where IDKontrata=@idkontrata
go
-------------------------------------------------
CREATE procedure TerminoKontraten

@IDKontrata int,
@terminimiKontrates int

as

update Kontrata set

terminimiKontrates = @terminimiKontrates,
aktive = 0

WHERE IDKontrata = @IDKontrata

GO
--------------------------------------------------------

-- PROCEDURAT PER DepartamentetEFilialit
-------------------------------------------------
create procedure FilialetEDepartamentitInsert
@IDDepartamenti int,
@IDFiliali int

as

Insert DepartamentetEFilialit
(
IDFiliali,
IDDepartamenti,
DataERegjistrimit
)

values(
@IDFiliali,
@IDDepartamenti,
GETDATE()
)
GO
----------------------------------------------------------

-- PROCEDURAT PER FSHIRJE
----------------------------------------------------------
-- Fshin filialin e punetorit ku eshte duke punuar
create procedure filialetEPunetoritDeleteOnUpdateByFiliali
@IDFiliali int
as
delete from FilialetEPunetorit where IDFiliali = @IDFiliali
go
-------------------------------------------------------------
-- Fshin te gjitha departamentet ne baze te filialit
create procedure DepartamentetEFilialitOnDeleteByFiliali
@IDfiliali int
as 
delete from DepartamentetEFilialit
where IDFiliali = @IDfiliali
go
----------------------------------------------------------------
-- Fshin departamentin ne te gjitha filialet
create procedure DepartamentEFilialitOnDeleteByDepartamenti
@iddepartamenti int 
as

delete from DepartamentetEFilialit
where IDDepartamenti = @iddepartamenti
go
----------------------------------------------------------------
-- Fshin departamentin ne nje filial
create procedure DeleteDepartamentiOnFilial
@IDDepartamenti int,
@IDFiliali int
as

delete from DepartamentetEFilialit
where IDDepartamenti = @iddepartamenti AND IDFiliali = @IDFiliali
go
----------------------------------------------------------------
-- Shton departamentin ne nje filial
create procedure InsertDepartamentiOnFilial
@IDDepartamenti int,
@IDFiliali int

as

insert into DepartamentetEFilialit VALUES(@IDFiliali,@IDDepartamenti, GETDATE())

go
---------------------------------------------------------
-- Fshin nje departament
create procedure DepartamentiUpdateOnDelete 
@iddepartamenti int
as
update Departamenti set
aktive = 0
where IDDepartamenti = @iddepartamenti
go
--------------------------------------------------------
-- Fshin punetorin
create procedure PunetoriUpdateOnDelete 
@IDPunetori int 
as

update Punetori set
aktive = 0
where IDPunetori=@IDPunetori
go
---------------------------------------------------------
-- Fshin punen
create procedure PunaUpdateOnDelete 
@idpuna int 
as
update Puna set 
aktive = 0
where IDPuna = @idpuna
go
----------------------------------------------------------
-- fshin filialin
create procedure filialiDeleteOnUpdate  
@idfiliali int 
as 
update Filiali set
aktive = 0 
where IDFiliali=@idfiliali
go
---------------------------------------------------------
-- fshin te gjitha filialet ku punon punetori
create procedure PunetoriFilialiUpdateOnDeleteByPunetori
@IDPunetori int

as
delete from FilialetEPunetorit
where IDPunetori = @IDPunetori

go
-------------------------------------------------

-- PROCEDRUAT PER PUENTORIUSER
-------------------------------------------------
create procedure PunetoriUserupdatePozita
@idpunetori int,
@usergroup int
as
update PunetoriUser set
UserGroup=@usergroup
where IDPunetori=@idpunetori
go
--------------------------------------------------
create procedure UseriSelectByPunetoriID
@IDPunetori int

as

Select * from PunetoriUser where IDPunetori = @IDPunetori
go
-------------------------------------------------
--numri i punetoreve te cilet kryejn nje pune te caktuar

create procedure getNrPunetorevePerNjePune
@idpuna int 
as
select count(*) as 'NrPunetoreve'
from Kontrata k 
where k.Puna = @idpuna and k.aktive = 1
go
-------------------------------------------------------
-- Kthen 'terminimin e kontrates' nese ka ekzistuar me heret me te njejtin koment
-- Perdoret per ndalimin e redudances, nese terminohen me shume se nje kontrate per te njejten arsye(njejtin koment).
create procedure GetKomentMbiTerminiminEKontrates
@komenti varchar (200)
as
select IDTerminimiKontrates
from TerminimiKontrates
where Komenti=@komenti
go
-------------------------------------------------------
create procedure selectPunetoretCountByDepartamentiFilial

@IDdepartamenti int
as

select d.Emri as 'EmriDepartamentit',f.emri as 'EmriFilialit', count(fp.IDFiliali) as 'numriPerFilial'
from Departamenti d inner join Punetori p on 
					d.IDDepartamenti= P.Departamenti
					inner join FilialetEPunetorit fp on
					p.IDPunetori= fp.IDPunetori
					inner join Filiali f on
					fp.IDFiliali = f.IDFiliali
where d.IDDepartamenti = @IDdepartamenti
group by d.Emri,f.emri
go

------------------------------------------------------------------------
create procedure selectAllVerejtjetPerPunetore 
@IDPunetori int
as
select * 
from Verejtje 
where punetori=@IDPunetori
go
---------------------------------------------------------------------
create procedure SelectAllVerejtjetPerPunetoreBySearch
@IDPunetori int,
@search varchar(2000)
as
select *
from Verejtje 
where punetori = @IDPunetori and (
pershkrimi like @search +'%' or 
data like @search +'%' or
krijuarnga like @search +'%')
go
---------------------------------------------------------------------
create procedure Verejtjeinsert
@punetori int,
@data date,
@pershkrimi varchar(2000),
@krijuarnga int

as

insert into Verejtje
(
data,
Pershkrimi,
krijuarnga,
punetori,
DataERegjistrimit
)

VALUES

(
@data,
@pershkrimi,
@krijuarnga,
@punetori,
GetDate()
)

go
-------------------------------------------------------------------
create procedure selectPunetoretCountByFilialiDepartamenti

@Idfiliali int
as

select d.Emri as 'EmriDepartamentit',f.emri as 'EmriFilialit', count(fp.IDFiliali) as 'numriPerFilial'
from Departamenti d inner join Punetori p on 
					d.IDDepartamenti= P.Departamenti
					inner join FilialetEPunetorit fp on
					p.IDPunetori= fp.IDPunetori
					inner join Filiali f on
					fp.IDFiliali = f.IDFiliali
where f.IDFiliali=@Idfiliali
group by d.Emri,f.emri
go

-----------------------------------------------------------------------
create procedure selectPunetoretCountByFilialiDepartamentSearch
@IDfiliali int,
@search varchar(255)
as

select d.Emri as 'EmriDepartamentit',f.emri as 'EmriFilialit', count(fp.IDFiliali) as 'numriPerFilial'
from Departamenti d inner join Punetori p on 
					d.IDDepartamenti= P.Departamenti
					inner join FilialetEPunetorit fp on
					p.IDPunetori= fp.IDPunetori
					inner join Filiali f on
					fp.IDFiliali = f.IDFiliali
where f.IDFiliali=@IDfiliali and (
d.Emri like @search + '%' or 
f.emri like @search + '%' )
group by d.Emri,f.emri
go
-----------------------------------------------------------------------
create procedure selectPunetoretCountByDepartamentiFilialSearch

@IDdepartamenti int,
@search varchar(255)
as

select d.Emri as 'EmriDepartamentit',f.emri as 'EmriFilialit', count(fp.IDFiliali) as 'numriPerFilial'
from Departamenti d inner join Punetori p on 
					d.IDDepartamenti= P.Departamenti
					inner join FilialetEPunetorit fp on
					p.IDPunetori= fp.IDPunetori
					inner join Filiali f on
					fp.IDFiliali = f.IDFiliali
where d.IDDepartamenti=@IDdepartamenti and 
(d.Emri like @search + '%' or 
f.emri like @search + '%' )
group by d.Emri,f.emri
go
------------------------------------------------------
create procedure GetYearsLeft
@idKontrata int 
as
select datediff(year,CONVERT(date, getdate()),k.DataESkadimit) as 'ViteTeMbetura'
from Kontrata k
where IDKontrata=@idKontrata
go
--------------------------------------------------------
create procedure GetMonthsLeft
@idKontrata int 
as
select datediff(MONTH,CONVERT(date, getdate()),k.DataESkadimit) as 'MuajTeMbetur'
from Kontrata k
where IDKontrata=@idKontrata
go
--------------------------------------------------------
create procedure GetDaysLeft
@idKontrata int 
as
select datediff(DAY,CONVERT(date, getdate()),k.DataESkadimit ) as 'DiteTeMbetura'
from Kontrata k
where IDKontrata=@idKontrata
go
--------------------------------------------------------

-- PROCEDURAT PER PJESEMARRJEN
--------------------------------------------------------
create procedure PjesemarrjaInsert
@IDPunetori int,
@KohaEFillimit time,
@KohaEMbarimit time,
@KrijuarNga int

as

insert into Pjesemarrja

(
Punetori,
Data,
KohaEFillimit,
KohaEMbarimit,
KrijuarNga
)

VALUES
(
@IDPunetori,
GETDATE(),
@KohaEFillimit,
@KohaEMbarimit,
@KrijuarNga
)

go
--------------------------------------------------------
create procedure PjesemarrjaUpdate
@IDPjesemarrja int,
@KohaEFillimit time,
@KohaEMbarimit time,
@ModifikuarNga int

as

update Pjesemarrja set

KohaEFillimit = @KohaEFillimit,
KohaEMbarimit = @KohaEMbarimit,
ModifikuarNga = @ModifikuarNga

WHERE IDPjesemarrja = @IDPjesemarrja

GO
--------------------------------------------------------
create procedure HyrjeDaljeUpdate
@IDHyrjeDalje int,
@Dalja time,
@Kthimi time,
@ModifikuarNga int
as

update HyrjeDalje set

Dalja = @Dalja,
Kthimi = @Kthimi,
ModifikuarNga = @ModifikuarNga

WHERE IDHyrjeDalje = @IDHyrjeDalje

GO
--------------------------------------------------------
create procedure PjesemarrjaSelectByIDPunetori
@IDPunetori int

as

select * from Pjesemarrja
where Punetori = @IDPunetori

GO
--------------------------------------------------------
create procedure PjesemarrjaSelectByID
@IDPjesemarrja int

as

select * from Pjesemarrja
where IDPjesemarrja = @IDPjesemarrja

GO
--------------------------------------------------------
create procedure SelectAllHyrjeDaljeForTodayByPunetori
@IDPunetori int

as

select hd.* from HyrjeDalje hd inner join Pjesemarrja pj
on hd.IDPjesemarrja = pj.IDPjesemarrja
where pj.Punetori = @IDPunetori AND pj.Data = Cast(GETDATE() as Date)


GO
--------------------------------------------------------
create procedure GetOretEMbajturaForTodayByPunetori
@IDPunetori int

as

Select (datediff(hour,KohaEFillimit,KohaEMbarimit)) as 'OretEMbajtura' From Pjesemarrja
where Punetori = @IDPunetori AND Data = CAST(GETDATE() as Date)

go
--------------------------------------------------------
create procedure PjesemarrjaSelectBydata
@Data date,
@IDPunetori int

as

select * from Pjesemarrja
where Data = @Data AND Punetori = @IDPunetori

GO
--------------------------------------------------------

--PROCEDUART PER RECEPSIONIST
--------------------------------------------------------
create procedure PunetoriselectByIDForRecepsionisti

@IDPunetori int,
@Filiali int

as

select * from Punetori p inner join FilialetEPunetorit fep
on p.IDPunetori = fep.IDPunetori

where p.IDPunetori = @IDPunetori AND fep.IDFiliali = @Filiali AND p.aktive = 1
GO
--------------------------------------------------------
create procedure PunetoretSelectByEmriOrMbiemriForRecepsionisti

@search varchar(50),
@Filiali int

as

select * from Punetori p inner join FilialetEPunetorit fep
on fep.IDFiliali = @Filiali

where p.emri + ' ' + p.mbiemri like @search + '%' AND p.aktive = 1
GO
--------------------------------------------------------
CREATE procedure PunetoriselectByNrTelefonitForRecepsionisti

@search varchar(50),
@Filiali int

as

select p.* from PunetoriKontakt pk inner join Punetori p on Pk.Punetori = p.IDPunetori inner join FilialetEPunetorit fep on p.IDPunetori = fep.IDPunetori
where pk.NumriTelefonit LIKE @search + '%' AND fep.IDFiliali = @Filiali AND p.aktive = 1

GO
--------------------------------------------------------
CREATE procedure PunetoriselectByIDLeternjoftimiForRecepsionisti

@search varchar(50),
@Filiali int

as

select * from Punetori p inner join FilialetEPunetorit fep
on fep.IDFiliali = @Filiali

where IDLeternjoftimi LIKE @search + '%' AND p.aktive = 1

GO
--------------------------------------------------------
CREATE procedure PunetoriselectByDepartamentiForRecepsionisti

@search varchar(50),
@Filiali int

as

select * from Punetori p
inner join Departamenti d on p.Departamenti = d.IDDepartamenti
inner join FilialetEPunetorit fep on fep.IDFiliali = @Filiali
where d.Emri LIKE @search + '%' AND p.aktive = 1

GO
--------------------------------------------------------
CREATE procedure SelectAllPunetoretBySearchForRecepsionisti

@IDFiliali varchar(30)

as

select p.* from Punetori p inner join FilialetEPunetorit fep
on fep.IDPunetori = p.IDPunetori AND fep.IDFiliali = @IDFiliali

GO
--------------------------------------------------------
create procedure Userinsert
@IDPunetori int,
@Fjalekalimi varchar(255),
@Prioriteti int
as
insert PunetoriUser
(
IDPunetori,
Fjalekalimi,
UserGroup
)
values
(
@IDPunetori,
@Fjalekalimi,
@Prioriteti
)
go
--------------------------------------------------------
create procedure GetAllPjesemarrjaForTodayForAllPunetoretForRecepsionistiGridView
@IDPunetori int

as

select p.KohaEFillimit, p.KohaEMbarimit, hd.Dalja, hd.Kthimi from Pjesemarrja p inner join HyrjeDalje hd
on hd.IDPjesemarrja = p.IDPjesemarrja
where p.Punetori = @IDPunetori and p.Data = DATEADD(day, DATEDIFF(day,0,GETDATE()), 0)
go
--------------------------------------------------------
create procedure getPjesemarrjaForTodayForPunetori
@IDPunetori int

as

select * from Pjesemarrja
where Punetori = @IDPunetori and Data = cast(GETDATE() as date)
go
--------------------------------------------------------


--PROCEDURA PER PunetoriKontakt
--------------------------------------------------------
create procedure PunetoriKontaktInsert
@NumriTelefonit varchar(20),
@punetori int,
@KrijuarNga int

as

insert into PunetoriKontakt 
VALUES
(
@NumriTelefonit,
@punetori,
@KrijuarNga
)

go
--------------------------------------------------------
create procedure PunetoriKontaktDelete
@idPunetoriKontakt int 
as
delete from PunetoriKontakt where idPunetoriKontakt=@idPunetoriKontakt
go
---------------------------------------------------------
create procedure SelectKontaktByIDPunetori
@IDPunetori int
as
select * from PunetoriKontakt where Punetori = @IDPunetori
go
------------------------------------------------------------

--PROCEDURA PER HyrjeDalje
--------------------------------------------------------
create procedure HyrjeDaljeInsert
@Dalja time,
@Kthimi time,
@IDPjesemarrja int,
@KrijuarNga int

as
insert into HyrjeDalje

(
Dalja,
Kthimi,
IDPjesemarrja,
KrijuarNga
)


values
(
@Dalja,
@Kthimi,
@IDPjesemarrja,
@KrijuarNga
)
go
--------------------------------------------------------
create procedure HyrjeDaljeSelectByID
@IDHyrjeDalje int

as

select * from HyrjeDalje
where IDHyrjeDalje = @IDHyrjeDalje

go
--------------------------------------------------------
create procedure HyrjeDaljeSelectByIDPjesemarrje
@IDPjesemarrja int

as

select * from HyrjeDalje
where IDPjesemarrja = @IDPjesemarrja

go
--------------------------------------------------------

--PROCEDURA PER Aneks
--------------------------------------------------------
create procedure AneksiUpdate
@idaneksi int,
@DataEFillimitAneksit date,
@DataEMbarimitAneksit date,
@PagaDitore int,
@Pershkrimi varchar(1000),
@ModifikuarNga int
as
update aneksi set
DataFillimit=@DataEFillimitAneksit,
DataSkadimit=@DataEMbarimitAneksit,
PagaDitore=@PagaDitore,
Pershkrimi=@Pershkrimi,
ModifikuarNga=@ModifikuarNga
where IDAneksi=@idaneksi
go
--------------------------------------------------------
create procedure AneksiInsert
@DataEFillimitAneksit date,
@DataEMbarimitAneksit date,
@PagaDitore int,
@Pershkrimi varchar(1000),
@Kontrata int,
@krijuarNga int
as

insert into Aneksi
values
(
@PagaDitore,
@Pershkrimi,
@DataEFillimitAneksit,
@DataEMbarimitAneksit,
@krijuarNga,
null,
@Kontrata,
1
)
go
--------------------------------------------------------

--PROCEDURA PER TerminimiKontrates
--------------------------------------------------------
CREATE procedure insertTerminimiKontrates

@Komenti varchar(200),
@Krijuar_Nga int
as
insert into TerminimiKontrates VALUES(@Komenti, GETDATE(), @Krijuar_Nga)
GO
--------------------------------------------------------
create procedure GetKomentMbiPrishjenEKontrates

@komenti varchar (200)
as
select IDTerminimiKontrates
from terminimiKontrates
where Komenti = @komenti
go
--------------------------------------------------------

create procedure TregoTerminimin
@idkontrata int 
as
select * from TerminimiKontrates 
where IDKontrata = @idkontrata
go

--------------------------------------------------------

--PROCEDURA PER Adrese
--------------------------------------------------------
create procedure AdresaUpdate
@IDAdresa int,
@shteti varchar(255),
@Qyteti varchar(255),
@rruga varchar(255) ,
@numriihyrjes int,
@ModifikuarNga int 
as
update Adresa set
Shteti=@shteti,
Qyteti=@Qyteti,
Rruga=@rruga,
NumriIHyrjes=@numriihyrjes,
@ModifikuarNga=@ModifikuarNga
where IDAdresa=@IDAdresa
go

-------------------------------------------------------
create procedure SearchIDForAdresa
@shteti varchar(50),
@qyteti varchar(50),
@Rruga varchar(50),
@numriHyrjes int 
as
select IDAdresa
from Adresa
where Shteti=@shteti and Qyteti=@qyteti and Rruga=@Rruga and NumriIHyrjes=@numriHyrjes
go
---------------------------------------------------------
create procedure AdresaInsert
@shteti varchar(255),
@Qyteti varchar(255),
@Rruga varchar(255),
@numriihyrjes int,
@KrijuarNga int
as
insert into Adresa values
(
@shteti,
@Qyteti,
@Rruga,
@numriihyrjes,
@KrijuarNga,
null
)
go
--------------------------------------------------------
create procedure adresaDelete
@idadresa int 
as
delete from Adresa where idadresa=@idadresa
go
-------------------------------------------------------
create procedure AdresaSelectByID
@idAdresa int 
as
select * from adresa where idadresa=@idadresa
go
----------------------------------------------------
create procedure selectAllAdresa
as
select * from adresa
go
----------------------------------------------------

-- procedura per Aneks 
----------------------------------------------------
create procedure SelectAllAneksetPerKontraten
@idkontrata int
as
select *from Aneksi
where Kontrata=@idkontrata and aktive=1
go
-----------------------------------------------------	
create procedure MerrAneksetPerKontraten
@idkontrata int 
as
select * from Aneksi 
where kontrata=@idkontrata
go
------------------------------------------------------
create procedure selectAneksiByID
@IDANEKSI int
as
select * from Aneksi where IDAneksi=@IDANEKSI
go

-----------------------------------------------------


--Procedurat per Raporte
----------------------------------------------------
create procedure SelectAllPunetoretForRaporti1
@DepartamentiZgjedhur varchar(30),
@FilialiZgjedhur varchar(30),
@StatusiAktive int

as

Select p.* From Punetori p inner join Departamenti d on p.Departamenti = d.IDDepartamenti
inner join FilialetEPunetorit fep on p.IDPunetori = fep.IDPunetori
inner join Filiali f on fep.IDFiliali = f.IDFiliali
where d.Emri = @DepartamentiZgjedhur and f.emri = @FilialiZgjedhur and (@StatusiAktive = 2 OR p.aktive = @StatusiAktive)

go
----------------------------------------------------
create procedure SelectAllPunetoreForRaportiTerminimiKontrates
@DepartamentiZgjedhur varchar(255),
@FilialiZgjedhur varchar(255),
@Pozita varchar(255),
@dataFillimit date,
@datambarimit date
as
select p.Emri, p.Mbiemri, k.DataESkadimit as 'dataSkadtimit', p.Departamenti
from Punetori p inner join Kontrata k
				on k.Punetori=p.IDPunetori
				inner join FilialetEPunetorit fp
				on p.IDPunetori=fp.IDPunetori
					inner join Filiali f
					on f.IDFiliali=fp.IDFiliali
				inner join Puna pune
				on k.Puna=pune.IDPuna
				

where p.Departamenti=@DepartamentiZgjedhur and f.emri like @FilialiZgjedhur + '%' and pune.Pozita like @Pozita +'%' and k.DataEFillimit=@dataFillimit and k.DataEskadimit=@datambarimit
go


-- PROCEDURAT PER USER
----------------------------------------------------
create procedure UseriSelectsByPunetoriID
@IDPunetori int

as

Select * from PunetoriUser
where IDPunetori = @IDPunetori
go
----------------------------------------------------
----------------------------------------------------

-- PROCEDURAT PER NDERRIM (tabela Nderrimi)
----------------------------------------------------
create procedure Nderrimiinsert
@kohaefillimit time(0),
@kohaembarimit time(0),
@krijuarnga int
as
insert into Nderrimi values (@kohaefillimit,@kohaembarimit,@krijuarnga,null)
go
-------------------------------------------------------
create procedure SelectNderrimiByKontrata 
@idkontrata int
as
select n.*
from nderrimi n inner join kontrata k on n.idnderrimi = k.nderrimi
where k.idkontrata=@idkontrata
go
---------------------------------------------------------
create procedure SelectAllNderrimet
as
select * from Nderrimi
go
--------------------------------------------------------
-------------------------------------------------------

---Procedura per Payrolls (tabela paga)
---------------------------------------------------------
create procedure pagaInsert
@shuma decimal(4,2),
@numriOreveTeRregullta int,
@numriOreveShtese int,
@data date,
@krijuarNga int,
@punetori int
as
insert into paga values(@shuma,@numriOreveTeRregullta,@numriOreveShtese,@data,@krijuarNga,@punetori)
go
------------------------------------------------------------
create procedure SelectPagaByID
@idpaga int 
as 
select * from paga where idpaga=@idpaga 
go
----------------------------------------------------------------
create procedure selectPagatByPunetori
@punetori int 
as
select * from paga where punetori =@punetori 
go
-----------------------------------------------------------------
create procedure SelectPagatPerNjeMuaj
@date date
as
select * from paga
where month(@date) = month (data)
go
-------------------------------------------------------------------