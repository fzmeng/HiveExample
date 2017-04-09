#用户表创建
create table if not EXISTS user_dimension(
uid String,
name string,
gender string,
birth date,
province string
) row format delimited
fields terminated by ',';

describe user_dimension;
show create table user_dimension;

#品牌表创建
create table if not EXISTS brand_dimension(
bid string,
category string,
brand string
)row format delimited
fields terminated by ',';

#交易表创建
create table if not EXISTS record_dimension(
rid string,
uid string,
bid string,
price int,
source_province string,
target_province string,
site string,
express_number string,
express_company string,
trancation_date date
)row format delimited
fields terminated by ',';

show tables;

#创建数据
user.DATA
brand.DATA
record.DATA

#载入数据
LOAD DATA LOCAL INPATH '/home/mfz/apache-hive-2.1.1-bin/hivedata/user.data' OVERWRITE INTO TABLE user_dimension;
LOAD DATA LOCAL INPATH '/home/mfz/apache-hive-2.1.1-bin/hivedata/brand.data' OVERWRITE INTO TABLE brand_dimension;
LOAD DATA LOCAL INPATH '/home/mfz/apache-hive-2.1.1-bin/hivedata/record.data' OVERWRITE INTO TABLE record_dimension;
#验证
select * from user_dimension;
select * from brand_dimension;
select * from record_dimension;
#载入HDFS上数据
load data inpath 'user.data_HDFS_PATH' OVERWRITE INTO TABLE user_dimension;

#查询
select count(*) from record_dimension where trancation_date = '2017-09-01';
+-----+--+
| c0  |
+-----+--+
| 6   |
+-----+--+
#不同年龄消费的情况
select cast(datediff(CURRENT_DATE ,birth)/365 as int ) as age,sum(price) as totalPrice
  from record_dimension rd
    JOIN user_dimension ud on rd.uid = ud.uid
      group by cast(datediff(CURRENT_DATE ,birth)/365 as int)
        order by totalPrice DESC ;

+------+-------------+--+
| age  | totalprice  |
+------+-------------+--+
| 5    | 944         |
| 25   | 877         |
| 24   | 429         |
| 28   | 120         |
+------+-------------+--+

#不同品牌被消费的情况
select brand,sum(price) as totalPrice
  from record_dimension rd
    join brand_dimension bd on bd.bid = rd.bid
        group by bd.brand
          order by totalPrice desc;
+------------+-------------+--+
|   brand    | totalprice  |
+------------+-------------+--+
| SAMSUNG    | 944         |
| OPPO       | 625         |
| WULIANGYE  | 429         |
| DELL       | 252         |
| NIKE       | 120         |
+------------+-------------+--+

#统计2017-09-01 当天各个品牌的交易笔数，按照倒序排序
select brand,count(*) as sumCount
  from record_dimension rd
    join brand_dimension bd on bd.bid=rd.bid
      where rd.trancation_date='2017-09-01'
      group by bd.brand
        order by sumCount desc
+------------+-----------+--+
|   brand    | sumcount  |
+------------+-----------+--+
| SAMSUNG    | 2         |
| WULIANGYE  | 1         |
| OPPO       | 1         |
| NIKE       | 1         |
| DELL       | 1         |
+------------+-----------+--+

#不同性别消费的商品类别情况
select ud.gender as gender,bd.category shangping,sum(price) totalPrice,count(*) FROM  record_dimension rd
  join user_dimension ud on rd.uid = ud.uid
    join brand_dimension bd on rd.bid = bd.bid
      group by ud.gender,bd.category;

+---------+------------+-------------+-----+--+
| gender  | shangping  | totalprice  | c3  |
+---------+------------+-------------+-----+--+
| F       | telephone  | 944         | 2   |
| M       | computer   | 252         | 1   |
| M       | food       | 429         | 1   |
| M       | sport      | 120         | 1   |
| M       | telephone  | 625         | 1   |
+---------+------------+-------------+-----+--+




