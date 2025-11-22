--
-- PostgreSQL database dump
--

-- Dumped from database version 17.1
-- Dumped by pg_dump version 17.1

-- Started on 2025-11-22 20:39:22

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 224 (class 1259 OID 24700)
-- Name: blood_inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blood_inventory (
    inventory_id integer NOT NULL,
    blood_type character varying(5) NOT NULL,
    units_available integer DEFAULT 0,
    collection_date date NOT NULL,
    expiry_date date NOT NULL,
    status character varying(20) DEFAULT 'available'::character varying,
    donor_id integer,
    CONSTRAINT blood_inventory_blood_type_check CHECK (((blood_type)::text = ANY ((ARRAY['A+'::character varying, 'A-'::character varying, 'B+'::character varying, 'B-'::character varying, 'AB+'::character varying, 'AB-'::character varying, 'O+'::character varying, 'O-'::character varying])::text[]))),
    CONSTRAINT blood_inventory_status_check CHECK (((status)::text = ANY ((ARRAY['available'::character varying, 'reserved'::character varying, 'expired'::character varying])::text[])))
);


ALTER TABLE public.blood_inventory OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24699)
-- Name: blood_inventory_inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.blood_inventory_inventory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.blood_inventory_inventory_id_seq OWNER TO postgres;

--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 223
-- Name: blood_inventory_inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.blood_inventory_inventory_id_seq OWNED BY public.blood_inventory.inventory_id;


--
-- TOC entry 228 (class 1259 OID 24737)
-- Name: blood_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blood_requests (
    request_id integer NOT NULL,
    receiver_id integer,
    blood_type character varying(5) NOT NULL,
    units_needed integer NOT NULL,
    urgency character varying(20) DEFAULT 'medium'::character varying,
    reason text,
    status character varying(20) DEFAULT 'pending'::character varying,
    request_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fulfilled_date timestamp without time zone,
    CONSTRAINT blood_requests_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'approved'::character varying, 'fulfilled'::character varying, 'rejected'::character varying])::text[]))),
    CONSTRAINT blood_requests_urgency_check CHECK (((urgency)::text = ANY ((ARRAY['low'::character varying, 'medium'::character varying, 'high'::character varying, 'critical'::character varying])::text[])))
);


ALTER TABLE public.blood_requests OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 24736)
-- Name: blood_requests_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.blood_requests_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.blood_requests_request_id_seq OWNER TO postgres;

--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 227
-- Name: blood_requests_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.blood_requests_request_id_seq OWNED BY public.blood_requests.request_id;


--
-- TOC entry 226 (class 1259 OID 24716)
-- Name: donation_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.donation_requests (
    request_id integer NOT NULL,
    donor_id integer,
    receiver_id integer,
    donation_type character varying(20) NOT NULL,
    blood_type character varying(5) NOT NULL,
    units integer NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying,
    request_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    completion_date timestamp without time zone,
    CONSTRAINT donation_requests_donation_type_check CHECK (((donation_type)::text = ANY ((ARRAY['direct'::character varying, 'inventory'::character varying])::text[]))),
    CONSTRAINT donation_requests_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'approved'::character varying, 'completed'::character varying, 'rejected'::character varying])::text[])))
);


ALTER TABLE public.donation_requests OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24715)
-- Name: donation_requests_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.donation_requests_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.donation_requests_request_id_seq OWNER TO postgres;

--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 225
-- Name: donation_requests_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.donation_requests_request_id_seq OWNED BY public.donation_requests.request_id;


--
-- TOC entry 220 (class 1259 OID 24667)
-- Name: donors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.donors (
    donor_id integer NOT NULL,
    user_id integer,
    blood_type character varying(5) NOT NULL,
    last_donation_date date,
    weight numeric(5,2),
    health_status character varying(50) DEFAULT 'healthy'::character varying,
    is_eligible boolean DEFAULT true,
    total_donations integer DEFAULT 0,
    CONSTRAINT donors_blood_type_check CHECK (((blood_type)::text = ANY ((ARRAY['A+'::character varying, 'A-'::character varying, 'B+'::character varying, 'B-'::character varying, 'AB+'::character varying, 'AB-'::character varying, 'O+'::character varying, 'O-'::character varying])::text[])))
);


ALTER TABLE public.donors OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24666)
-- Name: donors_donor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.donors_donor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.donors_donor_id_seq OWNER TO postgres;

