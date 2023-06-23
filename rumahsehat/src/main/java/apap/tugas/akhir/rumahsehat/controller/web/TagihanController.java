package apap.tugas.akhir.rumahsehat.controller.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import apap.tugas.akhir.rumahsehat.service.TagihanService;

@Controller
public class TagihanController {

    @Autowired
    TagihanService tagihanService;
}
