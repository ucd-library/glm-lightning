drop schema if exists glm cascade;
create schema glm;

create type platform_type as ENUM('G16','G17');

create table glm.dataset (
       dataset_id uuid primary key,
       platform_id platform_type not null,
       dataset_name text unique,
       date_created timestamp not null,
       time_coverage_start timestamp not null,
       time_coverage_end timestamp not null
       );

create table glm.flash (
 flash_id integer not null,
 dataset_id uuid references glm.dataset,
 time_offset_of_first_event integer,
 time_offset_of_last_event integer,
 lat float,
 lon float,
 area integer,
 energy integer,
 quality_flag integer);

create index flash_dataset_id on flash(dataset_id);

create or replace function energy_J (f in glm.flash, out J float)
LANGUAGE SQL IMMUTABLE AS $$
select (f.energy::float * 9.99996e-16) + 2.8515e-16 as J;
$$;

create or replace function area_m2 (f in glm.flash, out m2 float)
LANGUAGE SQL IMMUTABLE AS $$
select (f.area::float * 152601.9) as m2;
$$;

create or replace function centroid (f in glm.flash, out centroid geometry(Point,4326))
LANGUAGE SQL IMMUTABLE AS $$
select st_setsrid(ST_MakePoint(f.lon,f.lat),4326) as centroid;
$$;

create or replace function start_time (f in glm.flash, out t timestamp)
LANGUAGE SQL IMMUTABLE AS $$
with o as ( select time_coverage_start as s
 from glm.dataset where dataset_id=f.dataset_id
)
select o.s+(((f.time_offset_of_first_event * 0.0003814756 ) -5) || ' seconds')::interval as t
from o;
$$;

create or replace function stop_time (f in glm.flash, out t timestamp)
LANGUAGE SQL IMMUTABLE AS $$
with o as ( select time_coverage_start as s
 from glm.dataset where dataset_id=f.dataset_id
)
select o.s+(((f.time_offset_of_last_event * 0.0003814756 ) -5) || ' seconds')::interval as t
from o;
$$;
