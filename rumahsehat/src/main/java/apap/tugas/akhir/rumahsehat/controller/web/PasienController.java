package apap.tugas.akhir.rumahsehat.controller.web;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import apap.tugas.akhir.rumahsehat.service.PasienService;
import apap.tugas.akhir.rumahsehat.service.UserService;

@Controller
public class PasienController {

    @Autowired
    PasienService pasienService;

    @Autowired
    UserService userService;

    // List pasien
    @GetMapping("/pasien")
    public String getPasienList(Model model, Principal principal) {
        if (userService.isAdmin(principal)) {
            model.addAttribute("pasiens", pasienService.getListPasien());
            return "dashboard/pasien/list";
        } else {
            return "error/404";
        }
    }
}
