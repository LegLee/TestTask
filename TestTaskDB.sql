--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

-- Started on 2023-03-25 12:00:12

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
-- TOC entry 246 (class 1255 OID 16650)
-- Name: delete_worker(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_worker(IN id_work integer, IN id_group integer)
    LANGUAGE sql
    AS $$
 delete from study_group_worker where id_worker = id_work and id_study_group = id_group;
$$;


ALTER PROCEDURE public.delete_worker(IN id_work integer, IN id_group integer) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 16630)
-- Name: insert_worker(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.insert_worker(IN id_worker integer, IN id_study_group integer)
    LANGUAGE sql
    AS $$
 insert into study_group_worker values (id_study_group, id_worker)
$$;


ALTER PROCEDURE public.insert_worker(IN id_worker integer, IN id_study_group integer) OWNER TO postgres;

--
-- TOC entry 228 (class 1255 OID 16624)
-- Name: return_study_group(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.return_study_group() RETURNS TABLE(id integer, group_name text, teacher_name text, count_workers integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select study_groups.id, study_groups.name, teachers.name, (select count(*)::int from study_group_worker where study_group_worker.id_study_group=study_groups.id)
	from study_groups
		join teachers on teachers.id = study_groups.id_teacher
	order by study_groups.id;
end;$$;


ALTER FUNCTION public.return_study_group() OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 16628)
-- Name: return_study_group_teacher(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.return_study_group_teacher(id_group integer) RETURNS TABLE(id integer, study_group_name text, teacher_name text)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select study_groups.id, study_groups.name, teachers.name from study_groups
		join teachers on study_groups.id_teacher = teachers.id
	where study_groups.id = id_group;
end;$$;


ALTER FUNCTION public.return_study_group_teacher(id_group integer) OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 16626)
-- Name: return_study_group_workers(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.return_study_group_workers(id_group integer) RETURNS TABLE(id integer, worker_name text, organization_name text)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select study_group_worker.id_worker, workers.name, organizations.name  from workers
		join organizations on workers.id_organization = organizations.id
		join study_group_worker on workers.id = study_group_worker.id_worker
	where study_group_worker.id_study_group = id_group;
end;$$;


ALTER FUNCTION public.return_study_group_workers(id_group integer) OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 16639)
-- Name: return_teacher(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.return_teacher(id_group integer) RETURNS TABLE(id integer, name text)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select teachers.id, teachers.name from study_groups
		join teachers on study_groups.id_teacher = teachers.id
	where study_groups.id = id_group;
end;$$;


ALTER FUNCTION public.return_teacher(id_group integer) OWNER TO postgres;

--
-- TOC entry 245 (class 1255 OID 16649)
-- Name: return_workers(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.return_workers(id_group integer, id_org integer) RETURNS TABLE(id_work integer, name_work text)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select id, name from workers where id_organization=id_org and 
		(select count(*) from study_group_worker where id_study_group = id_group 
		and workers.id = study_group_worker.id_worker ) = 0;
end;$$;


ALTER FUNCTION public.return_workers(id_group integer, id_org integer) OWNER TO postgres;

--
-- TOC entry 226 (class 1255 OID 16619)
-- Name: study_group_insert(text, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.study_group_insert(IN name text, IN id_teacher integer DEFAULT 0, IN id_course integer DEFAULT 0)
    LANGUAGE sql
    AS $$
	insert into study_groups (name, id_teacher, id_course) values (name, id_teacher, id_course);
$$;


ALTER PROCEDURE public.study_group_insert(IN name text, IN id_teacher integer, IN id_course integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16508)
-- Name: teachers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teachers (
    id integer NOT NULL,
    name text NOT NULL,
    email text NOT NULL
);


ALTER TABLE public.teachers OWNER TO postgres;

--
-- TOC entry 225 (class 1255 OID 16617)
-- Name: teachers_select(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.teachers_select() RETURNS SETOF public.teachers
    LANGUAGE plpgsql
    AS $$
begin
	return query select * from teachers;
end
$$;


ALTER FUNCTION public.teachers_select() OWNER TO postgres;

--
-- TOC entry 244 (class 1255 OID 16648)
-- Name: test(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.test(id_group integer, id_org integer) RETURNS TABLE(id_test integer, name_test text)
    LANGUAGE plpgsql
    AS $$
begin
	if (select count(*) from study_group_worker where id_study_group != 5) >0 then select id, name from workers where id_organization=0;
	end if;
end;$$;


ALTER FUNCTION public.test(id_group integer, id_org integer) OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 16637)
-- Name: update_study_group_name(integer, text); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_study_group_name(IN new_id integer, IN new_name text)
    LANGUAGE sql
    AS $$
	update study_groups set name=new_name where id=new_id
$$;


ALTER PROCEDURE public.update_study_group_name(IN new_id integer, IN new_name text) OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16540)
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16539)
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.courses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.courses_id_seq OWNER TO postgres;

--
-- TOC entry 3394 (class 0 OID 0)
-- Dependencies: 218
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.courses_id_seq OWNED BY public.courses.id;


--
-- TOC entry 217 (class 1259 OID 16521)
-- Name: organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organizations (
    id integer NOT NULL,
    name text NOT NULL,
    tin text NOT NULL,
    id_teacher integer DEFAULT 0
);


ALTER TABLE public.organizations OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16520)
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organizations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organizations_id_seq OWNER TO postgres;

--
-- TOC entry 3395 (class 0 OID 0)
-- Dependencies: 216
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- TOC entry 221 (class 1259 OID 16551)
-- Name: study_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_groups (
    id integer NOT NULL,
    name text NOT NULL,
    id_teacher integer DEFAULT 0 NOT NULL,
    id_course integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.study_groups OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16550)
-- Name: study_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.study_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.study_group_id_seq OWNER TO postgres;

--
-- TOC entry 3396 (class 0 OID 0)
-- Dependencies: 220
-- Name: study_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.study_group_id_seq OWNED BY public.study_groups.id;


--
-- TOC entry 224 (class 1259 OID 16602)
-- Name: study_group_worker; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_group_worker (
    id_study_group integer NOT NULL,
    id_worker integer NOT NULL
);


ALTER TABLE public.study_group_worker OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16507)
-- Name: teachers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teachers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teachers_id_seq OWNER TO postgres;

--
-- TOC entry 3397 (class 0 OID 0)
-- Dependencies: 214
-- Name: teachers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teachers_id_seq OWNED BY public.teachers.id;


--
-- TOC entry 223 (class 1259 OID 16583)
-- Name: workers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workers (
    id integer NOT NULL,
    name text NOT NULL,
    id_organization integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.workers OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16582)
-- Name: workers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workers_id_seq OWNER TO postgres;

--
-- TOC entry 3398 (class 0 OID 0)
-- Dependencies: 222
-- Name: workers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workers_id_seq OWNED BY public.workers.id;


--
-- TOC entry 3211 (class 2604 OID 16543)
-- Name: courses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses ALTER COLUMN id SET DEFAULT nextval('public.courses_id_seq'::regclass);


--
-- TOC entry 3209 (class 2604 OID 16524)
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- TOC entry 3212 (class 2604 OID 16554)
-- Name: study_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_groups ALTER COLUMN id SET DEFAULT nextval('public.study_group_id_seq'::regclass);


--
-- TOC entry 3208 (class 2604 OID 16511)
-- Name: teachers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers ALTER COLUMN id SET DEFAULT nextval('public.teachers_id_seq'::regclass);


--
-- TOC entry 3215 (class 2604 OID 16586)
-- Name: workers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workers ALTER COLUMN id SET DEFAULT nextval('public.workers_id_seq'::regclass);


--
-- TOC entry 3230 (class 2606 OID 16549)
-- Name: courses courses_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_name_key UNIQUE (name);


--
-- TOC entry 3232 (class 2606 OID 16547)
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- TOC entry 3224 (class 2606 OID 16531)
-- Name: organizations organizations_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_name_key UNIQUE (name);


--
-- TOC entry 3226 (class 2606 OID 16529)
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- TOC entry 3228 (class 2606 OID 16533)
-- Name: organizations organizations_tin_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_tin_key UNIQUE (tin);


--
-- TOC entry 3234 (class 2606 OID 16561)
-- Name: study_groups study_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_groups
    ADD CONSTRAINT study_group_name_key UNIQUE (name);


--
-- TOC entry 3236 (class 2606 OID 16559)
-- Name: study_groups study_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_groups
    ADD CONSTRAINT study_group_pkey PRIMARY KEY (id);


--
-- TOC entry 3218 (class 2606 OID 16519)
-- Name: teachers teachers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_email_key UNIQUE (email);


--
-- TOC entry 3220 (class 2606 OID 16517)
-- Name: teachers teachers_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_name_key UNIQUE (name);


--
-- TOC entry 3222 (class 2606 OID 16515)
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (id);


--
-- TOC entry 3238 (class 2606 OID 16593)
-- Name: workers workers_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workers
    ADD CONSTRAINT workers_name_key UNIQUE (name);


--
-- TOC entry 3240 (class 2606 OID 16591)
-- Name: workers workers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workers
    ADD CONSTRAINT workers_pkey PRIMARY KEY (id);


--
-- TOC entry 3241 (class 2606 OID 16569)
-- Name: organizations organizations_id_teacher_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_id_teacher_fkey FOREIGN KEY (id_teacher) REFERENCES public.teachers(id) ON UPDATE CASCADE ON DELETE SET DEFAULT;


--
-- TOC entry 3242 (class 2606 OID 16577)
-- Name: study_groups study_group_id_course_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_groups
    ADD CONSTRAINT study_group_id_course_fkey FOREIGN KEY (id_course) REFERENCES public.courses(id) ON UPDATE CASCADE ON DELETE SET DEFAULT;


--
-- TOC entry 3243 (class 2606 OID 16564)
-- Name: study_groups study_group_id_teacher_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_groups
    ADD CONSTRAINT study_group_id_teacher_fkey FOREIGN KEY (id_teacher) REFERENCES public.teachers(id) ON UPDATE CASCADE ON DELETE SET DEFAULT;


--
-- TOC entry 3245 (class 2606 OID 16605)
-- Name: study_group_worker study_group_worker_id_study_group_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_group_worker
    ADD CONSTRAINT study_group_worker_id_study_group_fkey FOREIGN KEY (id_study_group) REFERENCES public.study_groups(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3246 (class 2606 OID 16610)
-- Name: study_group_worker study_group_worker_id_worker_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_group_worker
    ADD CONSTRAINT study_group_worker_id_worker_fkey FOREIGN KEY (id_worker) REFERENCES public.workers(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3244 (class 2606 OID 16594)
-- Name: workers workers_id_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workers
    ADD CONSTRAINT workers_id_organization_fkey FOREIGN KEY (id_organization) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE SET DEFAULT;


-- Completed on 2023-03-25 12:00:12

--
-- PostgreSQL database dump complete
--

