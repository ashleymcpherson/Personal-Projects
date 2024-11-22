--
-- PostgreSQL database dump
--

-- Dumped from database version 10.23 (Ubuntu 10.23-0ubuntu0.18.04.2+esm1)
-- Dumped by pg_dump version 12.18 (Ubuntu 12.18-0ubuntu0.20.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

--
-- Name: donors; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.donors (
    memberid integer NOT NULL,
    donationamount numeric
);


ALTER TABLE public.donors OWNER TO c370_s175;

--
-- Name: averagedonordonation; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.averagedonordonation AS
 SELECT donors.memberid,
    avg(donors.donationamount) AS averagedonation
   FROM public.donors
  GROUP BY donors.memberid;


ALTER TABLE public.averagedonordonation OWNER TO c370_s175;

--
-- Name: campaignannotations; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.campaignannotations (
    campaignannotationid integer NOT NULL,
    campaignid integer NOT NULL,
    annotationtext text NOT NULL,
    createdat timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.campaignannotations OWNER TO c370_s175;

--
-- Name: campaignannotations_campaignannotationid_seq; Type: SEQUENCE; Schema: public; Owner: c370_s175
--

CREATE SEQUENCE public.campaignannotations_campaignannotationid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.campaignannotations_campaignannotationid_seq OWNER TO c370_s175;

--
-- Name: campaignannotations_campaignannotationid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: c370_s175
--

ALTER SEQUENCE public.campaignannotations_campaignannotationid_seq OWNED BY public.campaignannotations.campaignannotationid;


--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.campaigns (
    campaignid integer NOT NULL,
    name character(50),
    startdate date,
    enddate date,
    budget numeric,
    amountspent numeric
);


ALTER TABLE public.campaigns OWNER TO c370_s175;

--
-- Name: campaignannotationsdisplay; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.campaignannotationsdisplay AS
 SELECT c.name AS campaignname,
    ca.annotationtext,
    ca.createdat
   FROM (public.campaignannotations ca
     JOIN public.campaigns c ON ((ca.campaignid = c.campaignid)));


ALTER TABLE public.campaignannotationsdisplay OWNER TO c370_s175;

--
-- Name: donatesto; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.donatesto (
    donationid integer NOT NULL,
    donorid integer NOT NULL,
    campaignid integer NOT NULL,
    donationdate date
);


ALTER TABLE public.donatesto OWNER TO c370_s175;

--
-- Name: campaignsnodonations; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.campaignsnodonations AS
 SELECT c.name AS campaignname
   FROM public.campaigns c
  WHERE (NOT (EXISTS ( SELECT 1
           FROM public.donatesto dt
          WHERE (dt.campaignid = c.campaignid))));


ALTER TABLE public.campaignsnodonations OWNER TO c370_s175;

--
-- Name: campaignspentmorethanbudget; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.campaignspentmorethanbudget AS
 SELECT campaigns.name,
    campaigns.budget,
    campaigns.amountspent
   FROM public.campaigns
  WHERE (campaigns.amountspent > campaigns.budget);


ALTER TABLE public.campaignspentmorethanbudget OWNER TO c370_s175;

--
-- Name: monitors; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.monitors (
    campaignid integer NOT NULL,
    contentid integer NOT NULL
);


ALTER TABLE public.monitors OWNER TO c370_s175;

--
-- Name: website; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.website (
    contentid integer NOT NULL,
    phase character(50),
    publishstatus character(50)
);


ALTER TABLE public.website OWNER TO c370_s175;

--
-- Name: campaignstatecompletionstatus; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.campaignstatecompletionstatus AS
 SELECT c.name AS campaignname,
    w.phase AS campaignstate,
    w.publishstatus
   FROM ((public.campaigns c
     JOIN public.monitors m ON ((c.campaignid = m.campaignid)))
     JOIN public.website w ON ((m.contentid = w.contentid)))
  ORDER BY c.campaignid;


ALTER TABLE public.campaignstatecompletionstatus OWNER TO c370_s175;

--
-- Name: events; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.events (
    eventid integer NOT NULL,
    name character(50),
    type character(50),
    location character(50),
    date date,
    cashflow numeric
);


ALTER TABLE public.events OWNER TO c370_s175;

--
-- Name: plans; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.plans (
    campaignid integer NOT NULL,
    eventid integer NOT NULL
);


ALTER TABLE public.plans OWNER TO c370_s175;

--
-- Name: campaignswithmostevents; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.campaignswithmostevents AS
 SELECT c.name AS campaignname,
    count(e.eventid) AS numberofevents
   FROM ((public.campaigns c
     JOIN public.plans p ON ((c.campaignid = p.campaignid)))
     JOIN public.events e ON ((p.eventid = e.eventid)))
  GROUP BY c.name
  ORDER BY (count(e.eventid)) DESC;


ALTER TABLE public.campaignswithmostevents OWNER TO c370_s175;

--
-- Name: employees; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.employees (
    memberid integer NOT NULL,
    salary numeric,
    job character(70)
);


ALTER TABLE public.employees OWNER TO c370_s175;

--
-- Name: helps; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.helps (
    volunteerid integer NOT NULL,
    eventid integer NOT NULL
);


ALTER TABLE public.helps OWNER TO c370_s175;

--
-- Name: howmuchwebsitecontentpublished; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.howmuchwebsitecontentpublished AS
 SELECT c.name AS campaignname,
    count(DISTINCT w.contentid) AS numberofcontentoutputs
   FROM ((public.campaigns c
     LEFT JOIN public.monitors m ON ((c.campaignid = m.campaignid)))
     LEFT JOIN public.website w ON ((m.contentid = w.contentid)))
  GROUP BY c.name
  ORDER BY (count(DISTINCT w.contentid)) DESC;


ALTER TABLE public.howmuchwebsitecontentpublished OWNER TO c370_s175;

--
-- Name: manages; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.manages (
    employeeid integer NOT NULL,
    campaignid integer NOT NULL
);


ALTER TABLE public.manages OWNER TO c370_s175;

--
-- Name: memberactivityannotations; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.memberactivityannotations (
    annotationid integer NOT NULL,
    memberid integer NOT NULL,
    annotationtext text NOT NULL,
    createdat timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.memberactivityannotations OWNER TO c370_s175;

--
-- Name: memberactivityannotations_annotationid_seq; Type: SEQUENCE; Schema: public; Owner: c370_s175
--

CREATE SEQUENCE public.memberactivityannotations_annotationid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.memberactivityannotations_annotationid_seq OWNER TO c370_s175;

--
-- Name: memberactivityannotations_annotationid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: c370_s175
--

ALTER SEQUENCE public.memberactivityannotations_annotationid_seq OWNED BY public.memberactivityannotations.annotationid;


--
-- Name: members; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.members (
    memberid integer NOT NULL,
    name character(50),
    phonenumber character varying(15),
    email character(70),
    birthdate date
);


ALTER TABLE public.members OWNER TO c370_s175;

--
-- Name: memberactivityannotationsdisplay; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.memberactivityannotationsdisplay AS
 SELECT m.name AS membername,
    maa.annotationtext,
    maa.createdat
   FROM (public.memberactivityannotations maa
     JOIN public.members m ON ((maa.memberid = m.memberid)));


ALTER TABLE public.memberactivityannotationsdisplay OWNER TO c370_s175;

--
-- Name: memberhistory; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.memberhistory (
    memberhistoryid integer NOT NULL,
    memberid integer NOT NULL,
    campaignid integer,
    eventid integer,
    participationdate date,
    participationtype character varying(255)
);


ALTER TABLE public.memberhistory OWNER TO c370_s175;

--
-- Name: memberhistory_memberhistoryid_seq; Type: SEQUENCE; Schema: public; Owner: c370_s175
--

CREATE SEQUENCE public.memberhistory_memberhistoryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.memberhistory_memberhistoryid_seq OWNER TO c370_s175;

--
-- Name: memberhistory_memberhistoryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: c370_s175
--

ALTER SEQUENCE public.memberhistory_memberhistoryid_seq OWNED BY public.memberhistory.memberhistoryid;


--
-- Name: memberparticipationhistory; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.memberparticipationhistory (
    memberhistoryid integer NOT NULL,
    memberid integer NOT NULL,
    campaignid integer,
    eventid integer,
    participationdate date,
    participationtype character varying(255)
);


ALTER TABLE public.memberparticipationhistory OWNER TO c370_s175;

--
-- Name: memberparticipationhistory_memberhistoryid_seq; Type: SEQUENCE; Schema: public; Owner: c370_s175
--

CREATE SEQUENCE public.memberparticipationhistory_memberhistoryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.memberparticipationhistory_memberhistoryid_seq OWNER TO c370_s175;

--
-- Name: memberparticipationhistory_memberhistoryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: c370_s175
--

ALTER SEQUENCE public.memberparticipationhistory_memberhistoryid_seq OWNED BY public.memberparticipationhistory.memberhistoryid;


--
-- Name: volunteers; Type: TABLE; Schema: public; Owner: c370_s175
--

CREATE TABLE public.volunteers (
    memberid integer NOT NULL,
    tier integer
);


ALTER TABLE public.volunteers OWNER TO c370_s175;

--
-- Name: membersarevolunteersanddonors; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.membersarevolunteersanddonors AS
 SELECT m.name
   FROM public.members m
  WHERE ((EXISTS ( SELECT 1
           FROM public.volunteers v
          WHERE (v.memberid = m.memberid))) AND (EXISTS ( SELECT 1
           FROM public.donors d
          WHERE (d.memberid = m.memberid))));


ALTER TABLE public.membersarevolunteersanddonors OWNER TO c370_s175;

--
-- Name: notvolunteeremployeedonor; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.notvolunteeremployeedonor AS
 SELECT m.name AS notvolunteeremployeedonor
   FROM public.members m
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM public.volunteers v
          WHERE (v.memberid = m.memberid)))) AND (NOT (EXISTS ( SELECT 1
           FROM public.employees e
          WHERE (e.memberid = m.memberid)))) AND (NOT (EXISTS ( SELECT 1
           FROM public.donors d
          WHERE (d.memberid = m.memberid)))));


