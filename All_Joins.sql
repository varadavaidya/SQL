create table employees1(
    emp_id VARCHAR(20) PRIMARY KEy,
    emp_name VARCHAR(255),
    salary INT,
    dept_id VARCHAR(20),
    manager_id VARCHAR(20)
);

insert into employees1 values ("E1","Rahul",15000,"D1","M1"),("E2","Manoj",15000,"D1","M1"),
("E3","James",55000,"D2","M2"),("E4","Michael",25000,"D2","M2"),("E5","Ali",20000,"D10","M3"),
("E6","Robin","35000","D10","M3") ;

create table department1(
    dept_id VARCHAR(20) primary key,
    dept_name VARCHAR(255)
);

insert into department1 values ("D1","IT"),("D2","HR"),("D3","Finance"),("D4","Admin");



create table manager1(
    manager_id VARCHAR(20) primary key,
    manager_name VARCHAR(255),
    dept_id VARCHAR(20) 
);

insert into manager1 values("M1","Prem","D3"),("M2","Shripadh","D4"),("M3","Nick","D1"),("M4","Cory","D1");


create table projects1(
    project_id VARCHAR(20) ,
    project_name VARCHAR(255),
    team_member_id VARCHAR(20)
);

insert into projects1 values("P1","Data Migration","E1"),("P1","Data Migration","E2"),("P1","Data Migration","M3"),("P2","ETL Tool","E1"),("P2","ETL Tool","M4");

select employees1.emp_name,department1.dept_name 
from employees1 
join department1 
on employees1.dept_id=department1.dept_id;

select employees1.emp_name,department1.dept_name 
from employees1 
left join department1 
on employees1.dept_id=department1.dept_id;

select employees1.emp_name,department1.dept_name 
from employees1 
right join department1 
on employees1.dept_id=department1.dept_id;


#multiple joins
select employees1.emp_name,department1.dept_name,manager1.manager_name,projects1.project_name 
from employees1 
left join department1 on employees1.dept_id=department1.dept_id  
inner join manager1 on manager1.manager_id  = employees1.manager_id  
left join projects1 on employees1.emp_id=projects1.team_member_id;

#FULL JOIN
select employees1.emp_name,department1.dept_name 
from employees1 
left join department1 
on employees1.dept_id=department1.dept_id

UNION

select employees1.emp_name,department1.dept_name 
from employees1 
right join department1 
on employees1.dept_id=department1.dept_id

#FULL JOIN is not supported directly... DO BOTH left and right join
select employees1.emp_name,department1.dept_name 
from employees1 
full join department1 
on employees1.dept_id=department1.dept_id;


select employees1.emp_name,department1.dept_name 
from employees1 
cross join department1 ;


#CROSS JOIN
create table company(
    company_id VARCHAR(5),
    company_name VARCHAR(255),
    location VARCHAR(20));

insert into company values("C001","Googol","Sindhanur");

select employees1.emp_name,department1.dept_name ,company.company_name,company.location
from employees1 
left join department1 on employees1.dept_id =department1.dept_id 
cross join company;

#NATURAL JOIN___NO need of ON statement 
select employees1.emp_name,department1.dept_name 
from employees1 
natural join department1 ; #success becase of same column names in both tables

select employees1.emp_name,company.company_name
from employees1 
natural join company;  #unsuccess because no common name of column in two tables.returns cross JOIN

drop table family;
create table family(
    member_id VARCHAR(5),
    name VARCHAR(255),
    age INT(20),
    parent_id VARCHAR(5)
);

insert into family values ("F1","David",4,"F5");

select * from family;

#SELF JOIN

select child.name as child_name , parent.name as parent_name
from family as child
join family as parent 
on child.member_id =parent.parent_id;

select child.name as child_name , parent.name as parent_name
from family as child
left join family as parent 
on child.member_id =parent.parent_id;

select child.name as child_name , parent.name as parent_name
from family as child
right join family as parent 
on child.member_id =parent.parent_id;


