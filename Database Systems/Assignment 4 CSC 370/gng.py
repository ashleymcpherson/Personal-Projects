#!/usr/bin/env python3

import psycopg2

def executing_query(cursor, query):
    """
    Executes a query from the provided cursor and returns the results.
    """
    try:
        cursor.execute(query)
        return cursor.fetchall()
    except Exception as e:
        print(f"Error: {e}")
        cursor.connection.rollback()
        return []
    
    
def print_as_table(results, column_headers):
    """
    Implements the table format when displaying the GnG information.
    """
    if not results:
        print("No data to display.")
        return
    
    col_widths = [max(len(str(value)) for value in column) for column in zip(*results, column_headers)]
    row_format = " | ".join(["{:<" + str(width) + "}" for width in col_widths])
    
    print(row_format.format(*column_headers))
    print("-" * sum(col_widths) + "---" * (len(col_widths) - 1))
    for row in results:
        print(row_format.format(*[str(item) for item in row]))


def view_existing_queries(cursor):
    """
    Allows the user to select from predefined queries and view their results.
    """
    while True:
            # All GnG information options
            print("\nSelect a query to execute (or type 'exit' to quit):")
            print("1: Campaigns that spent more than their budget.")
            print("2: Number of volunteers that participated in each event.")
            print("3: Campaigns ordered by the number of events (greatest to least).")
            print("4: Total income and total expenses across all events.")
            print("5: Total donation amount each campaign receives.")
            print("6: Volunteers that have participated in both 'Tree Planting' and 'Beach Cleanup' campaigns.")
            print("7: Campaigns without any donations.")
            print("8: Members who have volunteered and donated.")
            print("9: Average donation amount by each donor.")
            print("10: Number of campaigns each volunteer has participated in, along with their volunteer tier.")
            print("11: Amount of website content published for each campaign.")
            print("12: Members who are not volunteers, employees, or donors.")
            print("13: State of campaigns and completion status (complete if published).")
            print("14: Display member history with participation details.")
            print("15: Display annotations for memory activity.")
            print("16: Display annotations for campaigns.")

            user_choice = input("Your choice: ")
            if user_choice.lower() == 'exit':
                break

            # All the queries from Assignment 3
            queries = {
                '1': ("""select * from CampaignSpentMoreThanBudget;""",
                        ['Name', 'Budget', 'Amount Spent']),
                
                '2': ("""select * from VolunteersParticipatedEvents;""",
                        ['Event Name', 'Number of Volunteers']),
                
                '3': ("""select * from CampaignsWithMostEvents;""",
                        ['Campaign Name', 'Number of Events']),
                
                '4': ("""select * from TotalIncomeTotalExpensesEvents;""",
                        ['Type of Income', 'Total Cash-Flow']),
                
                '5': ("""select * from TotalDonationEachCampaign;""",
                        ['Campaign Name', "Total Donations"]),

                '6': ("""select * from VolunteersInTreePlantingBeachCleanup;""",
                        ['Name']),

                '7': ("""select * from CampaignsNoDonations;""",
                        ['Campaign Name']),

                '8': ("""select * from MembersAreVolunteersAndDonors;""",
                        ['Name']),

                '9': ("""select * from AverageDonorDonation;""",
                        ['Member ID', 'Average Donation']),

                '10': ("""select * from NumberOfCampaignsVolunteersParticipated;""",
                        ['Member ID', 'Volunteer Name', 'Tier', 'Number of Campaigns']),

                '11': ("""select * from HowMuchWebsiteContentPublished;""",
                        ['Campaign Name', 'Number of Content Outputs']),

                '12': ("""select * from NotVolunteerEmployeeDonor;""",
                        ['Member Name']),

                '13': ("""select * from CampaignStateCompletionStatus;""",
                        ['Campaign Name', 'Campaign State', 'Publish Status']),

                '14': ("""select * from MemberParticipationHistory;""",
                       ['Member History ID', 'Member ID', 'Campaign ID', 'Event ID', 'Participation Date', 'Participation Type']),

                '15': ("""select * from MemberActivityAnnotationsDisplay;""",
                       ['Member Activity Annotation ID', 'Member ID', 'Annotation Text', 'Created At']),

                '16': ("""select * from CampaignAnnotationsDisplay;""",
                       ['Campaign Annotation ID', 'Campaign ID', 'Annotation Text', 'CreatedAt']),
            }

            if user_choice in queries:
                query, headers = queries[user_choice]
                results = executing_query(cursor, query)
                print_as_table(results, headers)
            else:
                print("Invalid choice, try again")