ALTER TABLE public.notvolunteeremployeedonor OWNER TO c370_s175;

--
-- Name: numberofcampaignsvolunteersparticipated; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.numberofcampaignsvolunteersparticipated AS
 SELECT v.memberid,
    m.name AS volunteername,
    v.tier,
    count(DISTINCT p.campaignid) AS numberofcampaigns
   FROM ((((public.volunteers v
     JOIN public.members m ON ((v.memberid = m.memberid)))
     LEFT JOIN public.helps h ON ((v.memberid = h.volunteerid)))
     LEFT JOIN public.events e ON ((h.eventid = e.eventid)))
     LEFT JOIN public.plans p ON ((e.eventid = p.eventid)))
  GROUP BY v.memberid, m.name, v.tier
  ORDER BY (count(DISTINCT p.campaignid)) DESC, v.tier;


ALTER TABLE public.numberofcampaignsvolunteersparticipated OWNER TO c370_s175;

--
-- Name: totaldonationeachcampaign; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.totaldonationeachcampaign AS
 SELECT c.name AS campaignname,
    sum(d.donationamount) AS totaldonations
   FROM ((public.campaigns c
     LEFT JOIN public.donatesto donates ON ((c.campaignid = donates.campaignid)))
     LEFT JOIN public.donors d ON ((donates.donorid = d.memberid)))
  GROUP BY c.name;


