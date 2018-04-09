package ww.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.meizu.mad.service.tester.testServiceI;



@Controller
public class MainController {

    @Autowired
     testServiceI testServiceI;

    @ResponseBody
    @RequestMapping(value = "test/{taskid}")
    public Object getTaskBugList(@PathVariable("taskid") Integer taskid) throws Exception {
        //Logger.getLogger(MainController.class).info("-------------------------");
        testServiceI.getid();
        return taskid;
    }
}
