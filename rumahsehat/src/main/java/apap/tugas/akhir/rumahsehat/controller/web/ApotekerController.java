package apap.tugas.akhir.rumahsehat.controller.web;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import apap.tugas.akhir.rumahsehat.model.users.ApotekerModel;
import apap.tugas.akhir.rumahsehat.model.users.UserType;
import apap.tugas.akhir.rumahsehat.service.ApotekerService;
import apap.tugas.akhir.rumahsehat.service.DokterService;
import apap.tugas.akhir.rumahsehat.service.UserService;

@Controller
public class ApotekerController {

    @Autowired
    ApotekerService apotekerService;

    @Autowired
    DokterService dokterService;

    @Autowired
    UserService userService;

    String notFoundError = "error/404";

    // List apoteker
    @GetMapping("/apoteker")
    public String getApotekerList(Model model, Principal principal) {
        if (userService.isAdmin(principal)) {
            model.addAttribute("dokters", dokterService.getListDokter());
            model.addAttribute("apotekers", apotekerService.getListApoteker());
            return "dashboard/apoteker/list";
        } else {
            return notFoundError;
        }
        
    }

    // Form create apoteker
    @GetMapping("/apoteker/add")
    public String getApotekerAddForm(Principal principal) {
        if (userService.isAdmin(principal)) {
            return "dashboard/apoteker/form-add";
        } else {
            return notFoundError;
        }
    }

    // Confirmation create apoteker
    @PostMapping(value = "/apoteker/add")
    public String postApotekerAddForm(@ModelAttribute ApotekerModel apoteker, Principal principal) {
        if (userService.isAdmin(principal)) {
            apoteker.setRole(UserType.APOTEKER);
            apoteker.setIsSso(false);
            apotekerService.addApoteker(apoteker);
            return "dashboard/apoteker/confirmation-add";
        } else {
            return notFoundError;
        }
    }
}