def setup_campaign(cursor):
    """
    Sets up a new campaign by prompting the user for campaign details and inserting them into the database.
    """
    print("Enter the details for the new campaign:")

    cursor.execute("SELECT MAX(CampaignID) FROM Campaigns")
    max_campaign_id = cursor.fetchone()
    campaign_id = (max_campaign_id[0] or 0) + 1 # Start at 1 if the table is empty

    # User will fill the following information
    name = input("Campaign Name: ")
    start_date = input("Start Date (YYYY-MM-DD): ")
    end_date = input("End Date (YYYY-MM-DD): ")
    budget = input("Budget: ")
    amount_spent = input("Projected Amount Spent: ")

    # Insert into Campaigns table
    cursor.execute("INSERT INTO Campaigns (CampaignID, Name, StartDate, EndDate, Budget, AmountSpent) VALUES (%s, %s, %s, %s, %s, %s)", (campaign_id, name, start_date, end_date, budget, amount_spent))

    # Determine the next ContentID to use
    cursor.execute("SELECT MAX(ContentID) FROM Website")
    max_content_id_result = cursor.fetchone()
    max_content_id = max_content_id_result[0] if max_content_id_result[0] is not None else 0

    # Insert new website content phases for the campaign
    phases = ['Organizing Campaign', 'Campaign in Progress', 'Campaign Completed']
    publish_statuses = ['Published', 'Not Published', 'Not Published']
    for i, (phase, status) in enumerate(zip(phases, publish_statuses), start=1):
        content_id = max_content_id + i
        cursor.execute("INSERT INTO Website (ContentID, Phase, PublishStatus) VALUES (%s, %s, %s)", (content_id, phase, status))
        cursor.execute("INSERT INTO Monitors (CampaignID, ContentID) VALUES (%s, %s)", (campaign_id, content_id))

    cursor.connection.commit()
    print("Campaign successfully created!")
    return campaign_id


def schedule_event(cursor, campaign_id):
    """
    Schedules an event for a campaign by prompting the user for event details and inserting them into the database.
    """

    print("Enter the details for the new event:")

    cursor.execute("SELECT MAX(EventID) FROM Events")
    max_event_id = cursor.fetchone()
    event_id = (max_event_id[0] or 0) + 1 # Start at 1 if table is empty

    # User will be prompted to fill in the following information:
    name = input("Event Name: ")
    event_type = input("Event Type (Awareness Event/Fundraising Event): ")
    location = input("Location (City): ")
    event_date = input("Event Date (YYYY-MM-DD): ")
    cash_flow = input("Cash Flow: ")

    cursor.execute("INSERT INTO Events (EventID, Name, Type, Location, Date, CashFlow) VALUES (%s, %s, %s, %s, %s, %s)""", (event_id, name, event_type, location, event_date, cash_flow))
    cursor.execute("INSERT INTO Plans (CampaignID, EventID) VALUES (%s, %s)""", (campaign_id, event_id))
    cursor.connection.commit()
    print("Event successfully scheduled for this campaign!")


def fetch_events(cursor, campaign_id):
    """
    Fetches and returns a list of events from the database for the specified campaign.
    """
    cursor.execute("SELECT Events.EventID, Events.Name FROM Events JOIN Plans ON Events.EventID = Plans.EventID WHERE Plans.CampaignID = %s", (campaign_id,))
    return cursor.fetchall()


def register_member(cursor, campaign_id):
    """
    Registers a new or existing member as a volunteer, employee, or donor to the campaign.
    Allows adding the member to multiple roles (volunteer, employee, donor), one at a time.
    """
    member_id = input("Enter Member ID (or press Enter to generate a register as a new member): ")

    if member_id.strip() == "":
        # Generate a new MemberID
        cursor.execute("SELECT MAX(MemberID) FROM Members")
        max_member_id = cursor.fetchone()
        member_id = (max_member_id[0] or 0) + 1  # Start at 1 if table is empty
        name = input("Enter Name: ")
        phone_number = input("Enter Phone Number: ")
        email = input("Enter Email: ")

        # Insert the new member
        cursor.execute("INSERT INTO Members (MemberID, Name, PhoneNumber, Email) VALUES (%s, %s, %s, %s)", (member_id, name, phone_number, email))
        print(f"New member added! Proceeding to role assignment...")

    else:
        # Check if the member already exists
        cursor.execute("SELECT MemberID from Members WHERE MemberID = %s", (member_id))
        if not cursor.fetchone():
            print("Member does not exist. Please enter a valid Member ID.")
            return
        print("Member found. Proceeding to role assignment...")

    cursor.connection.commit()
    role_assignment(cursor, member_id, campaign_id)


