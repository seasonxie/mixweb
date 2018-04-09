package com.meizu.mad.service.tester;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;

@Service
public class testServiceImpl implements testServiceI {
    @Autowired
    testDaoI testDaoI;

    @Override
    public void getid() {
        try {
            testDaoI.getid();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
