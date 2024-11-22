drop view if exists CampaignSpentMoreThanBudget, VolunteersParticipatedEvents, CampaignsWithMostEvents, TotalIncomeTotalExpensesEvents, TotalDonationEachCampaign, VolunteersInTreePlantingBeachCleanup, CampaignsNoDonations, MembersAreVolunteersAndDonors, AverageDonorDonation, NumberOfCampaignsVolunteersParticipated, HowMuchWebsiteContentPublished, NotVolunteerEmployeeDonor, CampaignStateCompletionStatus, MemberParticipationHistory, MemberActivityAnnotationsDisplay, CampaignAnnotationsDisplay cascade;

drop table if exists Members, Volunteers, Employees, Donors, Campaigns, Events, Website, Helps, Manages, DonatesTo, Plans, Monitors, MemberParticipationHistory, MemberActivityAnnotations, CampaignAnnotations cascade;

-- Members --
create table Members (
    MemberID INT primary key,
    Name char(50),
    PhoneNumber varchar(15),
    Email char(70),
    Birthdate DATE
);

insert into Members (MemberID, Name, PhoneNumber, Email, Birthdate) values
    (1, 'Ashley McPherson', '403-123-4567', 'ashleymcpherson@gmail.com', '1990-05-21'),
    (2, 'Bob Smith', '403-234-5677', 'bobsmith@gmail.com', '1985-08-04'),
    (3, 'Tim Timmy', '403-345-5678', 'timtimmy@gmail.com', '1972-11-12'),
    (4, 'Daisy Rose', '403-456-7899', 'daisyrose@gmail.com', '1999-02-09'),
    (5, 'Amy Thomas', '403-567-8910', 'amythomas@gmail.com', '1995-07-18'),
    (6, 'Will Power', '587-777-1292', 'willpower@gmail.com', '1980-01-25'),
    (7, 'Steve Hart', '587-126-1298', 'stevehart@gmail.com', '1965-03-30'),
    (8, 'Elisabeth Green', '342-384-1238', 'elisabethgreen@gmail.com', '1988-09-15'),
    (9, 'Emma Blue', '342-458-3940', 'emmablue@gmail.com', '2001-12-22'),
    (10, 'Ella Anderson', '500-232-1000', 'ellaanderson@gmail.com', '1993-04-08'),
    (11, 'Ben Wilson', '343-1232-3490', 'benwilson@gmail.com', '1978-06-05'),
    (12, 'Jim Johnson', '543-219-1232', 'jimjohnson@gmail.com', '1969-10-17'),
    (13, 'Joe Jones', '342-129-2399', 'joejones@gmail.com', '2003-08-28'),
    (14, 'Sarah White', '604-454-9877', 'sarahwhite@gmail.com', '1987-01-19'),
    (15, 'Jess Lopez', '394-565-4954', 'jesslopez@gmail.com', '1992-03-03'),
    (16, 'Mario Thompson', '596-343-2392', 'mariothompson@gmail.com', '1982-07-24'),
    (17, 'Julia Jules', '322-968-0000', 'juliajules@gmail.com', '1996-05-15');



-- Volunteers --
create table Volunteers (
    MemberID INT primary key,
    Tier INT,
    foreign key (MemberID) references Members(MemberID)
);

insert into Volunteers (MemberID, Tier) values
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 1),
    (5, 2),
    (6, 2),
    (7, 2);


-- Employees --
create table Employees (
    MemberID INT primary key,
    Salary DECIMAL,
    Job char(70),
    foreign key (MemberID) references Members(MemberID)
);

insert into Employees (MemberID, Salary, Job) values
    (8, 25000.00, 'Manager'),
    (9, 10000.00, 'Planner'),
    (10, 30000.00, 'Fundraiser');


-- Donors --
create table Donors (
    MemberID INT primary key,
    DonationAmount DECIMAL,
    foreign key (MemberID) references Members(MemberID)
);

insert into Donors (MemberID, DonationAmount) values
    (11, 1000.00),
    (12, 400.00),
    (13, 20000.00),
    (14, 900.00),
    (1, 2300.00),
    (2, 1000.00),
    (15, 1000.00),
    (3, 25000.00);
    

-- Campaigns --
create table Campaigns (
    CampaignID INT primary key,
    Name char(50),
    StartDate DATE,
    EndDate DATE,
    Budget DECIMAL,
    AmountSpent DECIMAL
);

insert into Campaigns (CampaignID, Name, StartDate, EndDate, Budget, AmountSpent) values
    (1, 'Tree Planting', '2023-01-01', '2023-01-04', 80.00, 80.00),
    (2, 'Beach Cleanup', '2023-04-05', '2023-04-08', 70.00, 75.00),
    (3, 'Climate Change', '2023-09-20', '2023-10-20', 300.00, 250.00),
    (4, 'Green Energy', '2024-01-10', '2024-04-10', 1000.00, 1000.00),
    (5, 'Save the Bees', '2024-04-08', '2024-04-09', 200.00, 200.00);
    

