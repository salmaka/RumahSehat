package apap.tugas.akhir.rumahsehat.controller.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import apap.tugas.akhir.rumahsehat.service.ApotekerService;

@CrossOrigin()
@RestController
@RequestMapping("/api/v1")
public class ApotekerAPIController {

    @Autowired
    ApotekerService apotekerService;
}