--
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 219
-- Name: donors_donor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.donors_donor_id_seq OWNED BY public.donors.donor_id;


--
-- TOC entry 222 (class 1259 OID 24683)
-- Name: receivers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receivers (
    receiver_id integer NOT NULL,
    user_id integer,
    blood_type character varying(5) NOT NULL,
    medical_condition text,
    urgency_level character varying(20) DEFAULT 'medium'::character varying,
    CONSTRAINT receivers_blood_type_check CHECK (((blood_type)::text = ANY ((ARRAY['A+'::character varying, 'A-'::character varying, 'B+'::character varying, 'B-'::character varying, 'AB+'::character varying, 'AB-'::character varying, 'O+'::character varying, 'O-'::character varying])::text[]))),
    CONSTRAINT receivers_urgency_level_check CHECK (((urgency_level)::text = ANY ((ARRAY['low'::character varying, 'medium'::character varying, 'high'::character varying, 'critical'::character varying])::text[])))
);


ALTER TABLE public.receivers OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24682)
-- Name: receivers_receiver_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.receivers_receiver_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.receivers_receiver_id_seq OWNER TO postgres;

--
-- TOC entry 4956 (class 0 OID 0)
-- Dependencies: 221
-- Name: receivers_receiver_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.receivers_receiver_id_seq OWNED BY public.receivers.receiver_id;


--
-- TOC entry 230 (class 1259 OID 24756)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    transaction_id integer NOT NULL,
    donor_id integer,
    receiver_id integer,
    blood_type character varying(5) NOT NULL,
    units integer NOT NULL,
    transaction_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    transaction_type character varying(20) NOT NULL,
    notes text,
    CONSTRAINT transactions_transaction_type_check CHECK (((transaction_type)::text = ANY ((ARRAY['direct'::character varying, 'from_inventory'::character varying])::text[])))
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 24755)
-- Name: transactions_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transactions_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transactions_transaction_id_seq OWNER TO postgres;

--
-- TOC entry 4957 (class 0 OID 0)
-- Dependencies: 229
-- Name: transactions_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transactions_transaction_id_seq OWNED BY public.transactions.transaction_id;


--
-- TOC entry 218 (class 1259 OID 24653)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(20) NOT NULL,
    full_name character varying(255) NOT NULL,
    phone character varying(20),
    address text,
    city character varying(100),
    state character varying(100),
    date_of_birth date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_active boolean DEFAULT true,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['admin'::character varying, 'donor'::character varying, 'receiver'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24652)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 4958 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 4734 (class 2604 OID 24703)
-- Name: blood_inventory inventory_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blood_inventory ALTER COLUMN inventory_id SET DEFAULT nextval('public.blood_inventory_inventory_id_seq'::regclass);


--
-- TOC entry 4740 (class 2604 OID 24740)
-- Name: blood_requests request_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blood_requests ALTER COLUMN request_id SET DEFAULT nextval('public.blood_requests_request_id_seq'::regclass);


--
-- TOC entry 4737 (class 2604 OID 24719)
-- Name: donation_requests request_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation_requests ALTER COLUMN request_id SET DEFAULT nextval('public.donation_requests_request_id_seq'::regclass);


--
-- TOC entry 4728 (class 2604 OID 24670)
-- Name: donors donor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donors ALTER COLUMN donor_id SET DEFAULT nextval('public.donors_donor_id_seq'::regclass);


--
-- TOC entry 4732 (class 2604 OID 24686)
-- Name: receivers receiver_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receivers ALTER COLUMN receiver_id SET DEFAULT nextval('public.receivers_receiver_id_seq'::regclass);


--
-- TOC entry 4744 (class 2604 OID 24759)
-- Name: transactions transaction_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ALTER COLUMN transaction_id SET DEFAULT nextval('public.transactions_transaction_id_seq'::regclass);


--
-- TOC entry 4725 (class 2604 OID 24656)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 4940 (class 0 OID 24700)
-- Dependencies: 224
-- Data for Name: blood_inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blood_inventory (inventory_id, blood_type, units_available, collection_date, expiry_date, status, donor_id) FROM stdin;
1	AB+	1	2025-11-22	2026-01-03	available	5
\.


--
-- TOC entry 4944 (class 0 OID 24737)
-- Dependencies: 228
-- Data for Name: blood_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blood_requests (request_id, receiver_id, blood_type, units_needed, urgency, reason, status, request_date, fulfilled_date) FROM stdin;
\.


