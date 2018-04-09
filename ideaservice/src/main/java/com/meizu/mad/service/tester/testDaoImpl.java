package com.meizu.mad.service.tester;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ColumnListHandler;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class testDaoImpl implements testDaoI {

    @Autowired
    public QueryRunner queryRunner;

    @Override
    public void getid() {
        List list=null;
        try {
            System.out.println(queryRunner.getDataSource().getConnection());
            list  = (List) queryRunner.query("select * from user", new ColumnListHandler("username"));
        }catch (Exception e){
            e.printStackTrace();
        }
        Logger.getLogger(testDaoImpl.class).info(list+"-------------------------");
    }
}