def role_assignment(cursor, member_id, campaign_id):
    """
    Assign a role to the member for the current campaign being set up.
    """

    # Assign role(s) to the new member
    continue_role_assignment = 'yes'
    while continue_role_assignment.lower() == 'yes':
        role = input("Choose the member's role (volunteer, employee, donor): ").lower()

        if role == "volunteer":
            tier = input("Enter the volunteer's tier (Experienced = 1, Not Experienced = 2): ")
            cursor.execute("INSERT INTO Volunteers (MemberID, Tier) VALUES (%s, %s) ON CONFLICT (MemberID) DO UPDATE SET Tier = EXCLUDED.Tier", (member_id, tier))

            events = fetch_events(cursor, campaign_id)  # Adjusted to pass campaign_id
            print("Please select an event to help with:")
            for idx, (event_id, event_name) in enumerate(events, start=1):
                print(f"{idx}: {event_name.strip()}")

            event_choice = int(input("Enter the number of the event: "))
            selected_event_id = events[event_choice - 1][0]  # Get the EventID based on user selection.

            # Insert a record into the Helps table
            cursor.execute("INSERT INTO Helps (VolunteerID, EventID) VALUES (%s, %s)", (member_id, selected_event_id))
            cursor.connection.commit()
            print("Volunteer registered with an event!")


        elif role == "employee":
            salary = input("Enter the employee's salary: ")
            job = input("Enter the employee's job (Manager/Planner/Fundraiser): ")
            cursor.execute("INSERT INTO Employees (MemberID, Salary, Job) VALUES (%s, %s, %s) ON CONFLICT (MemberID) DO UPDATE SET Salary = EXCLUDED.Salary, Job = EXCLUDED.Job", (member_id, salary, job))
            cursor.execute("INSERT INTO Manages (EmployeeID, CampaignID) VALUES (%s, %s)""", (member_id, campaign_id))
            cursor.connection.commit()
            print("Employee registered with the campaign!")


        elif role == "donor":
            donation_amount = input("Enter Donation Amount: ")
            donation_date = input("Enter the Donation Date (YYYY-MM-DD): ")
            
            cursor.execute("SELECT MAX(DonationID) FROM DonatesTo")
            max_donation_id = cursor.fetchone()
            donation_id = (max_donation_id[0] or 0) + 1 # Start at 1 if table is empty

            cursor.execute("INSERT INTO Donors (MemberID, DonationAmount) VALUES (%s, %s) ON CONFLICT (MemberID) DO UPDATE SET DonationAmount = EXCLUDED.DonationAmount""", (member_id, donation_amount))
            cursor.execute("INSERT INTO DonatesTo (DonationID, DonorID, CampaignID, DonationDate) VALUES (%s, %s, %s, %s)""", (donation_id, member_id, campaign_id, donation_date))
            cursor.connection.commit()
            print("Donation registered and donation to campaign recorded. Thank you!")

        else: 
            print("Invalid role selected. Please try again.")

        continue_role_assignment = input("Do you want to register the member with another role? (yes/no): ") 


def get_and_display_financial_reports(cursor):
    """
    Displays the financial reports. Obtains the total donations and total expenses for each campaign.
    """
    # Get total donations
    donations_query = """
    SELECT c.CampaignID, c.Name AS CampaignName, COALESCE(SUM(d.DonationAmount), 0) AS TotalDonations
    FROM Campaigns c
    LEFT JOIN DonatesTo dt ON c.CampaignID = dt.CampaignID
    LEFT JOIN Donors d ON dt.DonorID = d.MemberID
    GROUP BY c.CampaignID
    ORDER BY TotalDonations DESC;
    """

    cursor.execute(donations_query)
    donations = cursor.fetchall()
    generate_bar_chart(donations, title="Total Donations per Campaign")


    # Get total expenses
    expenses_query = """
    SELECT c.CampaignID, c.Name AS CampaignName, ABS(SUM(e.CashFlow)) AS TotalExpenses
    FROM Campaigns c
    JOIN Plans p ON c.CampaignID = p.CampaignID
    JOIN Events e ON p.EventID = e.EventID
    WHERE e.CashFlow < 0
    GROUP BY c.CampaignID
    ORDER BY TotalExpenses DESC;
    """

    cursor.execute(expenses_query)
    expenses = cursor.fetchall()
    generate_bar_chart(expenses, title="Total Expenses per Campaign")
    

def generate_bar_chart(data, label_width=20, chart_width=50, title=""):
    """
    Creates a bar-chart (ASCII)
    """
    
    if not data:
        print("No data available.")
        return
    max_value = max([item[2] for item in data])
    print(f"\n{title}\n" + "=" * (label_width + chart_width + 10))
    for row in data:
        label = row[1][:label_width].ljust(label_width)
        proportion = row[2] / max_value if max_value else 0
        bar_length = int(proportion * chart_width)
        bar = '#' * bar_length
        print(f"{label} | {bar} {row[2]}")


