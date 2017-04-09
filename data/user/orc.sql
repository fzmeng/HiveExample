create table if not EXISTS record_orc(
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
)stored as orc;

show create table record_orc;
+---------------------------------------------------------------------+--+
|                           createtab_stmt                            |
+---------------------------------------------------------------------+--+
| CREATE TABLE `record_orc`(                                          |
|   `rid` string,                                                     |
|   `uid` string,                                                     |
|   `bid` string,                                                     |
|   `price` int,                                                      |
|   `source_province` string,                                         |
|   `target_province` string,                                         |
|   `site` string,                                                    |
|   `express_number` string,                                          |
|   `express_company` string,                                         |
|   `trancation_date` date)                                           |
| ROW FORMAT SERDE                                                    |
|   'org.apache.hadoop.hive.ql.io.orc.OrcSerde'                       |
| STORED AS INPUTFORMAT                                               |
|   'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'                 |
| OUTPUTFORMAT                                                        |
|   'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'                |
| LOCATION                                                            |
|   'hdfs://master:9000/user/hive/warehouse/practice2.db/record_orc'  |
| TBLPROPERTIES (                                                     |
|   'COLUMN_STATS_ACCURATE'='{\"BASIC_STATS\":\"true\"}',             |
|   'numFiles'='0',                                                   |
|   'numRows'='0',                                                    |
|   'rawDataSize'='0',                                                |
|   'totalSize'='0',                                                  |
|   'transient_lastDdlTime'='1491706697')                             |
+---------------------------------------------------------------------+--+

#载入数据
insert into table record_orc select * from record_dimension;

select * from record_orc;
+-----------------+-----------------+-----------------+-------------------+-----------------------------+----------------------------
-+------------------+----------------------------+-----------------------------+-----------------------------+--+
| record_orc.rid  | record_orc.uid  | record_orc.bid  | record_orc.price  | record_orc.source_province  | record_orc.target_province
 | record_orc.site  | record_orc.express_number  | record_orc.express_company  | record_orc.trancation_date  |
+-----------------+-----------------+-----------------+-------------------+-----------------------------+----------------------------
-+------------------+----------------------------+-----------------------------+-----------------------------+--+
| 0000000000      | 00000001        | 00000002        | 625               | HeiLongJiang                | HuNan
 | TianMao          | 22432432532123421431       | ShenTong                    | 2017-09-01                  |
| 0000000001      | 00000001        | 00000001        | 252               | GuangDong                   | HuNan
 | JingDong         | 73847329843                | ZhongTong                   | 2017-09-01                  |
| 0000000002      | 00000004        | 00000003        | 697               | JiangSu                     | Huan
 | TianMaoChaoShi   | 2197298357438              | Shunfeng                    | 2017-09-01                  |
| 0000000003      | 00000004        | 00000003        | 247               | TianJing                    | NeiMeiGu
 | JingDong         | 73298759327894             | YunDa                       | 2017-09-01                  |
| 0000000004      | 00000002        | 00000004        | 429               | ShangHai                    | Ning
 | TianMao          | 438294820                  | YunDa                       | 2017-09-01                  |
| 0000000005      | 00000008        | 00000005        | 120               | HuBei                       | Aomen
 | JuHU             | 5349523959                 | ZhongTong                   | 2017-09-01                  |
+-----------------+-----------------+-----------------+-------------------+-----------------------------+----------------------------
-+------------------+----------------------------+-----------------------------+-----------------------------+--+

select * from record_dimension;
+-----------------------+-----------------------+-----------------------+-------------------------+----------------------------------
-+-----------------------------------+------------------------+----------------------------------+-----------------------------------
+-----------------------------------+--+
| record_dimension.rid  | record_dimension.uid  | record_dimension.bid  | record_dimension.price  | record_dimension.source_province
 | record_dimension.target_province  | record_dimension.site  | record_dimension.express_number  | record_dimension.express_company
| record_dimension.trancation_date  |
+-----------------------+-----------------------+-----------------------+-------------------------+----------------------------------
-+-----------------------------------+------------------------+----------------------------------+-----------------------------------
+-----------------------------------+--+
| 0000000000            | 00000001              | 00000002              | 625                     | HeiLongJiang
 | HuNan                             | TianMao                | 22432432532123421431             | ShenTong
| 2017-09-01                        |
| 0000000001            | 00000001              | 00000001              | 252                     | GuangDong
 | HuNan                             | JingDong               | 73847329843                      | ZhongTong
| 2017-09-01                        |
| 0000000002            | 00000004              | 00000003              | 697                     | JiangSu
 | Huan                              | TianMaoChaoShi         | 2197298357438                    | Shunfeng
| 2017-09-01                        |
| 0000000003            | 00000004              | 00000003              | 247                     | TianJing
 | NeiMeiGu                          | JingDong               | 73298759327894                   | YunDa
| 2017-09-01                        |
| 0000000004            | 00000002              | 00000004              | 429                     | ShangHai
 | Ning                              | TianMao                | 438294820                        | YunDa
| 2017-09-01                        |
| 0000000005            | 00000008              | 00000005              | 120                     | HuBei
 | Aomen                             | JuHU                   | 5349523959                       | ZhongTong
| 2017-09-01                        |
+-----------------------+-----------------------+-----------------------+-------------------------+----------------------------------
-+-----------------------------------+------------------------+----------------------------------+-----------------------------------
+-----------------------------------+--+

从数据结果来看没有多大区别。那我们来看下hdfs上的存储文件
