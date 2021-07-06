--create database HRManagment

create table Departamenti (
IDDepartamenti int identity(1,1) PRIMARY KEY,
Emri varchar(30) NOT NULL,
DataERegjistrimit date NOT NULL,
aktive bit NOT NULL default 1
)
create table Punetori(
IDPunetori int IDENTITY(10000,1) PRIMARY KEY,
Emri varchar(20) NOT NULL,
Mbiemri varchar(20) NOT NULL,
Email varchar(30) NOT NULL,
Gjinia varchar(1) NOT NULL,
KrijuarNga int foreign key references Punetori(IDPunetori),
ModifikuarNga int foreign key references Punetori(IDPunetori),
Departamenti int foreign key references Departamenti(IDDepartamenti), -- Ne heren e pare duhet te jete NULL,pastaj shkon e krijon nje Departamentet(per arsye te konfliktit mes dy tabelave).
IDLeternjoftimi bigint NOT NULL,
Datlindja date NOT NULL,
Mosha as datediff(year,Datlindja,CONVERT(date, getdate())), --Llogarit vjetet
DataERegjistrimit date NOT NULL,
aktive bit NOT NULL default 1
)

create table Mesazhi(
	IDMesazhi int IDENTITY(1,1) PRIMARY KEY,
	Emri varchar(20) NOT NULL,
	Mbiemri varchar(20) NOT NULL,
	Email varchar(30) NOT NULL,
	Teksti varchar(1000) NOT NULL,
	DataEKrijimit datetime NOT NULL,
	Checked varchar(2) Not null default 'jo'
)

create table Adresa(
IDAdresa int IDENTITY(1,1) PRIMARY KEY,
Shteti varchar(20) NOT NULL,
Qyteti varchar(20)NOT NULL,
Rruga varchar(30)NOT NULL,
NumriIHyrjes int NOT NULL,
KrijuarNga int not null foreign key references Punetori(idpunetori),
ModifikuarNga int foreign key references Punetori(idpunetori)
)

create table PunetoriKontakt (
IDPunetoriKontakt int identity(1,1) primary key,
NumriTelefonit varchar(20) NOT NULL,
Punetori int not null foreign key references Punetori(IDPunetori),
KrijuarNga int not null foreign key references Punetori(IDPunetori)
)

create table UserGroup(
Prioriteti int NOT NULL primary key,
)

--Aksesi per punetore te thjeshte
insert into UserGroup VALUES(1)
--Aksesi per Menaxher
insert into UserGroup VALUES(2)
--Aksesi per HR-Punetore
insert into UserGroup VALUES(3)
--Aksesi per Recepsionist
insert into UserGroup VALUES(4)
--Aksesi per pr
insert into UserGroup VALUES(5)

-- Te dhenat per qasje ne sistem dhe ka si foreign key te dhenat e punetorit
create table PunetoriUser(
UserID int identity(1,1)PRIMARY KEY,
IDPunetori int not null foreign key references Punetori(IDPunetori),
Fjalekalimi nvarchar(200) NOT NULL,
UserGroup int not null foreign key references UserGroup(prioriteti)
)

create table Filiali (
IDFiliali int identity(1,1) PRIMARY KEY,
emri varchar(30) not null,
Adresa int foreign key references Adresa(IDAdresa),
numrikontaktues varchar(20) not null,
email varchar(30) not null,
zyre int not null,
krijuarnga int not null foreign key references Punetori(IDPunetori),
modifikuarnga int foreign key references Punetori(IDPunetori),
DataERegjistrimit date NOT NULL,
aktive bit NOT NULL default 1
)

-- Filialet e secilit Punetore (shume me shume filiali me puentore)
create table FilialetEPunetorit (
IDFEP int identity(1,1) PRIMARY KEY,
IDFiliali int foreign key references Filiali(IDFiliali),
IDPunetori int foreign key references Punetori(IDPunetori),
DataERegjistrimit date NOT NULL
)

create table DepartamentetEFilialit (
IDDEF int identity(1,1) PRIMARY KEY,
IDFiliali int NOT NULL foreign key references Filiali(IDFiliali),
IDDepartamenti int NOT NULL foreign key references Departamenti(IDDepartamenti),
DataERegjistrimit date NOT NULL
)

create table Verejtje(
IDVrejtja int identity(1,1) PRIMARY KEY,
Data date not null,
Pershkrimi varchar(255) not null,
KrijuarNga varchar(20) not null,
Punetori int not null foreign key references punetori(IDPunetori),
DataERegjistrimit date NOT NULL
)