-- Events --
create table Events (
    EventID INT primary key,
    Name char(50),
    Type char(50),
    Location char(50),
    Date DATE,
    CashFlow DECIMAL
);

insert into Events (EventID, Name, Type, Location, Date, CashFlow) values
    (1, 'Kick Off Tree Planting', 'Awareness Event', 'Sidney',  '2023-01-01', -20.00),
    (2, 'Educational Workshop on Reforestation', 'Awareness Event', 'Sidney', '2023-01-02', -50.00),
    (3, 'Plant Some Trees', 'Awareness Event', 'Central Saanich', '2023-01-03', -10.00),
    (4, 'Fundraiser for More Campaigns Like This!', 'Fundraising Event', 'Sidney', '2023-01-04', 10.00),
    (5, 'Clean Up the Beach!', 'Awareness Event', 'Tofino', '2023-04-05', -30.00),
    (6, 'Workshop on Marine Pollution', 'Awareness Event', 'Tofino', '2023-04-08', -45.00),
    (7, 'Expert Panel Discussion on Climate Change', 'Awareness Event', 'Victoria', '2023-09-20', -100.00),
    (8, 'Sustainable Living Workshop', 'Awareness Event', 'Victoria', '2023-09-30', -100.00),
    (9, 'Climate March', 'Awareness Event', 'Victoria', '2023-10-10', -50.00),
    (10, 'Fundraiser for More Campaigns Like This!', 'Fundraising Event', 'Victoria', '2023-10-20', 20.00),
    (11, 'Expert Panel Discussion on Electric Cars', 'Awareness Event', 'Esquimalt', '2024-01-12', -200.00),
    (12, 'Green Energy in Schools Discussion', 'Awareness Event', 'Esquimalt', '2024-01-30', -200.00),
    (13, 'Green Energy Fair!', 'Awareness Event', 'Esquimalt', '2024-02-15', -600.00),
    (14, 'GnG Fundraiser at the Green Energy Fair', 'Fundraising Event', 'Esquimalt', '2024-03-03', 100.00),
    (15, 'Learn from Honey Farmers', 'Awareness Event', 'Nanaimo', '2024-04-08', -200.00);


-- Website --
create table Website (
    ContentID INT primary key,
    Phase char(50),
    PublishStatus char(50)
);

insert into Website (ContentID, Phase, PublishStatus) values
    (1, 'Organizing Campaign', 'Published'),
    (2, 'Campaign in Progress', 'Published'),
    (3, 'Campaign Completed', 'Published'),
    (4, 'Organizing Campaign', 'Published'),
    (5, 'Campaign in Progress', 'Not Published'),
    (6, 'Campaign Completed', 'Published'),
    (7, 'Organizing Campaign', 'Published'),
    (8, 'Campaign in Progress', 'Published'),
    (9, 'Campaign Completed', 'Not Published'),
    (10, 'Organizing Campaign', 'Published'),
    (11, 'Campaign in Progress', 'Published'),
    (12, 'Campaign Completed', 'Published'),
    (13, 'Organizing Campaign', 'Published'),
    (14, 'Campaign in Progress', 'Published'),
    (15, 'Campaign Completed', 'Not Published');


-- Helps: representing a many-to-many relationship for Volunteers to Events --
create table Helps (
    VolunteerID INT,
    EventID INT,
    primary key (VolunteerID, EventID),
    foreign key (VolunteerID) references Volunteers(MemberID),
    foreign key (EventID) references Events(EventID)
);

insert into Helps (VolunteerID, EventID) values
    (1, 1),
    (1, 2),
    (2, 3),
    (2, 5),
    (3, 5),
    (3, 4),
    (4, 1),
    (5, 5),
    (5, 8),
    (6, 9),
    (6, 11),
    (7, 11),
    (7, 12),
    (1, 13),
    (2, 14),
    (3, 15),
    (4, 2),
    (5, 3),
    (6, 5),
    (1, 7);
    

-- Manages: represents a one-to-many relationship for Employees to Campaigns --
create table Manages (
    EmployeeID INT,
    CampaignID INT,
    primary key (EmployeeID, CampaignID),
    foreign key (EmployeeID) references Employees(MemberID),
    foreign key (CampaignID) references Campaigns(CampaignID)
);

insert into Manages (EmployeeID, CampaignID) values
    (8, 1),
    (9, 2),
    (10, 3),
    (8, 4),
    (9, 5);


