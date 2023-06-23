package apap.tugas.akhir.rumahsehat.controller;

import java.security.Principal;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.servlet.ModelAndView;

import apap.tugas.akhir.rumahsehat.model.users.AdminModel;
import apap.tugas.akhir.rumahsehat.model.users.UserModel;
import apap.tugas.akhir.rumahsehat.model.users.UserType;
import apap.tugas.akhir.rumahsehat.security.xml.ServiceResponse;
import apap.tugas.akhir.rumahsehat.service.AdminService;
import apap.tugas.akhir.rumahsehat.service.ApotekerService;
import apap.tugas.akhir.rumahsehat.service.DokterService;
import apap.tugas.akhir.rumahsehat.service.PasienService;
import apap.tugas.akhir.rumahsehat.service.UserService;
import apap.tugas.akhir.rumahsehat.setting.Setting;

@Controller
public class BaseController {

    @Autowired
    AdminService adminService;

    @Autowired
    UserService userService;

    @Autowired
    ApotekerService apotekerService;

    @Autowired
    PasienService pasienService;

    @Autowired
    DokterService dokterService;

    private WebClient webClient = WebClient.builder().build();

    @GetMapping("/")
    public String Home(Model model) {
        model.addAttribute("n_apoteker", apotekerService.getListApoteker().size());
        model.addAttribute("n_dokter", dokterService.getListDokter().size());
        model.addAttribute("n_pasien", pasienService.getListPasien().size());
        model.addAttribute("n_admin", adminService.getListAdmin().size());
        return "dashboard/index";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/api/initial")
    private String Initial() {
        if (adminService.getListAdmin().size() == 0) {
            AdminModel admin = new AdminModel();
            admin.setEmail("admin3@rumahsehat.com");
            admin.setNama("admin utama");
            admin.setPassword("admin");
            admin.setRole(UserType.ADMIN);
            admin.setUsername("admin2");
            admin.setIsSso(false);
            admin.setToken("0");
            adminService.addAdmin(admin);
            System.out.println("Berhasil membuat admin!");
            return "login";
        }
        System.out.println("Maaf gagal");
        return "error/404";
    }

    @GetMapping(value = "/login-sso")
    public ModelAndView loginSSO() {
        return new ModelAndView("redirect:" + Setting.SERVER_LOGIN + Setting.CLIENT_LOGIN);
    }

    @GetMapping(value = "/logout-sso")
    public ModelAndView logoutSSO(Principal principal) {
        UserModel user = userService.getUserByUsername(principal.getName());
        if (!user.getIsSso()) {
            return new ModelAndView("redirect:/logout");
        }
        return new ModelAndView("redirect:" + Setting.SERVER_LOGOUT + Setting.CLIENT_LOGOUT);
    }

    @GetMapping("/validate-ticket")
    public ModelAndView adminLoginSSO(
            @RequestParam(value = "ticket", required = false) String ticket,
            HttpServletRequest request) {
        var serviceResponse = this.webClient.get().uri(
                String.format(
                        Setting.SERVER_VALIDATE_TICKET,
                        ticket,
                        Setting.CLIENT_LOGIN))
                .retrieve().bodyToMono(ServiceResponse.class).block();

        if (serviceResponse == null) {
            return new ModelAndView("redirect:/login");
        }

        var attributes = serviceResponse.getAuthenticationSuccess().getAttributes();
        String username = serviceResponse.getAuthenticationSuccess().getUser();

        AdminModel admin = adminService.getAdminByUsername(username);

        if (admin == null) {
            admin = new AdminModel();
            admin.setEmail(username + "@ui.ac.id");
            admin.setNama(attributes.getNama());
            admin.setPassword("rumahsehat");
            admin.setUsername(username);
            admin.setIsSso(true);
            admin.setRole(UserType.ADMIN);
            admin.setToken("0");
            adminService.addAdmin(admin);
        }

        Authentication authentication = new UsernamePasswordAuthenticationToken(username, "rumahsehat");

        var securityContext = SecurityContextHolder.getContext();
        securityContext.setAuthentication(authentication);

        var httpSession = request.getSession(true);
        httpSession.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, securityContext);

        return new ModelAndView("redirect:/");
    }
}