package apap.tugas.akhir.rumahsehat.controller.web;

import java.security.Principal;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.RedirectView;

import apap.tugas.akhir.rumahsehat.model.AppointmentModel;
import apap.tugas.akhir.rumahsehat.model.TagihanModel;
import apap.tugas.akhir.rumahsehat.model.users.DokterModel;
import apap.tugas.akhir.rumahsehat.model.users.UserModel;
import apap.tugas.akhir.rumahsehat.service.AppointmentService;
import apap.tugas.akhir.rumahsehat.service.TagihanService;
import apap.tugas.akhir.rumahsehat.service.UserService;

@Controller
public class AppointmentController {

    @Autowired
    AppointmentService appointmentService;

    @Autowired
    UserService userService;

    @Autowired
    TagihanService tagihanService;

    Logger logger = LoggerFactory.getLogger(AppointmentController.class);
    String roleDokter = "DOKTER";

    // List appointment
    @GetMapping("/appointment")
    public String getAppointmentList(Model model, Principal principal) {
        UserModel user = userService.getUserByUsername(principal.getName());
        var role = user.getRole().toString();
        List<AppointmentModel> aptList = null;

        if (role.equals("ADMIN")) {
            aptList = appointmentService.getListAppointment();
        } else if (role.equals(roleDokter)) {
            DokterModel dokter = (DokterModel) user;
            aptList = dokter.getListAppointment();
        }

        model.addAttribute("appointments", aptList);
        model.addAttribute("role", role);
        return "dashboard/appointment/list";
    }

    // Detail appointment
    @GetMapping("/appointment/detail")
    public String getAppointmentById(@RequestParam(value = "kode") String kode, Model model, Principal principal) {
        AppointmentModel apt = appointmentService.getAppointmentById(kode);
        UserModel user = userService.getUserByUsername(principal.getName());
        var role = user.getRole().toString();

        var canAccess = false;
        var canCreateResep = false;
        var canUpdateStatus = false;
        var showResepWarning = false;

        Long kodeResep = null;

        if (role.equals(roleDokter) || role.equals("ADMIN")) {
            canAccess = true;
        }

        if (apt != null && role.equals(roleDokter) && !apt.getIsDone() && apt.getResep() == null) {
            canUpdateStatus = true;
            canCreateResep = true;
            showResepWarning = true;
        }

        if (apt == null) {
            logger.error("Kode appointment tidak ditemukan.");
        }

        model.addAttribute("apt", apt);
        model.addAttribute("role", role);
        model.addAttribute("canAccess", canAccess);
        model.addAttribute("canCreateResep", canCreateResep);
        model.addAttribute("canUpdateStatus", canUpdateStatus);
        model.addAttribute("showResepWarning", showResepWarning);
        model.addAttribute("kodeResep", kodeResep);

        return "dashboard/appointment/detail";
    }

    // Update appointment
    @GetMapping("/appointment/update")
    public RedirectView updateAppointment(@RequestParam(value = "kode") String kode) {
        AppointmentModel apt = appointmentService.getAppointmentById(kode);
        AppointmentModel updated = appointmentService.updateAppointment(apt);

        String redirectUrl;
        if (updated != null) {
            redirectUrl = "/appointment/detail/?kode=" + updated.getKode();

            Integer harga = apt.getDokter().getTarif();
            var newBill = new TagihanModel();
            tagihanService.addTagihan(newBill, harga, apt);

        } else {
            redirectUrl = "/appointment/detail/?kode=APT-null";
            logger.error("Gagal update status Appointment. Kode appointment tidak ditemukan.");
        }

        return new RedirectView(redirectUrl);
    }
}