def add_member_activity_annotation(cursor):
    """Allows user to provide annotations relating to member activity.
    """
    
    # User will be prompted to fill in the following information
    member_id = input("Enter Member ID: ")
    annotation_text = input("Enter Annotation Text: ")
    cursor.execute("""
    INSERT INTO MemberActivityAnnotations (MemberID, AnnotationText)
    VALUES (%s, %s)
    """, (member_id, annotation_text))
    cursor.connection.commit()
    print("Member activity annotation added successfully!")


def add_campaign_annotation(cursor):
    """
    Allows user to provide annotations relating to campaigns.
    """

    # Displays all campaigns
    cursor.execute("SELECT CampaignID, Name FROM Campaigns ORDER BY Name")
    campaigns = cursor.fetchall()
    print("Available Campaigns:")
    for idx, (campaign_id, name) in enumerate(campaigns, start=1):
        print(f"{idx}. {name}")
    
    # User can choose a campain
    choice = int(input("Select a campaign by its number: "))
    selected_campaign_id = campaigns[choice - 1][0] 
    
    # User will be prompted to fill in the annotation
    annotation_text = input("Enter Annotation Text: ")
    cursor.execute("""
    INSERT INTO CampaignAnnotations (CampaignID, AnnotationText)
    VALUES (%s, %s)
    """, (selected_campaign_id, annotation_text))
    cursor.connection.commit()
    print("Campaign annotation added successfully!")


def analyze_age_group_engagement(cursor):
    """
    Analyzes age group engagement for members (volunteers, employees, and donors)
    """
    
    cursor.execute("""
        SELECT
            CASE
                WHEN EXTRACT(YEAR FROM AGE(m.Birthdate)) BETWEEN 18 AND 30 THEN '18-30'
                WHEN EXTRACT(YEAR FROM AGE(m.Birthdate)) BETWEEN 31 AND 45 THEN '31-45'
                WHEN EXTRACT(YEAR FROM AGE(m.Birthdate)) BETWEEN 46 AND 60 THEN '46-60'
                ELSE '61+'
            END AS AgeGroup,
            COUNT(DISTINCT m.MemberID) AS MembersCount
        FROM Members m
        LEFT JOIN Volunteers v ON m.MemberID = v.MemberID
        LEFT JOIN Helps h ON v.MemberID = h.VolunteerID
        LEFT JOIN DonatesTo d ON m.MemberID = d.DonorID
        GROUP BY AgeGroup
        ORDER BY AgeGroup
    """)

    results = cursor.fetchall()
    
    print("Age Group Engagement:")
    for age_group, count in results:
        print(f"{age_group}: {count} members active")


def main():
    """
    First display in the user menu is located in this main function.
    """
    
    try:
        dbconn = psycopg2.connect(host='studentdb.csc.uvic.ca', user='c370_s175', password='KAwZydNl')
        cursor = dbconn.cursor()

        # Menu options
        while True:
            print("\nSelect one of the following options to execute (or type 'exit' to quit):")
            print("1: View existing information about the GnG organization.")
            print("2: Set up a new campaign.")
            print("3: View financial reports")
            print("4: Add member activity annotation.")
            print("5: Add campaign annotation.")
            print("6: Analyze age group engagement among members.")

            choice = input("Your choice: ").lower()
            if choice == "exit":
                break

            elif choice == "1":
                view_existing_queries(cursor)

            elif choice == "2":
                campaign_id = setup_campaign(cursor)
                if campaign_id:
                    # Schedule events for the new campaign
                    keep_scheduling = 'yes'
                    while keep_scheduling.lower() == 'yes':
                        schedule_event(cursor, campaign_id)
                        keep_scheduling = input("Schedule another event? (yes/no): ")

                    # Register members for the new campaign
                    keep_registering = 'yes'
                    while keep_registering.lower() == 'yes':
                        register_member(cursor, campaign_id)
                        keep_registering = input("Register another member? (yes/no): ")
                else:
                    print("Campaign setup was unsuccessful.")

            elif choice == "3":
                get_and_display_financial_reports(cursor)

            elif choice == "4":
                add_member_activity_annotation(cursor)

            elif choice == "5":
                add_campaign_annotation(cursor)

            elif choice == "6":
                analyze_age_group_engagement(cursor)

            else:
                print("Invalid choice, try again.")

    except Exception as e:
        print(f"Error: {e}")

    finally:
        cursor.close()
        dbconn.close()

if __name__ == "__main__":
    main()