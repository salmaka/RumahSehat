package apap.tugas.akhir.rumahsehat.controller.web;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import apap.tugas.akhir.rumahsehat.service.AdminService;
import apap.tugas.akhir.rumahsehat.service.UserService;

@Controller
public class AdminController {

    @Autowired
    AdminService adminService;

    @Autowired
    UserService userService;

    // List admin
    @GetMapping("/admin")
    public String getAdminList(Model model, Principal principal) {
        if (userService.isAdmin(principal)) {
            model.addAttribute("admins", adminService.getListAdmin());
            return "dashboard/admin/list";
        } else {
            return "error/404";
        }
    }
}
