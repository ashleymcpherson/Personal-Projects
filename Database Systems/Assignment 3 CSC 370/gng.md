## Deliverable B: A set of relations

The following explains how the ER diagram for this assignment is translated into relations:
* Entity sets, indicated by a rectangle, will be a relation.
* Entity set attributes, indicated by a oval, will be the relation attributes.
* Relationships, indicated by a diamond, are relations where the attributes are the keys of the connected entity sets or the attributes of the relationship itself.

The ER diagram has one ISA Hierarchy. The parent is Members, and the children are Volunteers, Employees, and Donors. To create the relations corresponding to the ISA Hierarchy, **ER style** was chosen to create one relation per subclass. 

### The following is the set of relations determined from the ER diagram:
The following relations are translated from entities. The attributes in bold are keys.
* Members(**MemberID**, Name, PhoneNumber, Email)
* Volunteers(**MemberID**, Tier)
* Employees(**MemberID**, Salary, Job)
* Donors(**MemberID**, DonationID, DonationAmount, Date)
* Campaigns(**CampaignID**, Name, StartDate, EndDate, Budget, AmountSpent)
* Events(**EventID**, Name, Type, Location, Date, CashFlow)
* Website(**ContentID**, Phase, PublishDate)

The following relations are translated from relationships. The attributes in italics are foreign keys.
* Helps(*VolunteerID*, *EventID*)
* Manages(*EmployeeID*, *CampaignID*)
* DonatesTo(*DonorID*, *CampaignID*)
* Plans(*CampaignID*, *EventID*)
* Monitors(*CampaignID*, *ContentID*)
