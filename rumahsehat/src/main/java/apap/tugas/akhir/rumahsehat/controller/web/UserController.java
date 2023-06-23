package apap.tugas.akhir.rumahsehat.controller.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import apap.tugas.akhir.rumahsehat.service.UserService;

@Controller
public class UserController {

    @Autowired
    UserService userService;
}