ALTER TABLE public.totaldonationeachcampaign OWNER TO c370_s175;

--
-- Name: totalincometotalexpensesevents; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.totalincometotalexpensesevents AS
 SELECT events.type,
    sum(events.cashflow) AS totalcashflow
   FROM public.events
  GROUP BY events.type;


ALTER TABLE public.totalincometotalexpensesevents OWNER TO c370_s175;

--
-- Name: viewmemberparticipationhistory; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.viewmemberparticipationhistory AS
 SELECT m.name AS membername,
    c.name AS campaignname,
    e.name AS eventname,
    mh.participationdate,
    mh.participationtype
   FROM (((public.memberparticipationhistory mh
     JOIN public.members m ON ((mh.memberid = m.memberid)))
     LEFT JOIN public.campaigns c ON ((mh.campaignid = c.campaignid)))
     LEFT JOIN public.events e ON ((mh.eventid = e.eventid)));


ALTER TABLE public.viewmemberparticipationhistory OWNER TO c370_s175;

--
-- Name: volunteersintreeplantingbeachcleanup; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.volunteersintreeplantingbeachcleanup AS
 SELECT DISTINCT m.name
   FROM ((((public.members m
     JOIN public.volunteers v ON ((m.memberid = v.memberid)))
     JOIN public.helps h ON ((v.memberid = h.volunteerid)))
     JOIN public.events e ON ((h.eventid = e.eventid)))
     JOIN public.plans p ON ((e.eventid = p.eventid)))
  WHERE (p.campaignid IN ( SELECT campaigns.campaignid
           FROM public.campaigns
          WHERE (campaigns.name = 'Tree Planting'::bpchar)))
