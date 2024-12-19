--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

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

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: address_standardizer; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS address_standardizer WITH SCHEMA public;


--
-- Name: EXTENSION address_standardizer; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION address_standardizer IS 'Used to parse an address into constituent elements. Generally used to support geocoding address normalization step.';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: pgrouting; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgrouting WITH SCHEMA public;


--
-- Name: EXTENSION pgrouting; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgrouting IS 'pgRouting Extension';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- Name: buffer_result_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.buffer_result_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.buffer_result_id_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: buffer_result; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.buffer_result (
    id integer DEFAULT nextval('public.buffer_result_id_seq'::regclass) NOT NULL,
    buffered_gemo public.geometry(MultiPolygon,3857)
);


ALTER TABLE public.buffer_result OWNER TO postgres;

--
-- Name: building; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.building (
    id integer NOT NULL,
    geom public.geometry(MultiPolygonZ,3857),
    objectid bigint,
    name character varying(254)
);


ALTER TABLE public.building OWNER TO postgres;

--
-- Name: building_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_id_seq OWNER TO postgres;

--
-- Name: building_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.building_id_seq OWNED BY public.building.id;


--
-- Name: lantern; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lantern (
    id integer NOT NULL,
    geom public.geometry(PointZ,4326),
    status boolean,
    name character varying(10)
);


ALTER TABLE public.lantern OWNER TO postgres;

--
-- Name: paths; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paths (
    id integer NOT NULL,
    start_point public.geometry(Point,3857),
    end_point public.geometry(Point,3857),
    start_node integer,
    end_node integer,
    path public.geometry(MultiLineString,3857),
    total_cost double precision,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.paths OWNER TO postgres;

--
-- Name: paths_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paths_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.paths_id_seq OWNER TO postgres;

--
-- Name: paths_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.paths_id_seq OWNED BY public.paths.id;


--
-- Name: roadnet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roadnet (
    id integer NOT NULL,
    geom public.geometry(LineString,3857),
    fid_roadnn bigint,
    shape_leng double precision,
    source integer,
    target integer,
    cost double precision,
    reverse_cost double precision
);


ALTER TABLE public.roadnet OWNER TO postgres;

--
-- Name: roadnet_vertices_pgr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roadnet_vertices_pgr (
    id bigint NOT NULL,
    cnt integer,
    chk integer,
    ein integer,
    eout integer,
    the_geom public.geometry(Point,3857)
);


ALTER TABLE public.roadnet_vertices_pgr OWNER TO postgres;

--
-- Name: roadnet_vertices_pgr_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roadnet_vertices_pgr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roadnet_vertices_pgr_id_seq OWNER TO postgres;

--
-- Name: roadnet_vertices_pgr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roadnet_vertices_pgr_id_seq OWNED BY public.roadnet_vertices_pgr.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: building id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.building ALTER COLUMN id SET DEFAULT nextval('public.building_id_seq'::regclass);


--
-- Name: paths id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paths ALTER COLUMN id SET DEFAULT nextval('public.paths_id_seq'::regclass);


--
-- Name: roadnet_vertices_pgr id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roadnet_vertices_pgr ALTER COLUMN id SET DEFAULT nextval('public.roadnet_vertices_pgr_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: buffer_result buffer_result_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buffer_result
    ADD CONSTRAINT buffer_result_pkey PRIMARY KEY (id);


--
-- Name: building building_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.building
    ADD CONSTRAINT building_pkey PRIMARY KEY (id);


--
-- Name: lantern lantern_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lantern
    ADD CONSTRAINT lantern_pkey PRIMARY KEY (id);


--
-- Name: paths paths_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paths
    ADD CONSTRAINT paths_pkey PRIMARY KEY (id);


--
-- Name: roadnet roadnet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roadnet
    ADD CONSTRAINT roadnet_pkey PRIMARY KEY (id);


--
-- Name: roadnet_vertices_pgr roadnet_vertices_pgr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roadnet_vertices_pgr
    ADD CONSTRAINT roadnet_vertices_pgr_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: roadnet_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX roadnet_geom_idx ON public.roadnet USING gist (geom);


--
-- Name: roadnet_source_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX roadnet_source_idx ON public.roadnet USING btree (source);


--
-- Name: roadnet_target_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX roadnet_target_idx ON public.roadnet USING btree (target);


--
-- Name: roadnet_vertices_pgr_the_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX roadnet_vertices_pgr_the_geom_idx ON public.roadnet_vertices_pgr USING gist (the_geom);


--
-- PostgreSQL database dump complete
--

