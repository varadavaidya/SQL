create table employee(
    emp_id INT primary key,
    first_name varchar(255),
    last_name varchar(255),
    birth_date DATE,
    sex  varchar(1),
    salary INT,
    super_id INT ,# dont yet declare as foreign key because you havent created the branch table
    branch_id int #same here
);


describe table employee;


create table branch(
    branch_id INT primary key ,
    branch_name VARCHAR(255),
    mgr_id INT,
    mgr_start_date DATE,
    foreign key(mgr_id) references employee(emp_id) on delete set NULL
);

create table client(
    client_id int primary key,
    client_name VARCHAR(255),
    branch_id int,
    foreign key(branch_id) references branch(branch_id) on delete set NULL
);



alter table employee 
add foreign key(super_id) 
references employee(emp_id) 
on delete set NULL;

alter table employee 
add foreign key(branch_id)
references branch(branch_id)
on delete set null;


select * from employee;
select * from branch;
select * from client;


create table works_with(
    emp_id INT ,
    client_id int,
    total_sales int,
    primary key(emp_id,client_id),
    foreign key(emp_id) references employee(emp_id) on delete cascade,
    foreign key(client_id) references client(client_id) on delete cascade
);


create table branch_supplier(
    branch_id int,
    supplier_name VARCHAR(255),
    supply_type VARCHAR(255),
    primary key(branch_id,supplier_name),
    foreign key(branch_id) references branch(branch_id) on delete cascade
);


insert into employee values(100,'David','Wallace','1967-11-17','M',250000,null,null);
insert into branch values(1,'Corporate',100,'2006-02-09');

update employee
set branch_id=1
where emp_id=100;


insert into employee values(101,'Jan','Levinson','1961-05-11','F',110000,100,1);

insert into client values();
insert into works_with values();
insert into branch_supplier values();


insert into employee values(102,'Michael','Scott','1964-03-15','M',75000,100,null);

insert into branch values(2,'Scranton',102,'1992-04-06');

update employee 
set branch_id=2
where emp_id=102;

insert into employee values(103,'Angela','Martin','1971-06-25','F',63000,102,2);
insert into employee values(104,'Kelly','Kapoor','1980-02-05','F',55000,102,2);
insert into employee values(105,'Stanley','Hudson','1958-02-19','M',69000,102,2);

insert into employee values(106,'Josh','Porter','1969-09-05','M',78000,100,null);

insert into branch values(3,'Stamford',106,'1998-02-13');

insert into employee values(107,'Andy','Bernard','1973-07-22','M',65000,106,3);
insert into employee values(108,'Jim','Halpert','1978-10-01','M',71000,106,3);

update employee
set branch_id=3
where emp_id=106;


insert into client values(400,'Dunmore Highschool',2);
insert into client values(401,'Lackawana county',2);
insert into client values(402,'FedEx',3);
insert into client values(403,'Jon Daly Law, LLC',3);
insert into client values(404,'Scranton Whitepages',2);
insert into client values(405,';Times Newspaper',3);
insert into client values(406,'FedEx',2);


insert into works_with values(105,400,55000);
insert into works_with values(102,401,267000);
insert into works_with values(108,402,22500);
insert into works_with values(107,403,5000);
insert into works_with values(108,403,12000);
insert into works_with values(105,404,33000);
insert into works_with values(107,405,26000);
insert into works_with values(102,406,15000);
insert into works_with values(105,406,130000);

select * from works_With;


insert into branch_supplier values(2,'Hammer Mill','Paper');
insert into branch_Supplier values(2,'Uni-ball','Writing utensils');
insert into branch_supplier values(3,'Patriot Paper','Paper');
insert into branch_supplier values (2,'J.T Forms and Labels','custom forms');
insert into branch_Supplier values(3,'hammer Mill','Paper');
insert into branch_Supplier values(3,'Uni-ball','Writing utensils');
insert into branch_supplier values(3,'Stamford Lables','Custom forms');

select * from branch_supplier;


select * from employee where salary>=70000 order by salary desc;


select * from employee order by sex, first_name,last_name;



select * from employee limit 5;


select first_name, last_name from employee;

select first_name as forename, last_name as surname from employee;


select distinct sex from employee;

select salary+1000 from employee;