INTERSECT
 SELECT DISTINCT m.name
   FROM ((((public.members m
     JOIN public.volunteers v ON ((m.memberid = v.memberid)))
     JOIN public.helps h ON ((v.memberid = h.volunteerid)))
     JOIN public.events e ON ((h.eventid = e.eventid)))
     JOIN public.plans p ON ((e.eventid = p.eventid)))
  WHERE (p.campaignid IN ( SELECT campaigns.campaignid
           FROM public.campaigns
          WHERE (campaigns.name = 'Beach Cleanup'::bpchar)));


ALTER TABLE public.volunteersintreeplantingbeachcleanup OWNER TO c370_s175;

--
-- Name: volunteersparticipatedevents; Type: VIEW; Schema: public; Owner: c370_s175
--

CREATE VIEW public.volunteersparticipatedevents AS
 SELECT e.name AS eventname,
    count(DISTINCT h.volunteerid) AS numberofvolunteers
   FROM (public.events e
     JOIN public.helps h ON ((e.eventid = h.eventid)))
  GROUP BY e.name
  ORDER BY (count(DISTINCT h.volunteerid)) DESC;


ALTER TABLE public.volunteersparticipatedevents OWNER TO c370_s175;

--
-- Name: campaignannotations campaignannotationid; Type: DEFAULT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.campaignannotations ALTER COLUMN campaignannotationid SET DEFAULT nextval('public.campaignannotations_campaignannotationid_seq'::regclass);


--
-- Name: memberactivityannotations annotationid; Type: DEFAULT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.memberactivityannotations ALTER COLUMN annotationid SET DEFAULT nextval('public.memberactivityannotations_annotationid_seq'::regclass);


--
-- Name: memberhistory memberhistoryid; Type: DEFAULT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.memberhistory ALTER COLUMN memberhistoryid SET DEFAULT nextval('public.memberhistory_memberhistoryid_seq'::regclass);


--
-- Name: memberparticipationhistory memberhistoryid; Type: DEFAULT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.memberparticipationhistory ALTER COLUMN memberhistoryid SET DEFAULT nextval('public.memberparticipationhistory_memberhistoryid_seq'::regclass);


--
-- Data for Name: campaignannotations; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.campaignannotations (campaignannotationid, campaignid, annotationtext, createdat) FROM stdin;
1	1	Surpassed tree planting goal by 150%	2024-04-08 23:28:10.054092
2	2	Most community-engaged event of the year	2024-04-08 23:28:10.054092
3	3	Notable media coverage on climate change awareness	2024-04-08 23:28:10.054092
4	4	Exceeded fundraising target by $20,000	2024-04-08 23:28:10.054092
5	5	Initiated a long-term partnership with local beekeepers	2024-04-08 23:28:10.054092
\.


