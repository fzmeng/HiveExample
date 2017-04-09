#hive 练习3
#data employees.txt

create database practice2;
show databases;
use practice2;


create table if not EXISTS employees(
 name string,
 salary string,
 subordinates array<String>,
 deductions map<String,Float>,
 address struct<street:string,city:string,state:string,zip:int>
)
row format delimited
fields terminated by '\001'
collection items terminated by '\002'
map keys terminated by '\003'
lines terminated by '\n'
stored as textfile;


describe employees;
+---------------+---------------------------------------------------------+----------+--+
|   col_name    |                        data_type                        | comment  |
+---------------+---------------------------------------------------------+----------+--+
| name          | string                                                  |          |
| salary        | string                                                  |          |
| subordinates  | array<string>                                           |          |
| deductions    | map<string,float>                                       |          |
| address       | struct<street:string,city:string,state:string,zip:int>  |          |
+---------------+---------------------------------------------------------+----------+--+

LOAD DATA LOCAL INPATH '/home/mfz/apache-hive-2.1.1-bin/hivedata/employees.txt' OVERWRITE INTO TABLE employees;
+-------------------+-------------------+------------------------------+------------------------------------------------------------+
------------------------------------------------------------------------------+--+
|  employees.name   | employees.salary  |    employees.subordinates    |                    employees.deductions                    |
                              employees.address                               |
+-------------------+-------------------+------------------------------+------------------------------------------------------------+
------------------------------------------------------------------------------+--+
| John Doe          | 100000.0          | ["Mary Smith","Todd Jones"]  | {"Federal Taxes":0.2,"State Taxes":0.05,"Insurance":0.1}   |
 {"street":"1 Michigan Ave.","city":"Chicago","state":"IL","zip":60600}       |
| Mary Smith        | 80000.0           | ["Bill King"]                | {"Federal Taxes":0.2,"State Taxes":0.05,"Insurance":0.1}   |
 {"street":"100 Ontario St.","city":"Chicago","state":"IL","zip":60601}       |
| Todd Jones        | 70000.0           | []                           | {"Federal Taxes":0.15,"State Taxes":0.03,"Insurance":0.1}  |
 {"street":"200 Chicago Ave.","city":"Oak Park","state":"IL","zip":60700}     |
| Bill King         | 60000.0           | []                           | {"Federal Taxes":0.15,"State Taxes":0.03,"Insurance":0.1}  |
 {"street":"300 Obscure Dr.","city":"Obscuria","state":"IL","zip":60100}      |
| Boss Man          | 200000.0          | ["John Doe","Fred Finance"]  | {"Federal Taxes":0.3,"State Taxes":0.07,"Insurance":0.05}  |
 {"street":"1 Pretentious Drive.","city":"Chicago","state":"IL","zip":60500}  |
| Fred Finance      | 150000.0          | ["Stacy Accountant"]         | {"Federal Taxes":0.3,"State Taxes":0.07,"Insurance":0.05}  |
 {"street":"2 Pretentious Drive.","city":"Chicago","state":"IL","zip":60500}  |
| Stacy Accountant  | 60000.0           | []                           | {"Federal Taxes":0.15,"State Taxes":0.03,"Insurance":0.1}  |
 {"street":"300 Main St.","city":"Naperville","state":"IL","zip":60563}       |
+-------------------+-------------------+------------------------------+------------------------------------------------------------+
------------------------------------------------------------------------------+--+

select * from employees where deductions['Federal Taxes']>0.2;
+-----------------+-------------------+------------------------------+------------------------------------------------------------+--
----------------------------------------------------------------------------+--+
| employees.name  | employees.salary  |    employees.subordinates    |                    employees.deductions                    |
                            employees.address                               |
