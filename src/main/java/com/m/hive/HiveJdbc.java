package com.m.hive;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * @author mengfanzhu
 * @Package com.m.hive
 * @Description: Hive jdbc连接
 * @date 17/4/3 11:31
 */
public class HiveJdbc {
    public static void main(String[] args) throws Exception{
        Class.forName("org.apache.hive.jdbc.HiveDriver");

        String dropSQL="drop table javaTest";
        String createSQL="create table javaTest (key int, value string)";
        String insterSQL="LOAD DATA LOCAL INPATH '/Users/mfz/Desktop/config.properties' OVERWRITE INTO TABLE javaTest";
        String querySQL="SELECT a.* FROM javaTest a";

        Connection con = DriverManager.getConnection("jdbc:hive2://10.255.55.5:10000/dbmfz", "hadoop", "hadoop");
        Statement stmt = con.createStatement();
        stmt.executeQuery(dropSQL);  // 执行删除语句
        stmt.executeQuery(createSQL);  // 执行建表语句
        stmt.executeQuery(insterSQL);  // 执行插入语句
        ResultSet res = stmt.executeQuery(querySQL);   // 执行查询语句

        while (res.next()) {
            System.out.println("Result: key:"+res.getString(1) +"  –>  value:" +res.getString(2));
        }

    }
}
