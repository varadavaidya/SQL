
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

select * from employee;

--max salary 

select max(salary) max_salary from employee;

--max salary across dept_name

select dept_name, max(salary)
from employee 
group by dept_name;

--PARTITION BY

select employee.*, max(salary) over(partition by dept_name) as max_salary from employee;
select employee.*, avg(salary) over(partition by dept_name) as max_salary from employee;

select dept_name, max(salary) over(partition by dept_name) as max_salary from employee;
select dept_name, max(salary)  as max_salary from employee group by dept_name;

--ROW_NUMBER() 

select employee.* ,row_number() over (partition by dept_name) as rn from employee ;

--fetch first two employees from each dept to join company.lets say they are added in table according to their date of joining 

select * from 
        (select employee.* ,row_number() over (partition by dept_name  order by emp_id ) as rn
        from employee)  as window_table 
where window_table.rn in (1,2);

--fetch employees who earn max salary in each dept 

select emp_id,dept_name,salary from employee order by dept_name;

select * from (
select employee.*, rank() over(partition by dept_name order by salary desc ) as ranked_salary from employee ) x
where x.ranked_salary in (1,2,3);

--dense_rank() 

select * from (
select employee.*, dense_rank() over(partition by dept_name order by salary desc ) as ranked_salary from employee ) x
where x.ranked_salary in (1,2,3);



--check for each employee if salary is less or greater or equal to previous employee 
--use LEAD() AND LAG()


select e.* , lag(salary) over(partition by dept_name order by emp_id ) as prev_emp_salary from employee e;




select e.* , lead(salary) over(partition by dept_name order by emp_id ) as next_emp_salary from employee e;



select e.* ,
lag(salary) over (partition by dept_name order by emp_id) as prev_sal ,
case  when e.salary>lag(salary) over (partition by dept_name order by emp_id) then 'Higher than previous employee'
      when e.salary<lag(salary) over (partition by dept_name order by emp_id) then 'lower than previous employee'
      when e.salary=lag(salary) over (partition by dept_name order by emp_id) then 'equal to previous employee'
end as sal_comparison
from employee e;


----------------------- 

create table product(
  product_category VARCHAR(20),
  brand VARCHAR(20),
  product_name VARCHAR(20),
  price int);


insert into product values ('Phone','Apple','12 pro max',1300);
insert into product values ('Phone','Apple','12 pro' ,1100);
insert into product values ('Phone','Apple','12 ',1000);
insert into product values ('Phone','samsung','z fold 3',1800);
insert into product values ('Phone','samsung','z flip 3',1000);
insert into product values ('Phone','samsung','note 20',1200);
insert into product values ('Phone','samsung','gal 21',1000);
insert into product values ('Phone','Oneplus','nord',300);
insert into product values ('Phone','Oneplus','plus 9',800);
insert into product values ('Phone','google','pix 5',600);
insert into product values ('laptop','apple','mac book 13',2000);
insert into product values ('laptop','apple','mac book air',1300);
insert into product values ('laptop','microsoft','surface 4',2100);
insert into product values ('laptop','dell','xps 13',2000);
insert into product values ('laptop','dell','xps 15',2300);
insert into product values ('laptop','dell','xps 17',2500);
insert into product values ('earphone','apple','pro',280);
insert into product values ('earphone','samsung','pro',220);
insert into product values ('earphone','samsung','live',170);
insert into product values ('earphone','sony','pro',250);
insert into product values ('headphone','apple','pro',550);
insert into product values ('headphone','samsung','pro',400);
insert into product values ('headphone','Microsoft','surface',250);
insert into product values ('smartwatch','apple','se 6',1000);
insert into product values ('smartwatch','apple','se',400);
insert into product values ('smartwatch','samsung','gal 4',600);
insert into product values ('smartwatch','one plus','se 2',300);


--FIRST VALUE 
--write query to display most expensive product each category corresponding to each record 

select *,
first_value(product_name) over(partition by product_category order by price desc) as most_exp_in_this_category
from product;


select *,
first_value(brand) over(partition by product_category order by price) as cheap_brand_in_this_category
from product ;

select *,
last_value(product_name) over(partition by product_category order by price desc) as cheapest_brand_in_this_category
from product;  --here we dont get required output because of frame clause.

select *,
last_value(product_name) over(partition by product_category order by price desc
                              range between unbounded preceding and current row) as cheapest_brand_in_this_category
from product; ---considers till that row in partition...the otput is same as above line


select *,
last_value(product_name) over(partition by product_category order by price desc
                              range between unbounded preceding and unbounded following) as cheapest_brand_in_this_category
from product; ---considers all rows from that partition...gives right output



select *,
last_value(product_name) over(partition by product_category order by price desc
                              range between 2 preceding and 2 following) as cheapest_brand_in_this_category
from product; ---we can take away unboundedness and linit to certain rows preceding or following



--window functions....virtual holder of over clause
select *,
first_value(brand) over w as exp_brand_in_this_category,
last_value(brand) over w as cheap_brand_in_this_category
from product 
window w as (partition by product_category order by price desc 
              range between unbounded preceding and unbounded following); --we need not write "w" two times
              
              

--NTH value 
--write a query to fetch second most expensive product in each category
select * ,
nth_value(brand,2) over(partition by product_category order by price desc ) as second_Exp_prod_in_this_category
from product;
              

--NTILE 
--write a query to seggrgate all exoensive products, mid range and cheap phones 

select product_name,
case when x.exp_cat = 1 then 'expensive'
     when x.exp_cat = 2 then 'midrange'
     when x.exp_cat =3 then 'cheap'
end exp_categorized
from (select * ,
ntile(3) over(partition by product_category order by price desc ) as exp_cat
from product 
where product.product_category='Phone') x ;
    
--similar expensive categories for all product categories
select * ,
ntile(3) over(partition by product_category order by price desc ) as exp_cat
from product 
;

--CUME_DIST....top 30 percent of expensive products

select * , cume_distribution within_top_30
from (select * ,
round(cume_dist() over(order by price desc )::numeric*100,2) as cume_distribution
from product )as x
where x.cume_distribution<30;

--percent_rank function 
select *, 
round(percent_rank()over(order by price desc)::numeric * 100,2) as p_r 
from product;




    



