--
-- Data for Name: campaigns; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.campaigns (campaignid, name, startdate, enddate, budget, amountspent) FROM stdin;
1	Tree Planting                                     	2023-01-01	2023-01-04	80.00	80.00
2	Beach Cleanup                                     	2023-04-05	2023-04-08	70.00	75.00
3	Climate Change                                    	2023-09-20	2023-10-20	300.00	250.00
4	Green Energy                                      	2024-01-10	2024-04-10	1000.00	1000.00
5	Save the Bees                                     	2024-04-08	2024-04-09	200.00	200.00
\.


--
-- Data for Name: donatesto; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.donatesto (donationid, donorid, campaignid, donationdate) FROM stdin;
1	11	1	2023-01-01
2	12	1	2022-12-30
3	13	2	2023-04-05
4	14	2	2023-04-01
5	15	3	2023-09-20
6	11	3	2023-09-19
7	13	4	2024-01-10
8	14	4	2024-01-11
9	1	1	2023-01-02
10	11	4	2024-01-10
11	12	3	2023-09-18
12	15	2	2023-04-03
13	2	1	2023-01-02
\.


--
-- Data for Name: donors; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.donors (memberid, donationamount) FROM stdin;
11	1000.00
12	400.00
13	20000.00
14	900.00
1	2300.00
2	1000.00
15	1000.00
3	25000.00
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.employees (memberid, salary, job) FROM stdin;
8	25000.00	Manager                                                               
9	10000.00	Planner                                                               
10	30000.00	Fundraiser                                                            
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.events (eventid, name, type, location, date, cashflow) FROM stdin;
1	Kick Off Tree Planting                            	Awareness Event                                   	Sidney                                            	2023-01-01	-20.00
2	Educational Workshop on Reforestation             	Awareness Event                                   	Sidney                                            	2023-01-02	-50.00
3	Plant Some Trees                                  	Awareness Event                                   	Central Saanich                                   	2023-01-03	-10.00
4	Fundraiser for More Campaigns Like This!          	Fundraising Event                                 	Sidney                                            	2023-01-04	10.00
5	Clean Up the Beach!                               	Awareness Event                                   	Tofino                                            	2023-04-05	-30.00
6	Workshop on Marine Pollution                      	Awareness Event                                   	Tofino                                            	2023-04-08	-45.00
7	Expert Panel Discussion on Climate Change         	Awareness Event                                   	Victoria                                          	2023-09-20	-100.00
8	Sustainable Living Workshop                       	Awareness Event                                   	Victoria                                          	2023-09-30	-100.00
9	Climate March                                     	Awareness Event                                   	Victoria                                          	2023-10-10	-50.00
10	Fundraiser for More Campaigns Like This!          	Fundraising Event                                 	Victoria                                          	2023-10-20	20.00
11	Expert Panel Discussion on Electric Cars          	Awareness Event                                   	Esquimalt                                         	2024-01-12	-200.00
12	Green Energy in Schools Discussion                	Awareness Event                                   	Esquimalt                                         	2024-01-30	-200.00
13	Green Energy Fair!                                	Awareness Event                                   	Esquimalt                                         	2024-02-15	-600.00
14	GnG Fundraiser at the Green Energy Fair           	Fundraising Event                                 	Esquimalt                                         	2024-03-03	100.00
15	Learn from Honey Farmers                          	Awareness Event                                   	Nanaimo                                           	2024-04-08	-200.00
\.


--
-- Data for Name: helps; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.helps (volunteerid, eventid) FROM stdin;
1	1
1	2
2	3
2	5
3	5
3	4
4	1
5	5
5	8
6	9
6	11
7	11
7	12
1	13
2	14
3	15
4	2
5	3
6	5
1	7
\.