#how many have no supervisor?
select count(emp_id)  from employee  where super_id is not NULL;

select count(emp_id) from employee where sex='F' AND birth_date>='1971-01-01';

select avg(salary) from employee;

#how many people of different sex?
select count(emp_id) from employee group by sex;

#how much sales did each employee make?
select sum(total_sales),emp_id from works_with group by emp_id;

#how much each client spent ?
select sum(total_sales),client_id from works_with group by client_id;


#WILDCARDS
select * from client where  client_name like '%dE%';

#who is born on october
select * from employee where birth_date like '____-10%';

#find a list of employee and branch names



#UNION
select emp_id 
from employee
UNION
select branch_name
from branch;

#removing Duplicates

select 'Hammer Mill' from branch_supplier
union 
select 'hammer Mill';


select 'Hammer Mill' from branch_supplier
union all
select 'hammer Mill';



#order by with union

select first_name from employee
union 
select branch_name from branch
order by first_name desc;



#JOINS

insert into branch values(4,'Buffalo',null,null);

delete from branch where branch_id=4;

select * from branch;


#branch and manager names joining employee and branch table
select employee.emp_id, employee.first_name, branch.branch_name
from employee
join branch
on employee.emp_id = branch.mgr_id;
#INNER JOIN
select employee.emp_id, employee.first_name, branch.branch_name
from branch
inner join employee
on employee.emp_id = branch.mgr_id;


#LEFT JOIN
select employee.emp_id, employee.first_name, branch.branch_name
from employee
left join branch
on employee.emp_id = branch.mgr_id;

#RIGHT JOIN
select employee.emp_id, employee.first_name, branch.branch_name
from employee
RIGHT    join branch
on employee.emp_id = branch.mgr_id;


#FULL OUTER JOIN
select employee.emp_id, employee.first_name, branch.branch_name
from employee
left join branch
on employee.emp_id = branch.mgr_id

UNION

select employee.emp_id, employee.first_name, branch.branch_name
from employee
RIGHT    join branch
on employee.emp_id = branch.mgr_id;

#total sales from each branch
select employee.branch_id, sum(works_with.total_sales)
from employee 
join works_with
on employee.emp_id=works_with.emp_id
group by employee.branch_id;



#find nmaes of all employees who have sold over 30000 to single client


select employee.first_name, employee.last_name
from employee
join works_with
on employee.emp_id=works_with.emp_id
where works_with.total_sales>30000 ;


#NESTED QUERY
select employee.first_name, employee.last_name
from employee
where employee.emp_id in (
    select works_with.emp_id
    from works_with
    where works_with.total_sales>30000 
);



#find all clients who are handled by the branch that michael scotet manages, assume you know michael scott's id

select client.client_name
from client 
where client.client_id in (
    select works_with.client_id
    from works_with
    join employee
    on works_with.emp_id=employee.emp_id
    where employee.branch_id in (
        select branch.branch_id
        from branch
        where branch.mgr_id=102
    )
);



describe first_one;


create table JSON_data;

#SUBQUERIES

select * from employee;

#SCALAR SUBQUERIES

select first_name 
from employee 
where salary>(select AVG(salary) from employee
);

select AVG(salary) from employee;

select *
from employee 
join (select avg(salary) as salary_avg from employee) as avg_salary
on employee.salary> avg_salary.salary_avg;

#MULTIPLE ROW OR COLUMN SUBQUERIES

select branch_id, max(salary) from employee 
group by branch_id ;


select first_name, salary
from employee 
where (branch_id,salary) in (select branch_id, max(salary) 
                            from employee 
                            group by branch_id );


update employee 
set branch_id = 3
where emp_id = 106;

#single coloumn multiple row subsquery 
--find branches which do not have more than one employees

select branch_id,count(branch_id) 
from employee 
group by branch_id;

select branch_id 
from employee 
where (branch_id, 1) in (select branch_id, count(branch_id) 
                        from employee 
                        group by branch_id);


#CORRELATED SUBQUERY

