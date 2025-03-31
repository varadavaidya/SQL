
-- create
CREATE TABLE EMPLOYEE (
  emp_id INTEGER ,
  emp_name varchar(20) ,
  dept_name varchar(20) ,
  salary int
);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);

--create trigger function 

create table action(
  action varchar(20),
  time_of_action timestamp default now()
  );

create or replace function insert_employee_function()
returns trigger as $$ 
begin 
      insert into action values ('new employee added', now());
      return new;
end 
$$ language plpgsql;

create trigger action_trigger 
after insert on employee 
for each row 
execute function insert_employee_function();

insert into employee values(125,'Varada','DataScience',25000);

select * from action; 

--create trigger to show error when salary is negative 



create or replace function validity_of_salary()
returns trigger as $$ 
begin 
      if new.salary>0 then 
      return new ;
      end if;
      raise exception 'invalid salary';
end;
$$ language plpgsql;
       

create trigger valid_salary 
before insert or update on employee 
for each row 
execute function validity_of_salary();

insert into employee values(126,'Ishika','DataScience', -25);



























