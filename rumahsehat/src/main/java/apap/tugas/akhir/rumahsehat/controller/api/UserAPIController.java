package apap.tugas.akhir.rumahsehat.controller.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import apap.tugas.akhir.rumahsehat.service.UserService;

@CrossOrigin()
@RestController
@RequestMapping("/api/v1")
public class UserAPIController {

    @Autowired
    UserService userService;
}