+-----------------+-------------------+------------------------------+------------------------------------------------------------+--
----------------------------------------------------------------------------+--+
| John Doe        | 100000.0          | ["Mary Smith","Todd Jones"]  | {"Federal Taxes":0.2,"State Taxes":0.05,"Insurance":0.1}   | {
"street":"1 Michigan Ave.","city":"Chicago","state":"IL","zip":60600}       |
| Mary Smith      | 80000.0           | ["Bill King"]                | {"Federal Taxes":0.2,"State Taxes":0.05,"Insurance":0.1}   | {
"street":"100 Ontario St.","city":"Chicago","state":"IL","zip":60601}       |
| Boss Man        | 200000.0          | ["John Doe","Fred Finance"]  | {"Federal Taxes":0.3,"State Taxes":0.07,"Insurance":0.05}  | {
"street":"1 Pretentious Drive.","city":"Chicago","state":"IL","zip":60500}  |
| Fred Finance    | 150000.0          | ["Stacy Accountant"]         | {"Federal Taxes":0.3,"State Taxes":0.07,"Insurance":0.05}  | {
"street":"2 Pretentious Drive.","city":"Chicago","state":"IL","zip":60500}  |
+-----------------+-------------------+------------------------------+------------------------------------------------------------+--
----------------------------------------------------------------------------+--+

#查询第一位下属是John Doe的
select * from employees where subordinates[0] = 'John Doe';
+-----------------+-------------------+------------------------------+------------------------------------------------------------+--
----------------------------------------------------------------------------+--+
| employees.name  | employees.salary  |    employees.subordinates    |                    employees.deductions                    |
                            employees.address                               |
+-----------------+-------------------+------------------------------+------------------------------------------------------------+--
----------------------------------------------------------------------------+--+
| Boss Man        | 200000.0          | ["John Doe","Fred Finance"]  | {"Federal Taxes":0.3,"State Taxes":0.07,"Insurance":0.05}  | {
"street":"1 Pretentious Drive.","city":"Chicago","state":"IL","zip":60500}  |
+-----------------+-------------------+------------------------------+------------------------------------------------------------+--
----------------------------------------------------------------------------+--+

#查询经理 --下属人数大于0
select * from employees where size(subordinates)>0;
+-----------------+-------------------+------------------------------+------------------------------------------------------------+--
----------------------------------------------------------------------------+--+
| employees.name  | employees.salary  |    employees.subordinates    |                    employees.deductions                    |
                            employees.address                               |
+-----------------+-------------------+------------------------------+------------------------------------------------------------+--
----------------------------------------------------------------------------+--+
| John Doe        | 100000.0          | ["Mary Smith","Todd Jones"]  | {"Federal Taxes":0.2,"State Taxes":0.05,"Insurance":0.1}   | {
"street":"1 Michigan Ave.","city":"Chicago","state":"IL","zip":60600}       |
| Mary Smith      | 80000.0           | ["Bill King"]                | {"Federal Taxes":0.2,"State Taxes":0.05,"Insurance":0.1}   | {
"street":"100 Ontario St.","city":"Chicago","state":"IL","zip":60601}       |
| Boss Man        | 200000.0          | ["John Doe","Fred Finance"]  | {"Federal Taxes":0.3,"State Taxes":0.07,"Insurance":0.05}  | {
"street":"1 Pretentious Drive.","city":"Chicago","state":"IL","zip":60500}  |
| Fred Finance    | 150000.0          | ["Stacy Accountant"]         | {"Federal Taxes":0.3,"State Taxes":0.07,"Insurance":0.05}  | {
"street":"2 Pretentious Drive.","city":"Chicago","state":"IL","zip":60500}  |
+-----------------+-------------------+------------------------------+------------------------------------------------------------+--
----------------------------------------------------------------------------+--+


#查询地址状态在IL
select * from employees where address.state='IL';
+-------------------+-------------------+------------------------------+------------------------------------------------------------+
------------------------------------------------------------------------------+--+
|  employees.name   | employees.salary  |    employees.subordinates    |                    employees.deductions                    |
                              employees.address                               |
