package apap.tugas.akhir.rumahsehat.controller.web;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import apap.tugas.akhir.rumahsehat.model.users.DokterModel;
import apap.tugas.akhir.rumahsehat.model.users.UserType;
import apap.tugas.akhir.rumahsehat.service.ApotekerService;
import apap.tugas.akhir.rumahsehat.service.DokterService;
import apap.tugas.akhir.rumahsehat.service.UserService;

@Controller
public class DokterController {

    @Autowired
    DokterService dokterService;

    @Autowired
    ApotekerService apotekerService;

    @Autowired
    UserService userService;

    String notFoundError = "error/404";

    // List dokter
    @GetMapping("/dokter")
    public String getDokterList(Model model, Principal principal) {
        if (userService.isAdmin(principal)) {
            model.addAttribute("dokters", dokterService.getListDokter());
            model.addAttribute("apotekers", apotekerService.getListApoteker());
            return "dashboard/dokter/list";
        } else {
            return notFoundError;
        }
    }

    // Form create dokter
    @GetMapping("/dokter/add")
    public String getDokterAddForm(Principal principal) {
        if (userService.isAdmin(principal)) {
            return "dashboard/dokter/form-add";
        } else {
            return notFoundError;
        }
    }

    // Confirmation create dokter
    @PostMapping(value = "/dokter/add")
    public String postDokterAddForm(@ModelAttribute DokterModel dokter, Principal principal) {
        if (userService.isAdmin(principal)) {
            dokter.setRole(UserType.DOKTER);
            dokter.setIsSso(false);
            dokterService.addDokter(dokter);
            return "dashboard/dokter/confirmation-add";
        } else {
            return notFoundError;
        }

    }
}