-- DonatesTo: represents a many-to-many relationship for Donors to Campaigns --
create table DonatesTo (
    DonationID INT,
    DonorID INT,
    CampaignID INT,
    DonationDate DATE,
    primary key (DonationID, DonorID, CampaignID),
    foreign key (DonorID) references Donors(MemberID),
    foreign key (CampaignID) references Campaigns(CampaignID)
);

insert into DonatesTo (DonationID, DonorID, CampaignID, DonationDate) values
    (1, 11, 1, '2023-01-01'),
    (2, 12, 1, '2022-12-30'),
    (3, 13, 2, '2023-04-05'),
    (4, 14, 2, '2023-04-01'),
    (5, 15, 3, '2023-09-20'),
    (6, 11, 3, '2023-09-19'),
    (7, 13, 4, '2024-01-10'),
    (8, 14, 4, '2024-01-11'),
    (9, 1, 1, '2023-01-02'),
    (10, 11, 4, '2024-01-10'),
    (11, 12, 3, '2023-09-18'),
    (12, 15, 2, '2023-04-03'),
    (13, 2, 1, '2023-01-02');


-- Plans: represents a one-to-many relationship for Campaigns to Events --
create table Plans (
    CampaignID INT,
    EventID INT,
    primary key (CampaignID, EventID),
    foreign key (CampaignID) references Campaigns(CampaignID),
    foreign key (EventID) references Events(EventID)
);

insert into Plans (CampaignID, EventID) values
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (2, 5),
    (2, 6),
    (3, 7),
    (3, 8),
    (3, 9),
    (3, 10),
    (4, 11),
    (4, 12),
    (4, 13),
    (4, 14),
    (5, 15);


-- Monitors: represents a one-to-many relationship for Website to Campaigns --
create table Monitors (
    CampaignID INT,
    ContentID INT,
    primary key (CampaignID, ContentID),
    foreign key (CampaignID) references Campaigns(CampaignID),
    foreign key (ContentID) references Website(ContentID)
);

insert into Monitors (CampaignID, ContentID) values
    (1, 1), 
    (2, 2), 
    (3, 3), 
    (4, 4), 
    (5, 5),
    (1, 6), 
    (2, 7), 
    (3, 8), 
    (4, 9), 
    (5, 10),
    (1, 11),
    (2, 12),
    (3, 13),
    (4, 14),
    (5, 15);
 

create table MemberParticipationHistory (
    MemberHistoryID SERIAL primary key,
    MemberID INT NOT NULL,
    CampaignID INT,
    EventID INT,
    ParticipationDate DATE,
    ParticipationType varchar(255),
    foreign key (MemberID) references Members(MemberID),
    foreign key (CampaignID) references Campaigns(CampaignID),
    foreign key (EventID) references Events(EventID)
);

insert into MemberParticipationHistory (MemberID, CampaignID, EventID, ParticipationDate, ParticipationType) values
    (1, 1, 1, '2023-01-01', 'Volunteering'),
    (2, 2, 5, '2023-04-05', 'Volunteering'),
    (3, 3, 9, '2024-01-12', 'Working'),
    (4, 4, 13, '2023-09-20', 'Working'),
    (5, 5, NULL, '2023-01-03', 'Donating'),
    (6, 1, NULL, '2023-04-06', 'Donating'),
    (7, 2, NULL, '2023-09-21', 'Donating'),
    (8, 3, 10, '2024-02-15', 'Volunteering'),
    (9, 4, 14, '2024-04-08', 'Working'),
    (10, 5, 15, '2024-01-04', 'Volunteering');


create table MemberActivityAnnotations (
    AnnotationID SERIAL primary key,
    MemberID INT NOT NULL,
    AnnotationText TEXT NOT NULL,
    CreatedAt timestamp default CURRENT_TIMESTAMP,
    foreign key (MemberID) references Members(MemberID)
);

insert into MemberActivityAnnotations (MemberID, AnnotationText) values
    (1, 'Outstanding Volunteer Effort at Tree Planting Event'),
    (2, 'Reached 100 Hours of Volunteering'),
    (3, 'Highly praised for their commitment to Green Energy'),
    (4, 'Shared valuable insights on Climate Change Panel'),
    (5, 'First-time donor, contributed significantly');


create table CampaignAnnotations (
    CampaignAnnotationID SERIAL primary key,
    CampaignID INT NOT NULL,
    AnnotationText TEXT NOT NULL,
    CreatedAt timestamp default CURRENT_TIMESTAMP,
    foreign key (CampaignID) references Campaigns(CampaignID)
);

insert into CampaignAnnotations (CampaignID, AnnotationText) values
    (1, 'Surpassed tree planting goal by 150%'),
    (2, 'Most community-engaged event of the year'),
    (3, 'Notable media coverage on climate change awareness'),
    (4, 'Exceeded fundraising target by $20,000'),
    (5, 'Initiated a long-term partnership with local beekeepers');
 