--
-- TOC entry 4942 (class 0 OID 24716)
-- Dependencies: 226
-- Data for Name: donation_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.donation_requests (request_id, donor_id, receiver_id, donation_type, blood_type, units, status, request_date, completion_date) FROM stdin;
\.


--
-- TOC entry 4936 (class 0 OID 24667)
-- Dependencies: 220
-- Data for Name: donors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.donors (donor_id, user_id, blood_type, last_donation_date, weight, health_status, is_eligible, total_donations) FROM stdin;
1	2	O+	\N	\N	healthy	t	0
2	3	O+	\N	\N	healthy	t	0
3	4	A+	\N	65.00	healthy	t	0
4	5	O+	\N	70.50	healthy	t	0
5	6	AB+	2025-11-22	75.00	healthy	t	1
\.


--
-- TOC entry 4938 (class 0 OID 24683)
-- Dependencies: 222
-- Data for Name: receivers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receivers (receiver_id, user_id, blood_type, medical_condition, urgency_level) FROM stdin;
1	7	B-	Appendix Operation	low
\.


--
-- TOC entry 4946 (class 0 OID 24756)
-- Dependencies: 230
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (transaction_id, donor_id, receiver_id, blood_type, units, transaction_date, transaction_type, notes) FROM stdin;
\.


--
-- TOC entry 4934 (class 0 OID 24653)
-- Dependencies: 218
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, email, password_hash, role, full_name, phone, address, city, state, date_of_birth, created_at, is_active) FROM stdin;
2	abi@gmail.com	$2b$12$CJpuSKwBDDaOtQtcnSqIv.RpN60fygztr8wx9q2eCsPhaUTwHsiWy	donor	Abi	6369694993	\N	Chennai	Tamil Nadu	\N	2025-11-22 05:32:15.570797	t
3	akash@gmail.com	$2b$12$jYbX3zNA3tYdMXFTJHOABe3XcaLES0ekYbPAidOdK9CXjxZzP.vTq	donor	Akash	6374375959	\N	Chennai	Tamil Nadu	\N	2025-11-22 05:38:05.781601	t
4	donor2@test.com	$2b$12$zdJ9/l7clMnIsc56YvsqGeyqRWKeDGpYf3IUOV5aFyMkALoifiFNy	donor	Jane Smith	9876543211	\N	Mumbai	Maharashtra	\N	2025-11-22 05:39:15.290359	t
5	donor1@test.com	$2b$12$oUojgYADjku/zv02n7rjue3sC6cHWPJZr/jZwrHImwekWOty.Phtm	donor	John Doe	9876543210	\N	Chennai	Tamil Nadu	\N	2025-11-22 05:45:57.971083	t
6	sasuganth@gmail.com	$2b$12$8C156pBXbjHFR3y.UTgw2eBURBOpg8xAZiNCY1eFs./xaemgCaylW	donor	Suganth	6567867854	\N	Namakkal	Tamilnadu	\N	2025-11-22 06:07:26.175979	t
7	madhan@gmail.com	$2b$12$vt76JvM1J2RThsgnnvuzheTTTCzFpqgE0g5UM4Nknx452zv/Z3NeG	receiver	Madhan	6789689965	\N	Pudhukottai	TamilNadu	\N	2025-11-22 06:11:00.386699	t
8	admin@gmail.com	$2b$12$kZFIAkaoRQ/l3RHrvplEr.o.7nn4JhRXf5Ea9ASl3quqjKbT.qtuu	admin	Admin	9876543210	\N	Chennai	TamilNadu	\N	2025-11-22 13:16:19.345751	t
9	admin@bloodbank.com	$2b$12$.3CFbCfs9zORh/w3sXX4fewC9Jwmtd7/V7Sglo50Tb4Al5JwNrzfO	admin	System Administrator	1234567890	\N	Chennai	Tamil Nadu	\N	2025-11-22 13:21:56.920861	t
\.


--
-- TOC entry 4959 (class 0 OID 0)
-- Dependencies: 223
-- Name: blood_inventory_inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.blood_inventory_inventory_id_seq', 1, true);


--
-- TOC entry 4960 (class 0 OID 0)
-- Dependencies: 227
-- Name: blood_requests_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.blood_requests_request_id_seq', 1, false);


--
-- TOC entry 4961 (class 0 OID 0)
-- Dependencies: 225
-- Name: donation_requests_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.donation_requests_request_id_seq', 1, false);