--
-- Data for Name: manages; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.manages (employeeid, campaignid) FROM stdin;
8	1
9	2
10	3
8	4
9	5
\.


--
-- Data for Name: memberactivityannotations; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.memberactivityannotations (annotationid, memberid, annotationtext, createdat) FROM stdin;
1	1	Outstanding Volunteer Effort at Tree Planting Event	2024-04-08 23:28:10.028711
2	2	Reached 100 Hours of Volunteering	2024-04-08 23:28:10.028711
3	3	Highly praised for their commitment to Green Energy	2024-04-08 23:28:10.028711
4	4	Shared valuable insights on Climate Change Panel	2024-04-08 23:28:10.028711
5	5	First-time donor, contributed significantly	2024-04-08 23:28:10.028711
\.


--
-- Data for Name: memberhistory; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.memberhistory (memberhistoryid, memberid, campaignid, eventid, participationdate, participationtype) FROM stdin;
1	1	1	1	2023-01-01	Volunteering
2	2	2	5	2023-04-05	Volunteering
3	3	3	9	2024-01-12	Working
4	4	4	13	2023-09-20	Working
5	5	5	\N	2023-01-03	Donating
6	6	1	\N	2023-04-06	Donating
7	7	2	\N	2023-09-21	Donating
8	8	3	10	2024-02-15	Volunteering
9	9	4	14	2024-04-08	Working
10	10	5	15	2024-01-04	Volunteering
\.


--
-- Data for Name: memberparticipationhistory; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.memberparticipationhistory (memberhistoryid, memberid, campaignid, eventid, participationdate, participationtype) FROM stdin;
1	1	1	1	2023-01-01	Volunteering
2	2	2	5	2023-04-05	Volunteering
3	3	3	9	2024-01-12	Working
4	4	4	13	2023-09-20	Working
5	5	5	\N	2023-01-03	Donating
6	6	1	\N	2023-04-06	Donating
7	7	2	\N	2023-09-21	Donating
8	8	3	10	2024-02-15	Volunteering
9	9	4	14	2024-04-08	Working
10	10	5	15	2024-01-04	Volunteering
\.


--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.members (memberid, name, phonenumber, email, birthdate) FROM stdin;
1	Ashley McPherson                                  	403-123-4567	ashleymcpherson@gmail.com                                             	1990-05-21
2	Bob Smith                                         	403-234-5677	bobsmith@gmail.com                                                    	1985-08-04
3	Tim Timmy                                         	403-345-5678	timtimmy@gmail.com                                                    	1972-11-12
4	Daisy Rose                                        	403-456-7899	daisyrose@gmail.com                                                   	1999-02-09
5	Amy Thomas                                        	403-567-8910	amythomas@gmail.com                                                   	1995-07-18
6	Will Power                                        	587-777-1292	willpower@gmail.com                                                   	1980-01-25
7	Steve Hart                                        	587-126-1298	stevehart@gmail.com                                                   	1965-03-30
8	Elisabeth Green                                   	342-384-1238	elisabethgreen@gmail.com                                              	1988-09-15
9	Emma Blue                                         	342-458-3940	emmablue@gmail.com                                                    	2001-12-22
10	Ella Anderson                                     	500-232-1000	ellaanderson@gmail.com                                                	1993-04-08
11	Ben Wilson                                        	343-1232-3490	benwilson@gmail.com                                                   	1978-06-05
12	Jim Johnson                                       	543-219-1232	jimjohnson@gmail.com                                                  	1969-10-17
13	Joe Jones                                         	342-129-2399	joejones@gmail.com                                                    	2003-08-28
14	Sarah White                                       	604-454-9877	sarahwhite@gmail.com                                                  	1987-01-19
15	Jess Lopez                                        	394-565-4954	jesslopez@gmail.com                                                   	1992-03-03
16	Mario Thompson                                    	596-343-2392	mariothompson@gmail.com                                               	1982-07-24
17	Julia Jules                                       	322-968-0000	juliajules@gmail.com                                                  	1996-05-15
\.


