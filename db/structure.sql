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
-- Name: history; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA IF NOT EXISTS history;


--
-- Name: temporal; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA IF NOT EXISTS temporal;


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: chronomodel_cities_delete(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_cities_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE _now timestamp;
    BEGIN
        _now := timezone('UTC', now());

        DELETE FROM history.cities
        WHERE id = old.id AND validity = tsrange(_now, NULL);

        UPDATE history.cities SET validity = tsrange(lower(validity), _now)
        WHERE id = old.id AND upper_inf(validity);

        DELETE FROM ONLY temporal.cities
        WHERE id = old.id;

        RETURN OLD;
    END;

$$;


--
-- Name: chronomodel_cities_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_cities_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF NEW.id IS NULL THEN
            NEW.id := nextval('temporal.cities_id_seq');
        END IF;

        INSERT INTO temporal.cities ( id, "country_id", "name", "created_at", "updated_at" )
        VALUES ( NEW.id, NEW."country_id", NEW."name", NEW."created_at", NEW."updated_at" );

        INSERT INTO history.cities ( id, "country_id", "name", "created_at", "updated_at", validity )
        VALUES ( NEW.id, NEW."country_id", NEW."name", NEW."created_at", NEW."updated_at", tsrange(timezone('UTC', now()), NULL) );

        RETURN NEW;
    END;

$$;


--
-- Name: chronomodel_cities_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_cities_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE _now timestamp;
    DECLARE _hid integer;
    DECLARE _old record;
    DECLARE _new record;
    BEGIN
        IF OLD IS NOT DISTINCT FROM NEW THEN
            RETURN NULL;
        END IF;

        _old := row(OLD."country_id", OLD."name", OLD."created_at");
        _new := row(NEW."country_id", NEW."name", NEW."created_at");

        IF _old IS NOT DISTINCT FROM _new THEN
            UPDATE ONLY temporal.cities SET ( "country_id", "name", "created_at", "updated_at" ) = ( NEW."country_id", NEW."name", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;
            RETURN NEW;
        END IF;

        _now := timezone('UTC', now());
        _hid := NULL;

        SELECT hid INTO _hid FROM history.cities WHERE id = OLD.id AND lower(validity) = _now;

        IF _hid IS NOT NULL THEN
            UPDATE history.cities SET ( "country_id", "name", "created_at", "updated_at" ) = ( NEW."country_id", NEW."name", NEW."created_at", NEW."updated_at" ) WHERE hid = _hid;
        ELSE
            UPDATE history.cities SET validity = tsrange(lower(validity), _now)
            WHERE id = OLD.id AND upper_inf(validity);

            INSERT INTO history.cities ( id, "country_id", "name", "created_at", "updated_at", validity )
                VALUES ( OLD.id, NEW."country_id", NEW."name", NEW."created_at", NEW."updated_at", tsrange(_now, NULL) );
        END IF;

        UPDATE ONLY temporal.cities SET ( "country_id", "name", "created_at", "updated_at" ) = ( NEW."country_id", NEW."name", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;

        RETURN NEW;
    END;

$$;


--
-- Name: chronomodel_countries_delete(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_countries_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE _now timestamp;
    BEGIN
        _now := timezone('UTC', now());

        DELETE FROM history.countries
        WHERE id = old.id AND validity = tsrange(_now, NULL);

        UPDATE history.countries SET validity = tsrange(lower(validity), _now)
        WHERE id = old.id AND upper_inf(validity);

        DELETE FROM ONLY temporal.countries
        WHERE id = old.id;

        RETURN OLD;
    END;

$$;


--
-- Name: chronomodel_countries_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_countries_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF NEW.id IS NULL THEN
            NEW.id := nextval('temporal.countries_id_seq');
        END IF;

        INSERT INTO temporal.countries ( id, "name", "created_at", "updated_at" )
        VALUES ( NEW.id, NEW."name", NEW."created_at", NEW."updated_at" );

        INSERT INTO history.countries ( id, "name", "created_at", "updated_at", validity )
        VALUES ( NEW.id, NEW."name", NEW."created_at", NEW."updated_at", tsrange(timezone('UTC', now()), NULL) );

        RETURN NEW;
    END;

$$;


--
-- Name: chronomodel_countries_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_countries_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE _now timestamp;
    DECLARE _hid integer;
    DECLARE _old record;
    DECLARE _new record;
    BEGIN
        IF OLD IS NOT DISTINCT FROM NEW THEN
            RETURN NULL;
        END IF;

        _old := row(OLD."name", OLD."created_at");
        _new := row(NEW."name", NEW."created_at");

        IF _old IS NOT DISTINCT FROM _new THEN
            UPDATE ONLY temporal.countries SET ( "name", "created_at", "updated_at" ) = ( NEW."name", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;
            RETURN NEW;
        END IF;

        _now := timezone('UTC', now());
        _hid := NULL;

        SELECT hid INTO _hid FROM history.countries WHERE id = OLD.id AND lower(validity) = _now;

        IF _hid IS NOT NULL THEN
            UPDATE history.countries SET ( "name", "created_at", "updated_at" ) = ( NEW."name", NEW."created_at", NEW."updated_at" ) WHERE hid = _hid;
        ELSE
            UPDATE history.countries SET validity = tsrange(lower(validity), _now)
            WHERE id = OLD.id AND upper_inf(validity);

            INSERT INTO history.countries ( id, "name", "created_at", "updated_at", validity )
                VALUES ( OLD.id, NEW."name", NEW."created_at", NEW."updated_at", tsrange(_now, NULL) );
        END IF;

        UPDATE ONLY temporal.countries SET ( "name", "created_at", "updated_at" ) = ( NEW."name", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;

        RETURN NEW;
    END;

$$;


--
-- Name: chronomodel_schools_delete(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_schools_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE _now timestamp;
    BEGIN
        _now := timezone('UTC', now());

        DELETE FROM history.schools
        WHERE id = old.id AND validity = tsrange(_now, NULL);

        UPDATE history.schools SET validity = tsrange(lower(validity), _now)
        WHERE id = old.id AND upper_inf(validity);

        DELETE FROM ONLY temporal.schools
        WHERE id = old.id;

        RETURN OLD;
    END;

$$;


--
-- Name: chronomodel_schools_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_schools_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF NEW.id IS NULL THEN
            NEW.id := nextval('temporal.schools_id_seq');
        END IF;

        INSERT INTO temporal.schools ( id, "city_id", "name", "created_at", "updated_at" )
        VALUES ( NEW.id, NEW."city_id", NEW."name", NEW."created_at", NEW."updated_at" );

        INSERT INTO history.schools ( id, "city_id", "name", "created_at", "updated_at", validity )
        VALUES ( NEW.id, NEW."city_id", NEW."name", NEW."created_at", NEW."updated_at", tsrange(timezone('UTC', now()), NULL) );

        RETURN NEW;
    END;

$$;


--
-- Name: chronomodel_schools_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_schools_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE _now timestamp;
    DECLARE _hid integer;
    DECLARE _old record;
    DECLARE _new record;
    BEGIN
        IF OLD IS NOT DISTINCT FROM NEW THEN
            RETURN NULL;
        END IF;

        _old := row(OLD."city_id", OLD."name", OLD."created_at");
        _new := row(NEW."city_id", NEW."name", NEW."created_at");

        IF _old IS NOT DISTINCT FROM _new THEN
            UPDATE ONLY temporal.schools SET ( "city_id", "name", "created_at", "updated_at" ) = ( NEW."city_id", NEW."name", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;
            RETURN NEW;
        END IF;

        _now := timezone('UTC', now());
        _hid := NULL;

        SELECT hid INTO _hid FROM history.schools WHERE id = OLD.id AND lower(validity) = _now;

        IF _hid IS NOT NULL THEN
            UPDATE history.schools SET ( "city_id", "name", "created_at", "updated_at" ) = ( NEW."city_id", NEW."name", NEW."created_at", NEW."updated_at" ) WHERE hid = _hid;
        ELSE
            UPDATE history.schools SET validity = tsrange(lower(validity), _now)
            WHERE id = OLD.id AND upper_inf(validity);

            INSERT INTO history.schools ( id, "city_id", "name", "created_at", "updated_at", validity )
                VALUES ( OLD.id, NEW."city_id", NEW."name", NEW."created_at", NEW."updated_at", tsrange(_now, NULL) );
        END IF;

        UPDATE ONLY temporal.schools SET ( "city_id", "name", "created_at", "updated_at" ) = ( NEW."city_id", NEW."name", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;

        RETURN NEW;
    END;

$$;


--
-- Name: chronomodel_students_delete(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_students_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE _now timestamp;
    BEGIN
        _now := timezone('UTC', now());

        DELETE FROM history.students
        WHERE id = old.id AND validity = tsrange(_now, NULL);

        UPDATE history.students SET validity = tsrange(lower(validity), _now)
        WHERE id = old.id AND upper_inf(validity);

        DELETE FROM ONLY temporal.students
        WHERE id = old.id;

        RETURN OLD;
    END;

$$;


--
-- Name: chronomodel_students_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_students_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF NEW.id IS NULL THEN
            NEW.id := nextval('temporal.students_id_seq');
        END IF;

        INSERT INTO temporal.students ( id, "school_id", "name", "created_at", "updated_at" )
        VALUES ( NEW.id, NEW."school_id", NEW."name", NEW."created_at", NEW."updated_at" );

        INSERT INTO history.students ( id, "school_id", "name", "created_at", "updated_at", validity )
        VALUES ( NEW.id, NEW."school_id", NEW."name", NEW."created_at", NEW."updated_at", tsrange(timezone('UTC', now()), NULL) );

        RETURN NEW;
    END;

$$;


--
-- Name: chronomodel_students_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_students_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE _now timestamp;
    DECLARE _hid integer;
    DECLARE _old record;
    DECLARE _new record;
    BEGIN
        IF OLD IS NOT DISTINCT FROM NEW THEN
            RETURN NULL;
        END IF;

        _old := row(OLD."school_id", OLD."name", OLD."created_at");
        _new := row(NEW."school_id", NEW."name", NEW."created_at");

        IF _old IS NOT DISTINCT FROM _new THEN
            UPDATE ONLY temporal.students SET ( "school_id", "name", "created_at", "updated_at" ) = ( NEW."school_id", NEW."name", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;
            RETURN NEW;
        END IF;

        _now := timezone('UTC', now());
        _hid := NULL;

        SELECT hid INTO _hid FROM history.students WHERE id = OLD.id AND lower(validity) = _now;

        IF _hid IS NOT NULL THEN
            UPDATE history.students SET ( "school_id", "name", "created_at", "updated_at" ) = ( NEW."school_id", NEW."name", NEW."created_at", NEW."updated_at" ) WHERE hid = _hid;
        ELSE
            UPDATE history.students SET validity = tsrange(lower(validity), _now)
            WHERE id = OLD.id AND upper_inf(validity);

            INSERT INTO history.students ( id, "school_id", "name", "created_at", "updated_at", validity )
                VALUES ( OLD.id, NEW."school_id", NEW."name", NEW."created_at", NEW."updated_at", tsrange(_now, NULL) );
        END IF;

        UPDATE ONLY temporal.students SET ( "school_id", "name", "created_at", "updated_at" ) = ( NEW."school_id", NEW."name", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;

        RETURN NEW;
    END;

$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cities; Type: TABLE; Schema: temporal; Owner: -
--

CREATE TABLE temporal.cities (
    id bigint NOT NULL,
    country_id bigint,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cities; Type: TABLE; Schema: history; Owner: -
--

CREATE TABLE history.cities (
    hid bigint NOT NULL,
    validity tsrange NOT NULL,
    recorded_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
)
INHERITS (temporal.cities);


--
-- Name: cities_hid_seq; Type: SEQUENCE; Schema: history; Owner: -
--

CREATE SEQUENCE history.cities_hid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_hid_seq; Type: SEQUENCE OWNED BY; Schema: history; Owner: -
--

ALTER SEQUENCE history.cities_hid_seq OWNED BY history.cities.hid;


--
-- Name: countries; Type: TABLE; Schema: temporal; Owner: -
--

CREATE TABLE temporal.countries (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: countries; Type: TABLE; Schema: history; Owner: -
--

CREATE TABLE history.countries (
    hid bigint NOT NULL,
    validity tsrange NOT NULL,
    recorded_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
)
INHERITS (temporal.countries);


--
-- Name: countries_hid_seq; Type: SEQUENCE; Schema: history; Owner: -
--

CREATE SEQUENCE history.countries_hid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_hid_seq; Type: SEQUENCE OWNED BY; Schema: history; Owner: -
--

ALTER SEQUENCE history.countries_hid_seq OWNED BY history.countries.hid;


--
-- Name: schools; Type: TABLE; Schema: temporal; Owner: -
--

CREATE TABLE temporal.schools (
    id bigint NOT NULL,
    city_id bigint,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schools; Type: TABLE; Schema: history; Owner: -
--

CREATE TABLE history.schools (
    hid bigint NOT NULL,
    validity tsrange NOT NULL,
    recorded_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
)
INHERITS (temporal.schools);


--
-- Name: schools_hid_seq; Type: SEQUENCE; Schema: history; Owner: -
--

CREATE SEQUENCE history.schools_hid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schools_hid_seq; Type: SEQUENCE OWNED BY; Schema: history; Owner: -
--

ALTER SEQUENCE history.schools_hid_seq OWNED BY history.schools.hid;


--
-- Name: students; Type: TABLE; Schema: temporal; Owner: -
--

CREATE TABLE temporal.students (
    id bigint NOT NULL,
    school_id bigint,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: students; Type: TABLE; Schema: history; Owner: -
--

CREATE TABLE history.students (
    hid bigint NOT NULL,
    validity tsrange NOT NULL,
    recorded_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
)
INHERITS (temporal.students);


--
-- Name: students_hid_seq; Type: SEQUENCE; Schema: history; Owner: -
--

CREATE SEQUENCE history.students_hid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: students_hid_seq; Type: SEQUENCE OWNED BY; Schema: history; Owner: -
--

ALTER SEQUENCE history.students_hid_seq OWNED BY history.students.hid;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cities; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.cities AS
 SELECT cities.id,
    cities.country_id,
    cities.name,
    cities.created_at,
    cities.updated_at
   FROM ONLY temporal.cities;


--
-- Name: VIEW cities; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.cities IS '{"temporal":true,"chronomodel":"1.2.2"}';


--
-- Name: countries; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.countries AS
 SELECT countries.id,
    countries.name,
    countries.created_at,
    countries.updated_at
   FROM ONLY temporal.countries;


--
-- Name: VIEW countries; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.countries IS '{"temporal":true,"chronomodel":"1.2.2"}';


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: schools; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.schools AS
 SELECT schools.id,
    schools.city_id,
    schools.name,
    schools.created_at,
    schools.updated_at
   FROM ONLY temporal.schools;


--
-- Name: VIEW schools; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.schools IS '{"temporal":true,"chronomodel":"1.2.2"}';


--
-- Name: students; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.students AS
 SELECT students.id,
    students.school_id,
    students.name,
    students.created_at,
    students.updated_at
   FROM ONLY temporal.students;


--
-- Name: VIEW students; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.students IS '{"temporal":true,"chronomodel":"1.2.2"}';


--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: temporal; Owner: -
--

CREATE SEQUENCE temporal.cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: temporal; Owner: -
--

ALTER SEQUENCE temporal.cities_id_seq OWNED BY temporal.cities.id;


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: temporal; Owner: -
--

CREATE SEQUENCE temporal.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: temporal; Owner: -
--

ALTER SEQUENCE temporal.countries_id_seq OWNED BY temporal.countries.id;


--
-- Name: schools_id_seq; Type: SEQUENCE; Schema: temporal; Owner: -
--

CREATE SEQUENCE temporal.schools_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schools_id_seq; Type: SEQUENCE OWNED BY; Schema: temporal; Owner: -
--

ALTER SEQUENCE temporal.schools_id_seq OWNED BY temporal.schools.id;


--
-- Name: students_id_seq; Type: SEQUENCE; Schema: temporal; Owner: -
--

CREATE SEQUENCE temporal.students_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: temporal; Owner: -
--

ALTER SEQUENCE temporal.students_id_seq OWNED BY temporal.students.id;


--
-- Name: cities id; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.cities ALTER COLUMN id SET DEFAULT nextval('temporal.cities_id_seq'::regclass);


--
-- Name: cities hid; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.cities ALTER COLUMN hid SET DEFAULT nextval('history.cities_hid_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.countries ALTER COLUMN id SET DEFAULT nextval('temporal.countries_id_seq'::regclass);


--
-- Name: countries hid; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.countries ALTER COLUMN hid SET DEFAULT nextval('history.countries_hid_seq'::regclass);


--
-- Name: schools id; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.schools ALTER COLUMN id SET DEFAULT nextval('temporal.schools_id_seq'::regclass);


--
-- Name: schools hid; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.schools ALTER COLUMN hid SET DEFAULT nextval('history.schools_hid_seq'::regclass);


--
-- Name: students id; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.students ALTER COLUMN id SET DEFAULT nextval('temporal.students_id_seq'::regclass);


--
-- Name: students hid; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.students ALTER COLUMN hid SET DEFAULT nextval('history.students_hid_seq'::regclass);


--
-- Name: cities id; Type: DEFAULT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.cities ALTER COLUMN id SET DEFAULT nextval('temporal.cities_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.countries ALTER COLUMN id SET DEFAULT nextval('temporal.countries_id_seq'::regclass);


--
-- Name: schools id; Type: DEFAULT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.schools ALTER COLUMN id SET DEFAULT nextval('temporal.schools_id_seq'::regclass);


--
-- Name: students id; Type: DEFAULT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.students ALTER COLUMN id SET DEFAULT nextval('temporal.students_id_seq'::regclass);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (hid);


--
-- Name: cities cities_timeline_consistency; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.cities
    ADD CONSTRAINT cities_timeline_consistency EXCLUDE USING gist (id WITH =, validity WITH &&);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (hid);


--
-- Name: countries countries_timeline_consistency; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.countries
    ADD CONSTRAINT countries_timeline_consistency EXCLUDE USING gist (id WITH =, validity WITH &&);


--
-- Name: schools schools_pkey; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (hid);


--
-- Name: schools schools_timeline_consistency; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.schools
    ADD CONSTRAINT schools_timeline_consistency EXCLUDE USING gist (id WITH =, validity WITH &&);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (hid);


--
-- Name: students students_timeline_consistency; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.students
    ADD CONSTRAINT students_timeline_consistency EXCLUDE USING gist (id WITH =, validity WITH &&);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: schools schools_pkey; Type: CONSTRAINT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: cities_inherit_pkey; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX cities_inherit_pkey ON history.cities USING btree (id);


--
-- Name: cities_instance_history; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX cities_instance_history ON history.cities USING btree (id, recorded_at);


--
-- Name: cities_recorded_at; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX cities_recorded_at ON history.cities USING btree (recorded_at);


--
-- Name: countries_inherit_pkey; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX countries_inherit_pkey ON history.countries USING btree (id);


--
-- Name: countries_instance_history; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX countries_instance_history ON history.countries USING btree (id, recorded_at);


--
-- Name: countries_recorded_at; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX countries_recorded_at ON history.countries USING btree (recorded_at);


--
-- Name: index_cities_temporal_on_lower_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_cities_temporal_on_lower_validity ON history.cities USING btree (lower(validity));


--
-- Name: index_cities_temporal_on_upper_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_cities_temporal_on_upper_validity ON history.cities USING btree (upper(validity));


--
-- Name: index_cities_temporal_on_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_cities_temporal_on_validity ON history.cities USING gist (validity);


--
-- Name: index_countries_temporal_on_lower_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_countries_temporal_on_lower_validity ON history.countries USING btree (lower(validity));


--
-- Name: index_countries_temporal_on_upper_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_countries_temporal_on_upper_validity ON history.countries USING btree (upper(validity));


--
-- Name: index_countries_temporal_on_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_countries_temporal_on_validity ON history.countries USING gist (validity);


--
-- Name: index_schools_temporal_on_lower_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_schools_temporal_on_lower_validity ON history.schools USING btree (lower(validity));


--
-- Name: index_schools_temporal_on_upper_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_schools_temporal_on_upper_validity ON history.schools USING btree (upper(validity));


--
-- Name: index_schools_temporal_on_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_schools_temporal_on_validity ON history.schools USING gist (validity);


--
-- Name: index_students_temporal_on_lower_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_students_temporal_on_lower_validity ON history.students USING btree (lower(validity));


--
-- Name: index_students_temporal_on_upper_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_students_temporal_on_upper_validity ON history.students USING btree (upper(validity));


--
-- Name: index_students_temporal_on_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_students_temporal_on_validity ON history.students USING gist (validity);


--
-- Name: schools_inherit_pkey; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX schools_inherit_pkey ON history.schools USING btree (id);


--
-- Name: schools_instance_history; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX schools_instance_history ON history.schools USING btree (id, recorded_at);


--
-- Name: schools_recorded_at; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX schools_recorded_at ON history.schools USING btree (recorded_at);


--
-- Name: students_inherit_pkey; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX students_inherit_pkey ON history.students USING btree (id);


--
-- Name: students_instance_history; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX students_instance_history ON history.students USING btree (id, recorded_at);


--
-- Name: students_recorded_at; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX students_recorded_at ON history.students USING btree (recorded_at);


--
-- Name: index_cities_on_country_id; Type: INDEX; Schema: temporal; Owner: -
--

CREATE INDEX index_cities_on_country_id ON temporal.cities USING btree (country_id);


--
-- Name: index_schools_on_city_id; Type: INDEX; Schema: temporal; Owner: -
--

CREATE INDEX index_schools_on_city_id ON temporal.schools USING btree (city_id);


--
-- Name: index_students_on_school_id; Type: INDEX; Schema: temporal; Owner: -
--

CREATE INDEX index_students_on_school_id ON temporal.students USING btree (school_id);


--
-- Name: cities chronomodel_delete; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_delete INSTEAD OF DELETE ON public.cities FOR EACH ROW EXECUTE FUNCTION public.chronomodel_cities_delete();


--
-- Name: countries chronomodel_delete; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_delete INSTEAD OF DELETE ON public.countries FOR EACH ROW EXECUTE FUNCTION public.chronomodel_countries_delete();


--
-- Name: schools chronomodel_delete; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_delete INSTEAD OF DELETE ON public.schools FOR EACH ROW EXECUTE FUNCTION public.chronomodel_schools_delete();


--
-- Name: students chronomodel_delete; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_delete INSTEAD OF DELETE ON public.students FOR EACH ROW EXECUTE FUNCTION public.chronomodel_students_delete();


--
-- Name: cities chronomodel_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_insert INSTEAD OF INSERT ON public.cities FOR EACH ROW EXECUTE FUNCTION public.chronomodel_cities_insert();


--
-- Name: countries chronomodel_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_insert INSTEAD OF INSERT ON public.countries FOR EACH ROW EXECUTE FUNCTION public.chronomodel_countries_insert();


--
-- Name: schools chronomodel_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_insert INSTEAD OF INSERT ON public.schools FOR EACH ROW EXECUTE FUNCTION public.chronomodel_schools_insert();


--
-- Name: students chronomodel_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_insert INSTEAD OF INSERT ON public.students FOR EACH ROW EXECUTE FUNCTION public.chronomodel_students_insert();


--
-- Name: cities chronomodel_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_update INSTEAD OF UPDATE ON public.cities FOR EACH ROW EXECUTE FUNCTION public.chronomodel_cities_update();


--
-- Name: countries chronomodel_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_update INSTEAD OF UPDATE ON public.countries FOR EACH ROW EXECUTE FUNCTION public.chronomodel_countries_update();


--
-- Name: schools chronomodel_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_update INSTEAD OF UPDATE ON public.schools FOR EACH ROW EXECUTE FUNCTION public.chronomodel_schools_update();


--
-- Name: students chronomodel_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_update INSTEAD OF UPDATE ON public.students FOR EACH ROW EXECUTE FUNCTION public.chronomodel_students_update();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20210112191552'),
('20220519102012');


