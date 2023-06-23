package apap.tugas.akhir.rumahsehat.controller.web;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import apap.tugas.akhir.rumahsehat.model.ObatModel;
import apap.tugas.akhir.rumahsehat.service.ObatService;
import apap.tugas.akhir.rumahsehat.service.UserService;

@Controller
public class ObatController {

    @Autowired
    ObatService obatService;

    @Autowired
    UserService userService;

    // List obat
    @GetMapping("/obat")
    public String getObatList(Model model, Principal principal) {
        if (userService.isApoteker(principal) || userService.isAdmin(principal)) {
            model.addAttribute("daftarObat", obatService.getListObat());
            return "dashboard/obat/list";
        } else {
            return "error/404";
        }
    }

    // Form update obat
    @GetMapping("/obat/update/{idObat}")
    public String getObatAddUpdate(@PathVariable String idObat, Model model) {
        ObatModel obat = obatService.getObatById(idObat);
        model.addAttribute("obat", obat);
        return "dashboard/obat/form-update";
    }

    // Confirmation update obat
    @PostMapping(value = "/obat/update")
    public String postObatUpdateForm(
            @ModelAttribute ObatModel obat, Model model, Principal principal) {
        if (userService.isApoteker(principal) || userService.isAdmin(principal)) {
            ObatModel updatedObat = obatService.updateObat(obat);
            model.addAttribute("updatedObat", updatedObat);
            return "dashboard/obat/confirmation-update";
        } else {
            return "error/404";
        }

    }
}