+-------------------+-------------------+------------------------------+------------------------------------------------------------+
------------------------------------------------------------------------------+--+
| John Doe          | 100000.0          | ["Mary Smith","Todd Jones"]  | {"Federal Taxes":0.2,"State Taxes":0.05,"Insurance":0.1}   |
 {"street":"1 Michigan Ave.","city":"Chicago","state":"IL","zip":60600}       |
| Mary Smith        | 80000.0           | ["Bill King"]                | {"Federal Taxes":0.2,"State Taxes":0.05,"Insurance":0.1}   |
 {"street":"100 Ontario St.","city":"Chicago","state":"IL","zip":60601}       |
| Todd Jones        | 70000.0           | []                           | {"Federal Taxes":0.15,"State Taxes":0.03,"Insurance":0.1}  |
 {"street":"200 Chicago Ave.","city":"Oak Park","state":"IL","zip":60700}     |
| Bill King         | 60000.0           | []                           | {"Federal Taxes":0.15,"State Taxes":0.03,"Insurance":0.1}  |
 {"street":"300 Obscure Dr.","city":"Obscuria","state":"IL","zip":60100}      |
| Boss Man          | 200000.0          | ["John Doe","Fred Finance"]  | {"Federal Taxes":0.3,"State Taxes":0.07,"Insurance":0.05}  |
 {"street":"1 Pretentious Drive.","city":"Chicago","state":"IL","zip":60500}  |
| Fred Finance      | 150000.0          | ["Stacy Accountant"]         | {"Federal Taxes":0.3,"State Taxes":0.07,"Insurance":0.05}  |
 {"street":"2 Pretentious Drive.","city":"Chicago","state":"IL","zip":60500}  |
| Stacy Accountant  | 60000.0           | []                           | {"Federal Taxes":0.15,"State Taxes":0.03,"Insurance":0.1}  |
 {"street":"300 Main St.","city":"Naperville","state":"IL","zip":60563}       |
+-------------------+-------------------+------------------------------+------------------------------------------------------------+
------------------------------------------------------------------------------+--+

#模糊查询city 头字符是Na
select * from employees where address.city like 'Na%';
+-------------------+-------------------+-------------------------+------------------------------------------------------------+-----
--------------------------------------------------------------------+--+
|  employees.name   | employees.salary  | employees.subordinates  |                    employees.deductions                    |
                       employees.address                            |
+-------------------+-------------------+-------------------------+------------------------------------------------------------+-----
--------------------------------------------------------------------+--+
| Stacy Accountant  | 60000.0           | []                      | {"Federal Taxes":0.15,"State Taxes":0.03,"Insurance":0.1}  | {"st
reet":"300 Main St.","city":"Naperville","state":"IL","zip":60563}  |
+-------------------+-------------------+-------------------------+------------------------------------------------------------+-----
--------------------------------------------------------------------+--+

#正则查询
 select * from employees where address.street rlike '^.*(Ontario|Chicago).*$';
+-----------------+-------------------+-------------------------+------------------------------------------------------------+-------
--------------------------------------------------------------------+--+
| employees.name  | employees.salary  | employees.subordinates  |                    employees.deductions                    |
                      employees.address                             |
+-----------------+-------------------+-------------------------+------------------------------------------------------------+-------
--------------------------------------------------------------------+--+
| Mary Smith      | 80000.0           | ["Bill King"]           | {"Federal Taxes":0.2,"State Taxes":0.05,"Insurance":0.1}   | {"stre
et":"100 Ontario St.","city":"Chicago","state":"IL","zip":60601}    |
| Todd Jones      | 70000.0           | []                      | {"Federal Taxes":0.15,"State Taxes":0.03,"Insurance":0.1}  | {"stre
et":"200 Chicago Ave.","city":"Oak Park","state":"IL","zip":60700}  |
+-----------------+-------------------+-------------------------+------------------------------------------------------------+-------
--------------------------------------------------------------------+--+




