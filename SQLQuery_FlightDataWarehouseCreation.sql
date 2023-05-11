CREATE DATABASE FlightsOnTimeGPT2_DW
GO
Use FlightsOnTimeGPT2_DW
GO
CREATE TABLE Airlines_Dim
(AirlineKey INT NOT NUll IDENTITY,
Airline_code	NCHAR(2),
Airline VARCHAR(MAX),
PRIMARY KEY (AirlineKey));
GO

CREATE TABLE AirportDestination_Dim
(AirportDestinationKey INT NOT NUll IDENTITY,
Airport_name	VARCHAR(MAX),
Airport_code NCHAR(3),
Latitude float,
Longitude float,
Airport_state VARCHAR(MAX),
Airport_country VARCHAR(MAX),
Airport_city VARCHAR(MAX),
PRIMARY KEY (AirportDestinationKey));
GO

CREATE TABLE AirportOrigin_Dim
(AirportOriginKey INT NOT NUll IDENTITY,
Airport_name	VARCHAR(MAX),
Airport_code NCHAR(3),
Latitude float,
Longitude float,
Airport_state VARCHAR(MAX),
Airport_country VARCHAR(MAX),
Airport_city VARCHAR(MAX),
PRIMARY KEY (AirportOriginKey));
GO

CREATE TABLE Calendar_Dim
(
CalendarKey INT NOT NULL IDENTITY,
Year_calendar int,
Day_of_week VARCHAR(20),
Month_calendar	VARCHAR(20),
Day_calendar VARCHAR(5),
Full_date DATE,
PRIMARY KEY (CalendarKey));
GO

CREATE TABLE Delay_Dim
(DelayKey INT NOT NUll IDENTITY,
Delay_ID	NCHAR(1),
Delay_Description NCHAR (50),
PRIMARY KEY (DelayKey));
go

CREATE TABLE OnTimeRecord_Fact
(FlightNumberKey INT NOT NUll IDENTITY,
CalendarKey INT,
AirlineKey INT,
AirportDestinationKey INT,
AirportOriginKey INT,
DelayKey INT,
Flight_number float,
Departure_delay float,
Arrival_delay float,
Delay_minutes float,
PRIMARY KEY(FlightNumberKey, CalendarKey, AirlineKey, AirportDestinationKey, AirportOriginKey, DelayKey),
FOREIGN KEY (Calendarkey) REFERENCES Calendar_Dim (CalendarKey),
FOREIGN KEY (AirlineKey) REFERENCES Airlines_Dim (AirlineKey),
FOREIGN KEY (AirportDestinationkey) REFERENCES AirportDestination_Dim (AirportDestinationKey),
FOREIGN KEY (AirportOriginKey) REFERENCES AirportOrigin_Dim(AirportOriginKey),
FOREIGN KEY (DelayKey) REFERENCES Delay_Dim(DelayKey)
);
GO
--Uncomment the next 2 lines to delete all the data warehouse
--DELETE FROM FlightDelay_Fact;
--go
