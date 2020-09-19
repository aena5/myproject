DROP TABLE IF EXISTS person;
DROP TYPE IF EXISTS gender_type;

CREATE TYPE gender_type AS ENUM('MALE','FEMALE');

CREATE TABLE person(
   id SERIAL PRIMARY KEY,
   first_name VARCHAR(50),
   last_name VARCHAR(50),
   birth_date DATE,
   gender gender_type,
   salary NUMERIC(400,2)
);

comment on column person.id is 'unique numerical value which automatically increments after a new record is inserted';
comment on column person.first_name is 'first name of the person; max length of 50';
comment on column person.last_name  is 'last name of the person; max length of 50';
comment on column person.birth_date is 'date of birth of the person';
comment on column person.gender     is 'indicates whether the person is MALE or FEMALE';
comment on column person.salary     is 'salary of person; should support up to 2 decimal points; negative value is not allowed';

INSERT INTO 
   person (first_name, last_name, birth_date, gender, salary)
VALUES 
   ('John','Doe','01-JAN-2020','MALE',10000.50),
   ('Mary','Jane','29-FEB-2020','FEMALE',5000.12);
   
COMMIT;

insert into person(
    first_name, last_name, birth_date, gender, salary
)
select
(ARRAY['Aiden','Anika','Ariya','Ashanti','Avery',
'Cameron','Ceri','Che','Danica','Darcy',
'Dion','Eman','Eren','Esme','Frankie',
'Gurdeep','Haiden','Indi','Isa','Jaskaran',
'Jaya','Jo ','Jodie','Kacey','Kameron',
'Kayden','Keeley','Kenzie','Lucca','Macauley',
'Manraj','Nur','Oluwatobiloba','Reiss','Riley',
'Rima','Ronnie','Ryley','Sam','Sana',
'Shola','Sierra','Tamika','Taran','Teagan',
'Tia','Tiegan','Virginia','Zhane','Zion'])[floor(random()*50)+1],
(ARRAY['Ahmad','Andersen','Arias','Barlow','Beck'
'Bloggs','Bowes','Buck','Burris','Cano'
'Chaney','Coombes','Correa','Coulson','Craig'
'Frye','Hackett','Hale','Huber','Hyde'
'Irving','Joyce','Kelley','Kim','Larson'
'Lynn','Markham','Mejia','Miranda','Neal'
'Newton','Novak','Ochoa','Pate','Paterson'
'Pennington','Rubio','Santana','Schaefer','Schofield'
'Shaffer','Sweeney','Talley','Trevino','Tucker'
'Velazquez','Vu','Wagner','Walton','Woodward'])[floor(random()*40)+1],
timestamp '1970-01-01' + random() * (timestamp '1970-01-01' - timestamp '2070-12-31'),
(ARRAY['FEMALE', 'MALE'])[floor(random()*2)+1]::gender_type,
floor(random()*(100000.00-1.00+1))+1.00
from generate_series(1, 1000000);

commit;

--PRE-A)
EXPLAIN (ANALYZE, BUFFERS) select * 
  from person
 where first_name = 'John'
   and last_name = 'Doe';

--PRE-B)
EXPLAIN (ANALYZE, BUFFERS) select * 
  from person
 where gender = 'FEMALE'
   and salary > 5000.50
   and birth_date >= (TIMESTAMP 'epoch' + 946684800 * INTERVAL '1 second') 
   and birth_date <= (TIMESTAMP 'epoch' + 1609372800 * INTERVAL '1 second');  

--PRE-C)
EXPLAIN (ANALYZE, BUFFERS) select count(1), gender, round(salary, 3)
   from person
  group by 2,3;   
  
DROP INDEX IF EXISTS person_name_idx;  
DROP INDEX IF EXISTS person_other_info_idx;  
DROP INDEX IF EXISTS person_gender_sal_idx;  
  
CREATE INDEX person_name_idx ON person (first_name, last_name); 
CREATE INDEX person_other_info_idx ON person (gender, salary, birth_date); 
CREATE INDEX person_gender_sal_idx ON person (salary, gender); 
ANALYZE person;

--POST-A)
EXPLAIN (ANALYZE, BUFFERS) select * 
  from person
 where first_name = 'John'
   and last_name = 'Doe';

--POST-B)
EXPLAIN (ANALYZE, BUFFERS) select * 
  from person
 where gender = 'FEMALE'
   and salary > 5000.50
   and birth_date >= (TIMESTAMP 'epoch' + 946684800 * INTERVAL '1 second') 
   and birth_date <= (TIMESTAMP 'epoch' + 1609372800 * INTERVAL '1 second');  

--POST-C.1)
EXPLAIN (ANALYZE, BUFFERS) select count(1), gender, round(salary, 3)
   from person
  group by 3, 2;    

--POST-C.2)
EXPLAIN (ANALYZE, BUFFERS) select count(1), gender, round(salary, 3)
   from person
  group by salary, gender;  


   
 
   