--
-- TOC entry 4962 (class 0 OID 0)
-- Dependencies: 219
-- Name: donors_donor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.donors_donor_id_seq', 5, true);


--
-- TOC entry 4963 (class 0 OID 0)
-- Dependencies: 221
-- Name: receivers_receiver_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receivers_receiver_id_seq', 1, true);


--
-- TOC entry 4964 (class 0 OID 0)
-- Dependencies: 229
-- Name: transactions_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_transaction_id_seq', 1, false);


--
-- TOC entry 4965 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 9, true);


--
-- TOC entry 4770 (class 2606 OID 24709)
-- Name: blood_inventory blood_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blood_inventory
    ADD CONSTRAINT blood_inventory_pkey PRIMARY KEY (inventory_id);


--
-- TOC entry 4776 (class 2606 OID 24749)
-- Name: blood_requests blood_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blood_requests
    ADD CONSTRAINT blood_requests_pkey PRIMARY KEY (request_id);


--
-- TOC entry 4773 (class 2606 OID 24725)
-- Name: donation_requests donation_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation_requests
    ADD CONSTRAINT donation_requests_pkey PRIMARY KEY (request_id);


--
-- TOC entry 4764 (class 2606 OID 24676)
-- Name: donors donors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donors
    ADD CONSTRAINT donors_pkey PRIMARY KEY (donor_id);


--
-- TOC entry 4768 (class 2606 OID 24693)
-- Name: receivers receivers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receivers
    ADD CONSTRAINT receivers_pkey PRIMARY KEY (receiver_id);


--
-- TOC entry 4779 (class 2606 OID 24765)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- TOC entry 4760 (class 2606 OID 24665)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4762 (class 2606 OID 24663)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4777 (class 1259 OID 24782)
-- Name: idx_blood_requests_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_blood_requests_status ON public.blood_requests USING btree (status);


--
-- TOC entry 4774 (class 1259 OID 24781)
-- Name: idx_donation_requests_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_donation_requests_status ON public.donation_requests USING btree (status);


--
-- TOC entry 4765 (class 1259 OID 24778)
-- Name: idx_donors_blood_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_donors_blood_type ON public.donors USING btree (blood_type);


--
-- TOC entry 4771 (class 1259 OID 24780)
-- Name: idx_inventory_blood_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inventory_blood_type ON public.blood_inventory USING btree (blood_type);


--
-- TOC entry 4766 (class 1259 OID 24779)
-- Name: idx_receivers_blood_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_receivers_blood_type ON public.receivers USING btree (blood_type);


--
-- TOC entry 4757 (class 1259 OID 24776)
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- TOC entry 4758 (class 1259 OID 24777)
-- Name: idx_users_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_role ON public.users USING btree (role);


--
-- TOC entry 4782 (class 2606 OID 24710)
-- Name: blood_inventory blood_inventory_donor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blood_inventory
    ADD CONSTRAINT blood_inventory_donor_id_fkey FOREIGN KEY (donor_id) REFERENCES public.donors(donor_id);


--
-- TOC entry 4785 (class 2606 OID 24750)
-- Name: blood_requests blood_requests_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blood_requests
    ADD CONSTRAINT blood_requests_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.receivers(receiver_id);


--
-- TOC entry 4783 (class 2606 OID 24726)
-- Name: donation_requests donation_requests_donor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation_requests
    ADD CONSTRAINT donation_requests_donor_id_fkey FOREIGN KEY (donor_id) REFERENCES public.donors(donor_id);


--
-- TOC entry 4784 (class 2606 OID 24731)
-- Name: donation_requests donation_requests_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation_requests
    ADD CONSTRAINT donation_requests_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.receivers(receiver_id);


--
-- TOC entry 4780 (class 2606 OID 24677)
-- Name: donors donors_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donors
    ADD CONSTRAINT donors_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4781 (class 2606 OID 24694)
-- Name: receivers receivers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receivers
    ADD CONSTRAINT receivers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4786 (class 2606 OID 24766)
-- Name: transactions transactions_donor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_donor_id_fkey FOREIGN KEY (donor_id) REFERENCES public.donors(donor_id);


--
-- TOC entry 4787 (class 2606 OID 24771)
-- Name: transactions transactions_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.receivers(receiver_id);


-- Completed on 2025-11-22 20:39:22

--
-- PostgreSQL database dump complete
--

