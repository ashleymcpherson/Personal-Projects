The following documents the type changes made to tables in the gng-construct.sql file:
* Members: Email is changed from being type char to varchar
* Events: Location is changed from being type char to varchar
* Website: Phase is changed from being type char to varchar

The following changes were made to the dates throughout the entire gng-construct.sql file:
* Campaigns 'Tree Planting', 'Beach Cleanup', 'Climate Change' dates were moved forward a year (ex. 2022 to 2023).
* All Events that correspond to Campaigns 'Tree Planting', 'Beach Cleanup', 'Climate Change' dates were moved forward a year (ex. 2022-2023).
* 'Green Energy' Campaign start and end date was changed so that the campaign had not been completed, as of April 6, 2024. So 2023-05-10 to 2023-07-10 changed to 2024-01-10 to 2024-04-10. Dates for events that correspond to this campaign were also changed to make sense.
* 'Save the Bees' Campaign start and end date was changed so that the campaign had not been completed or in progress, as of April 6, 2024. So 2023-06-01 to 2023-06-02 changed to 2024-04-08 to 2024-04-09. Dates for events that correspond to this campaign were also changed to make sense.


The following changes were made to the Website table in the gng-construct.sql file:
* PublishDate column was deleted and replaced with PublishStatus. PublishStatus tells if that particular Phase has been completed. 

The following changes were made to the Donors and DonatesTo tables in the gng-construct.sql file:
* In Donors, the Date column was removed.
* In DonatesTo, a Date column was added to record when the Donor had donated to a particular campaign.

The following changes were made to the gng-queries.sql file: 
* Query 13 was added to display the state of campaigns and completion status (complete if published).

* In the gng-construct.sql, DonationID in the Donors table was moved to the DonatesTo table. 

* Added views to each query.

* Added 3 queries to display the member history, member annotations, and campaign annotations in gng-queries.sql.

* Created 3 tables holding the data for member history, member annotations, and campaign annotations in gng-construct.sql.

* Added a BirthDate column to the Members table in gng-construct.sql to work with Phase 5.