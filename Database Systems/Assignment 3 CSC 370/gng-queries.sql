--Question 1: Which campaigns spent more than their budget?
create view CampaignSpentMoreThanBudget as
    select Name, Budget, AmountSpent
    from Campaigns
    where AmountSpent > Budget;


--Question 2: How many volunteers participated in each event?
create view VolunteersParticipatedEvents as
    select e.Name as EventName, count(distinct h.VolunteerID) as NumberOfVolunteers
    from Events e
    join Helps h on e.EventID = h.EventID
    group by e.Name
    order by NumberOfVolunteers desc;


--Question 3: List the campaigns with the most events to the least events, in order.
create view CampaignsWithMostEvents as
    select c.Name as CampaignName, count(e.EventID) as NumberOfEvents
    from Campaigns c
    join Plans p on c.CampaignID = p.CampaignID
    join Events e on p.EventID = e.EventID
    group by c.Name
    order by NumberOfEvents desc;


--Question 4: Show the total income and total expenses across all events.
create view TotalIncomeTotalExpensesEvents as
    select Type, sum(CashFlow) as TotalCashFlow
    from Events
    group by Type;


--Question 5: What is the total donation amount each campaign receives from donors?
create view TotalDonationEachCampaign as
    select c.Name as CampaignName, sum(d.DonationAmount) as TotalDonations
    from Campaigns c
    left outer join DonatesTo donates on c.CampaignID = donates.CampaignID
    left outer join Donors d on donates.DonorID = d.MemberID
    group by c.Name;


--Question 6: Identify the volunteers who have participated in the 'Tree Planting' and 'Beach Cleanup' campaigns.
create view VolunteersInTreePlantingBeachCleanup as
    select distinct m.Name
    from Members m
    join Volunteers v on m.MemberID = v.MemberID
    join Helps h on v.MemberID = h.VolunteerID
    join Events e on h.EventID = e.EventID
    join Plans p on e.EventID = p.EventID
    where p.CampaignID in (
        select CampaignID
        from Campaigns
        where Name = 'Tree Planting'
    )
    intersect
    select distinct m.Name
    from Members m
    join Volunteers v on m.MemberID = v.MemberID
    join Helps h on v.MemberID = h.VolunteerID
    join Events e on h.EventID = e.EventID
    join Plans p on e.EventID = p.EventID
    where p.CampaignID in (
        select CampaignID
        from Campaigns
        where Name = 'Beach Cleanup'
    );


--Question 7: Which campaigns have not received donations?
create view CampaignsNoDonations as
    select c.Name as CampaignName
    from Campaigns c
    where not exists (
        select 1
        from DonatesTo dt
        where dt.CampaignID = c.CampaignID
    );


--Question 8: Which members have volunteered and donated?
create view MembersAreVolunteersAndDonors as
    select m.Name
    from Members m
    where exists (
        select 1
        from Volunteers v
        where v.MemberID = m.MemberID)
    and exists (
        select 1
        from Donors d where d.MemberID = m.MemberID);


--Question 9: On average, how much money has each donor donated?
create view AverageDonorDonation as
    select MemberID, avg(DonationAmount) as AverageDonation
    from Donors
    group by MemberID;


--Question 10: Determine the number of campaigns each volunteer has participated in, along with their volunteer tier.
create view NumberOfCampaignsVolunteersParticipated as
    select v.MemberID, m.Name as VolunteerName, v.Tier as Tier, count(distinct p.CampaignID) as NumberOfCampaigns
    from Volunteers v
    join Members m on v.MemberID = m.MemberID
    left outer join Helps h on v.MemberID = h.VolunteerID
    left outer join Events e on h.EventID = e.EventID
    left outer join Plans p on e.EventID = p.EventID
    group by v.MemberID, m.Name, v.Tier
    order by NumberOfCampaigns desc, Tier;


--Question 11: How much website content has been published for each campaign?
create view HowMuchWebsiteContentPublished as
    select c.Name as CampaignName, count(distinct w.ContentID) as NumberofContentOutputs
    from Campaigns c
    left outer join Monitors m on c.CampaignID = m.CampaignID
    left outer join Website w on m.ContentID = w.ContentID
    group by c.Name
    order by NumberOfContentOutputs desc;


--Question 12: What are the names of the members who are not volunteers, employees, or donors?
create view NotVolunteerEmployeeDonor as
    select m.Name as NotVolunteerEmployeeDonor
    from Members m
    where not exists (
        select 1 from Volunteers v where v.MemberID = m.MemberID
    )
    and not exists (
        select 1 from Employees e where e.MemberID = m.MemberID
    )
    and not exists (
        select 1 from Donors d where d.MemberID = m.MemberID
    );


--Question 13: Display the state of campaigns and completion status (complete if published).
create view CampaignStateCompletionStatus as
    select c.Name as CampaignName, w.Phase as CampaignState, w.PublishStatus as PublishStatus
    from Campaigns c
    join Monitors m on c.CampaignID = m.CampaignID
    join Website w on m.ContentID = w.ContentID
    order by c.CampaignID;


--Question 14: Display Member History with Participation Details
create or replace view ViewMemberParticipationHistory as
    select 
        m.Name as MemberName, 
        c.Name as CampaignName, 
        e.Name as EventName, 
        mh.ParticipationDate, 
        mh.ParticipationType
    from MemberParticipationHistory mh
    join Members m on mh.MemberID = m.MemberID
    left join Campaigns c on mh.CampaignID = c.CampaignID
    left join Events e on mh.EventID = e.EventID;


--Question 15: Display Annotations for Member Activities
create view MemberActivityAnnotationsDisplay as
    select 
        m.Name as MemberName, 
        maa.AnnotationText, 
        maa.CreatedAt
    from MemberActivityAnnotations maa
    join Members m on maa.MemberID = m.MemberID;


--Question 16: Display Annotations for Campaigns
create view CampaignAnnotationsDisplay as
    select 
        c.Name as CampaignName, 
        ca.AnnotationText, 
        ca.CreatedAt
    from CampaignAnnotations ca
    join Campaigns c on ca.CampaignID = c.CampaignID;
