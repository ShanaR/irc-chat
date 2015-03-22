--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: msgs; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE msgs (
    msgid integer NOT NULL,
    message character varying(140),
    user_id integer
);


ALTER TABLE public.msgs OWNER TO postgres;

--
-- Name: msgs_msgid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE msgs_msgid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.msgs_msgid_seq OWNER TO postgres;

--
-- Name: msgs_msgid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE msgs_msgid_seq OWNED BY msgs.msgid;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    uid integer NOT NULL,
    username character varying(15) NOT NULL,
    fname character varying(20) NOT NULL,
    lname character varying(35) NOT NULL,
    password character varying(15) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_uid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_uid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_uid_seq OWNER TO postgres;

--
-- Name: users_uid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_uid_seq OWNED BY users.uid;


--
-- Name: msgid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY msgs ALTER COLUMN msgid SET DEFAULT nextval('msgs_msgid_seq'::regclass);


--
-- Name: uid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN uid SET DEFAULT nextval('users_uid_seq'::regclass);


--
-- Data for Name: msgs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY msgs (msgid, message, user_id) FROM stdin;
\.


--
-- Name: msgs_msgid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('msgs_msgid_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (uid, username, fname, lname, password) FROM stdin;
1	oaklandish	Ricky	Henderson	mishmash901
2	floral	Rifle	Paper	blosoms901
3	camino	Tracy	Turnblatt	password901
\.


--
-- Name: users_uid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('users_uid_seq', 3, true);


--
-- Name: msgs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY msgs
    ADD CONSTRAINT msgs_pkey PRIMARY KEY (msgid);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uid);


--
-- Name: msgs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY msgs
    ADD CONSTRAINT msgs_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(uid);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