--
-- Data for Name: monitors; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.monitors (campaignid, contentid) FROM stdin;
1	1
2	2
3	3
4	4
5	5
1	6
2	7
3	8
4	9
5	10
1	11
2	12
3	13
4	14
5	15
\.


--
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.plans (campaignid, eventid) FROM stdin;
1	1
1	2
1	3
1	4
2	5
2	6
3	7
3	8
3	9
3	10
4	11
4	12
4	13
4	14
5	15
\.


--
-- Data for Name: volunteers; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.volunteers (memberid, tier) FROM stdin;
1	1
2	1
3	1
4	1
5	2
6	2
7	2
\.


--
-- Data for Name: website; Type: TABLE DATA; Schema: public; Owner: c370_s175
--

COPY public.website (contentid, phase, publishstatus) FROM stdin;
1	Organizing Campaign                               	Published                                         
2	Campaign in Progress                              	Published                                         
3	Campaign Completed                                	Published                                         
4	Organizing Campaign                               	Published                                         
5	Campaign in Progress                              	Not Published                                     
6	Campaign Completed                                	Published                                         
7	Organizing Campaign                               	Published                                         
8	Campaign in Progress                              	Published                                         
9	Campaign Completed                                	Not Published                                     
10	Organizing Campaign                               	Published                                         
11	Campaign in Progress                              	Published                                         
12	Campaign Completed                                	Published                                         
13	Organizing Campaign                               	Published                                         
14	Campaign in Progress                              	Published                                         
15	Campaign Completed                                	Not Published                                     
\.


--
-- Name: campaignannotations_campaignannotationid_seq; Type: SEQUENCE SET; Schema: public; Owner: c370_s175
--

SELECT pg_catalog.setval('public.campaignannotations_campaignannotationid_seq', 5, true);


--
-- Name: memberactivityannotations_annotationid_seq; Type: SEQUENCE SET; Schema: public; Owner: c370_s175
--

SELECT pg_catalog.setval('public.memberactivityannotations_annotationid_seq', 5, true);


--
-- Name: memberhistory_memberhistoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: c370_s175
--

SELECT pg_catalog.setval('public.memberhistory_memberhistoryid_seq', 10, true);


--
-- Name: memberparticipationhistory_memberhistoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: c370_s175
--

SELECT pg_catalog.setval('public.memberparticipationhistory_memberhistoryid_seq', 10, true);


--
-- Name: campaignannotations campaignannotations_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.campaignannotations
    ADD CONSTRAINT campaignannotations_pkey PRIMARY KEY (campaignannotationid);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (campaignid);


--
-- Name: donatesto donatesto_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.donatesto
    ADD CONSTRAINT donatesto_pkey PRIMARY KEY (donationid, donorid, campaignid);


--
-- Name: donors donors_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.donors
    ADD CONSTRAINT donors_pkey PRIMARY KEY (memberid);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (memberid);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (eventid);


--
-- Name: helps helps_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.helps
    ADD CONSTRAINT helps_pkey PRIMARY KEY (volunteerid, eventid);


--
-- Name: manages manages_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.manages
    ADD CONSTRAINT manages_pkey PRIMARY KEY (employeeid, campaignid);


--
-- Name: memberactivityannotations memberactivityannotations_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.memberactivityannotations
    ADD CONSTRAINT memberactivityannotations_pkey PRIMARY KEY (annotationid);


--
-- Name: memberhistory memberhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.memberhistory
    ADD CONSTRAINT memberhistory_pkey PRIMARY KEY (memberhistoryid);


--
-- Name: memberparticipationhistory memberparticipationhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.memberparticipationhistory
    ADD CONSTRAINT memberparticipationhistory_pkey PRIMARY KEY (memberhistoryid);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (memberid);


--
-- Name: monitors monitors_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.monitors
    ADD CONSTRAINT monitors_pkey PRIMARY KEY (campaignid, contentid);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (campaignid, eventid);


