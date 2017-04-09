create table if not EXISTS record_partition(
rid string,
uid string,
bid string,
price int,
source_province string,
target_province string,
site string,
express_number string,
express_company string
)partitioned by(transaction_date date);

show create table record_partition;

select * from record_partition limit 10;

set hive.exec.dynamic.partition.mode=nonstrict;
insert into table record_partition partition(trancation_date) select * from record_dimension;