--find employees in each branch whose salary is more than avg(salary in their branch.

select branch_id from employee 
group by branch_id;

select avg(salary) as avg_salary from employee
group by branch_id;


# ONE WAY BY ME joining....ChatGPT hint...dude...think in terms of tables..every select statement is a table
select e.first_name ,e.salary
from employee as e
join (select branch_id, avg(salary) as av from employee 
                                group by branch_id) as sub_table
on e.branch_id=sub_table.branch_id #this type of query is more useful
where e.salary>=sub_table.av;




#SECOND WAY BY CORRELATED SUBQUERY
select * 
from employee as outer_employee 
where salary>=( select avg(salary)
                from employee as inner_employee 
                where inner_employee.branch_id=outer_employee.branch_id)


alter employee add remarks;

select *, (case when salary> (select avg(salary) from employee) then 'Above avg.'
            else 'Below avg.'
            end) as remarks from employee ;


create table sales(
store_id INT,
store_name VARCHAR(255),
product_name VARCHAR(255),
quantity int,
price int);

insert into sales values(3,"Apple store 3","Airpods pro",4,4400);



select * from sales;


#find stores who have sold more units than avg units sold by all stores

select avg(quantity) from sales group by store_id;

select sum(quantity) from sales group by store_id;


select store_id from ( 
select a.store_id,a.sum_qty,b.avg_qty
from 
(select store_id, sum(quantity) as sum_qty from sales group by store_id) as a join
        (select store_id ,avg(quantity) as avg_qty from sales group by store_id) as b
        on a.store_id=b.store_id) as new_table
        
        where new_table.sum_qty>new_table.avg_qty;


#HAVING

select store_name, sum(quantity)
from sales group by store_name
having sum(quantity)>(select avg(quantity) from sales );


#WITH-CLAUSE

with avg_salary(avg_sal) as (select avg(salary) from employee)
select first_name 
from employee , avg_salary  
where employee.salary > avg_salary.avg_sal;


select * from avg_salary; # this doesnt wor...this is not a permanent table

drop table tb_customer_data;

create table tb_customer_data(
    cust_id VARCHAR(20),
    cust_name VARCHAR(20),
    phone INTEGER,
    email VARCHAR(20),
    address VARCHAR(20)
);

insert into tb_customer_data values ("C4","isha",98325768,"isha@g","delhi");
select * from tb_customer_data;

create table tb_product_info(
prod_id VARCHAR(20),
prod_name VARCHAR(20),
brand VARCHAR(20),
price int
);

insert into tb_product_info values("P6","macbook s22","apple",5000);
select * from tb_product_info;

drop table tb_order_details;

create table tb_order_details(
order_id int,
prod_id VARCHAR(20),
quantity int,
cust_id VARCHAR(20),
disc_percent int,
order_date date
);

insert into tb_order_details values (1,"P1",2,"C1",10, "2020-01-01");

select * from tb_order_details;


#VIEWS

--its like a virtual memory.. not materialized memory. Its a virtual table.


create view order_summary
as 
select temp_table.prod_id , (temp_table.price *(1-(0.01*temp_table.disc_percent)) ) as final_price
from (select p.prod_id, p.price, o.disc_percent 
from tb_product_info p
join tb_order_details o on p.prod_id = o.prod_id) as temp_table;

-- we have created a view to calculate final price of products. in the name of order_Summary
-- every time we call view, interanlly it will do what you have asked in query

select * from order_summary; --this doesnt mean that it has stored data.Its virtual

#creating user and giving login details and letting him use query using VIEW..only read acces is given
create user 'james' @'localhost'
identified by 'james'; 
grant select on order_summary to james;

#add new column in tb_order_details 

alter table tb_order_details add column delivery_date DATE ;


select * from tb_order_details;

create view order_summary1
as 
select * 
from (select p.prod_id, p.price, o.disc_percent 
from tb_product_info p
join tb_order_details o on p.prod_id = o.prod_id) as temp_table;

select * from order_summary1; 

select * from tb_product_info;


create view check_option_demo
as 
select * from tb_product_info where brand='Apple';


select * from check_option_demo;

insert into check_option_demo values("p10","note5","samsung",2000);#NO error because no check option

create or replace view check_option_demo 
as 
select * from tb_product_info where brand="Apple"
with check option;  

select * from check_option_demo;

insert into check_option_demo values("p10","note5","samsung",2000);# error thatcheck option failed
insert into check_option_demo values("p20","13 max pro","apple",2000);#no error bcs check with option success