--
-- Name: volunteers volunteers_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.volunteers
    ADD CONSTRAINT volunteers_pkey PRIMARY KEY (memberid);


--
-- Name: website website_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.website
    ADD CONSTRAINT website_pkey PRIMARY KEY (contentid);


--
-- Name: campaignannotations campaignannotations_campaignid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.campaignannotations
    ADD CONSTRAINT campaignannotations_campaignid_fkey FOREIGN KEY (campaignid) REFERENCES public.campaigns(campaignid);


--
-- Name: donatesto donatesto_campaignid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.donatesto
    ADD CONSTRAINT donatesto_campaignid_fkey FOREIGN KEY (campaignid) REFERENCES public.campaigns(campaignid);


--
-- Name: donatesto donatesto_donorid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.donatesto
    ADD CONSTRAINT donatesto_donorid_fkey FOREIGN KEY (donorid) REFERENCES public.donors(memberid);


--
-- Name: donors donors_memberid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.donors
    ADD CONSTRAINT donors_memberid_fkey FOREIGN KEY (memberid) REFERENCES public.members(memberid);


--
-- Name: employees employees_memberid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_memberid_fkey FOREIGN KEY (memberid) REFERENCES public.members(memberid);


--
-- Name: helps helps_eventid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.helps
    ADD CONSTRAINT helps_eventid_fkey FOREIGN KEY (eventid) REFERENCES public.events(eventid);


--
-- Name: helps helps_volunteerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.helps
    ADD CONSTRAINT helps_volunteerid_fkey FOREIGN KEY (volunteerid) REFERENCES public.volunteers(memberid);


--
-- Name: manages manages_campaignid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.manages
    ADD CONSTRAINT manages_campaignid_fkey FOREIGN KEY (campaignid) REFERENCES public.campaigns(campaignid);


--
-- Name: manages manages_employeeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.manages
    ADD CONSTRAINT manages_employeeid_fkey FOREIGN KEY (employeeid) REFERENCES public.employees(memberid);


--
-- Name: memberactivityannotations memberactivityannotations_memberid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.memberactivityannotations
    ADD CONSTRAINT memberactivityannotations_memberid_fkey FOREIGN KEY (memberid) REFERENCES public.members(memberid);


--
-- Name: memberparticipationhistory memberparticipationhistory_campaignid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.memberparticipationhistory
    ADD CONSTRAINT memberparticipationhistory_campaignid_fkey FOREIGN KEY (campaignid) REFERENCES public.campaigns(campaignid);


--
-- Name: memberparticipationhistory memberparticipationhistory_eventid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.memberparticipationhistory
    ADD CONSTRAINT memberparticipationhistory_eventid_fkey FOREIGN KEY (eventid) REFERENCES public.events(eventid);


--
-- Name: memberparticipationhistory memberparticipationhistory_memberid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.memberparticipationhistory
    ADD CONSTRAINT memberparticipationhistory_memberid_fkey FOREIGN KEY (memberid) REFERENCES public.members(memberid);


--
-- Name: monitors monitors_campaignid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.monitors
    ADD CONSTRAINT monitors_campaignid_fkey FOREIGN KEY (campaignid) REFERENCES public.campaigns(campaignid);


--
-- Name: monitors monitors_contentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.monitors
    ADD CONSTRAINT monitors_contentid_fkey FOREIGN KEY (contentid) REFERENCES public.website(contentid);


--
-- Name: plans plans_campaignid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_campaignid_fkey FOREIGN KEY (campaignid) REFERENCES public.campaigns(campaignid);


--
-- Name: plans plans_eventid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_eventid_fkey FOREIGN KEY (eventid) REFERENCES public.events(eventid);


--
-- Name: volunteers volunteers_memberid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s175
--

ALTER TABLE ONLY public.volunteers
    ADD CONSTRAINT volunteers_memberid_fkey FOREIGN KEY (memberid) REFERENCES public.members(memberid);


--
-- PostgreSQL database dump complete
--