create table Puna (
IDPuna int identity(1,1) PRIMARY KEY,
Pozita varchar(30) NOT NULL,
KrijuarNga int NOT NULL foreign key references Punetori(IDPunetori),
DataERegjistrimit date NOT NULL,
Departamenti int NOT NULL foreign key references Departamenti(IDDepartamenti),
aktive bit NOT NULL default 1
)

create table Pjesemarrja(
IDPjesemarrja int identity(1,1) PRIMARY KEY,
Data date not null,
KohaEFillimit time(0) not null,
KohaEMbarimit time(0),
OretEMbajtura as (datediff(hour,KohaEFillimit,KohaEMbarimit)),
Punetori int NOT NULL foreign key references Punetori(IDPunetori),
KrijuarNga int NOT NULL foreign key references Punetori(IDPunetori),
ModifikuarNga int foreign key references Punetori(IDPunetori)
)

create table HyrjeDalje (
IDHyrjeDalje int identity(1,1) primary key,
Dalja time(0) not null,
Kthimi time(0),
IDPjesemarrja int not null foreign key references Pjesemarrja(IDPjesemarrja),
KrijuarNga int NOT NULL foreign key references Punetori(IDPunetori),
ModifikuarNga int foreign key references Punetori(IDPunetori)
)

create table TerminimiKontrates(
IDTerminimiKontrates int IDENTITY(1,1) PRIMARY KEY,
Komenti varchar(200) NOT NULL,
Data date not null,
krijuarnga int not null foreign key references Punetori(idpunetori)
)
create table Nderrimi
(
IDNderrimi int identity(1,1) not null primary key,
KohaFillimit time(0) not null,
KohaEMbarimit time(0) not null,
KrijuarNga int not null foreign key references Punetori(IDPunetori),
ModifikuarNga int null foreign key references Punetori(IDPunetori)
)

create table Kontrata(
IDKontrata int IDENTITY(1,1) PRIMARY KEY NOT NULL,
DataEFillimit date NOT NULL,
DataESkadimit date NOT NULL,
Pauza int not null,
ParaJavetELeshimit int NOT NULL, -- Sa jave duhet te lajmroje para leshimit te punes.
LeshuarNga int NOT NULL foreign key references Punetori(IDPunetori),
Punetori int NOT NULL foreign key references Punetori(IDPunetori),
TerminimiKontrates int foreign key references TerminimiKontrates(IDTerminimiKontrates),
DataERegjistrimit date NOT NULL,
PagaPerOre int NOT NULL,
OretEPunesDitore int NOT NULL, -- Oret e punes ditore
DitetJavore int NOT NULL,
PerqindjaEBonusOreve decimal(4,2) NOT NULL, -- Sa % paguhet oret shtese e punetorit
Nderrimi int not null foreign key references Nderrimi(idnderrimi),
Puna int NOT NULL foreign key references Puna(IDPuna),
OretEPunesJavore as (DitetJavore * OretEPunesDitore), --Oret e punes javore
aktive bit NOT NULL default 1,
ModifikuarNga int null foreign key references Punetori(idpunetori)
)
create table Aneksi
(
IDAneksi int identity(1,1) primary key not null,
PagaDitore int not null,
Pershkrimi varchar(1000) not null,
DataFillimit date not null,
DataSkadimit date not null,
KrijuarNga int not null foreign key references punetori(idpunetori),
ModifikuarNga int null foreign key references Punetori(idPunetori),
Kontrata int not null foreign key references kontrata(idkontrata),
aktive bit not null default 1
)

create table Paga
(
idpaga int identity(1,1) not null primary key,
shuma decimal (4,2) not null,
numriOreveTeRregullta int not null,
numriOreveShtese int not null,
data date not null,
krijuarNga int not null foreign key references punetori(idpunetori),
punetori int not null foreign key references punetori(idpunetori)
)


-- Insertimi i disa referencave te Punetorit tek Departamentit sepse po behet infinite loop nese i insertojme per njehere te dyjat tabela
alter table Departamenti ADD Menaxheri int foreign key references Punetori(IDPunetori)
alter table Departamenti ADD KrijuarNga int NOT NULL foreign key references Punetori(IDPunetori)
alter table Departamenti ADD ModifikuarNga int foreign key references Punetori(IDPunetori)


-- Insertimi i disa referencave te tek Punetori sepse po behet infinite loop nese i insertojme per njehere te dyjat tabela
alter table Punetori ADD Adresa int foreign key references Adresa(IDAdresa)