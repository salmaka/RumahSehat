package apap.tugas.akhir.rumahsehat.controller.web;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import apap.tugas.akhir.rumahsehat.model.AppointmentModel;
import apap.tugas.akhir.rumahsehat.model.JumlahModel;
import apap.tugas.akhir.rumahsehat.model.ObatModel;
import apap.tugas.akhir.rumahsehat.model.ResepModel;
import apap.tugas.akhir.rumahsehat.model.TagihanModel;
import apap.tugas.akhir.rumahsehat.model.users.ApotekerModel;
import apap.tugas.akhir.rumahsehat.service.ApotekerService;
import apap.tugas.akhir.rumahsehat.service.AppointmentService;
import apap.tugas.akhir.rumahsehat.service.JumlahService;
import apap.tugas.akhir.rumahsehat.service.ObatService;
import apap.tugas.akhir.rumahsehat.service.ResepService;
import apap.tugas.akhir.rumahsehat.service.TagihanService;
import apap.tugas.akhir.rumahsehat.service.UserService;

@Controller
public class ResepController {

    @Autowired
    ResepService resepService;

    @Autowired
    ObatService obatService;

    @Autowired
    JumlahService jumlahService;

    @Autowired
    AppointmentService appointmentService;

    @Autowired
    TagihanService tagihanService;

    @Autowired
    ApotekerService apotekerService;

    @Autowired
    UserService userService;

    Logger logger = LoggerFactory.getLogger(ResepController.class);
    String constResep = "resep";
    String constListJumlah = "listJumlah";
    String constListObat = "listObat";
    String notFoundError = "error/404";
    String formAddPage = "dashboard/resep/form-add";

    // List resep
    @GetMapping("/resep")
    public String getResepList(Model model, Principal principal) {
        if (userService.isApoteker(principal) || userService.isAdmin(principal)) {
            List<ResepModel> listResep = resepService.getListResep();
            model.addAttribute("listResep", listResep);
            return "dashboard/resep/list";
        } else {
            logger.error("Gagal melihat Daftar Resep. Role Anda bukan Apoteker atau Admin");
            return notFoundError;
        }
    }

    // Detail resep
    @GetMapping("/resep/{id}")
    public String getResepById(@PathVariable Long id, Model model, Principal principal, Authentication authentication) {
        if (userService.isPasien(principal)) {
            logger.error("Gagal melihat Detail Resep. Role Anda Pasien");
            return notFoundError;
        }

        ResepModel resep = resepService.getResepById(id);
        List<JumlahModel> listJumlah = resep.getJumlah();
        var isApoteker = false;
        Boolean canConfirm = resepService.canConfirm(resep);

        if (userService.isDokter(principal)
                && !authentication.getName().equals(resep.getAppointment().getDokter().getUsername())) {
            logger.error("Gagal melihat Detail Resep. Anda bukan Dokter pada Appointment {}.", resep.getAppointment().getKode());
            return notFoundError;
        }
        if (userService.isApoteker(principal)) {
            isApoteker = true;
        }

        model.addAttribute(constResep, resep);
        model.addAttribute(constListJumlah, listJumlah);
        model.addAttribute("isApoteker", isApoteker);
        model.addAttribute("canConfirm", canConfirm);
        return "dashboard/resep/detail";
    }

    // Form create resep
    @GetMapping("/resep/add/{kodeApt}")
    public String getResepAddForm(Model model, @PathVariable("kodeApt") String kodeApt, Principal principal,
            Authentication authentication) {
        String dokterLogin = authentication.getName();

        AppointmentModel apt = appointmentService.getAppointmentById(kodeApt);
        // cek rolenya dokter, dokter pada appointment, appointment belum ada resep
        if (userService.isDokter(principal) && apt.getDokter().getUsername().equals(dokterLogin)
                && apt.getResep() == null) {
            var resep = new ResepModel();
            List<ObatModel> listObat = obatService.getListObat();
            List<JumlahModel> listJumlah = jumlahService.getListJumlah();

            resep.setJumlah(new ArrayList<>());
            resep.getJumlah().add(new JumlahModel());

            model.addAttribute(constResep, resep);
            model.addAttribute(constListObat, listObat);
            model.addAttribute(constListJumlah, listJumlah);
            model.addAttribute("kodeApt", kodeApt);

            return formAddPage;
        } else {
            logger.error("Gagal membuat resep.");
            return notFoundError;
        }
    }

    // Confirmation create resep
    @PostMapping(value = "/resep/add/{kodeApt}")
    public String postResepAddForm(@ModelAttribute ResepModel resep, Model model,
            @PathVariable("kodeApt") String kodeApt) {
        AppointmentModel apt = appointmentService.getAppointmentById(kodeApt);
        apt.setResep(resep);
        resep.setAppointment(apt);

        if (resep.getJumlah() == null) {
            resep.setJumlah(new ArrayList<>());
        } else {
            var idx = 0;
            for (JumlahModel jml : resep.getJumlah()) {
                jml.setResep(resep);
                jml.setObat(resep.getJumlah().get(idx).getObat());
                jml.setKuantitas(resep.getJumlah().get(idx).getKuantitas());
                idx++;
            }
        }
        resep.setIsDone(false);
        resep.setCreatedAt(LocalDateTime.now());
        resepService.addResep(resep);

        model.addAttribute("idResep", resep.getId());
        return "dashboard/resep/confirmation-add";
    }

    // Add Row obat
    @PostMapping(value = "/resep/add/{kodeApt}", params = { "addRow" })
    public String addRowObat(@ModelAttribute ResepModel resep, Model model, @PathVariable("kodeApt") String kodeApt) {
        List<ObatModel> listObat = obatService.getListObat();
        if (resep.getJumlah() == null) {
            resep.setJumlah(new ArrayList<>());
        }

        resep.getJumlah().add(new JumlahModel());
        List<JumlahModel> listJumlah = jumlahService.getListJumlah();

        model.addAttribute(constResep, resep);
        model.addAttribute(constListJumlah, listJumlah);
        model.addAttribute(constListObat, listObat);

        return formAddPage;
    }

    // Delete Row obat
    @PostMapping(value = "/resep/add/{kodeApt}", params = { "deleteRow" })
    public String deleteRowObat(@ModelAttribute ResepModel resep, Model model, @RequestParam("deleteRow") Integer row,
            @PathVariable("kodeApt") String kodeApt) {
        List<ObatModel> listObat = obatService.getListObat();
        resep.getJumlah().remove(row.intValue());

        List<JumlahModel> listJumlah = resep.getJumlah();

        model.addAttribute(constResep, resep);
        model.addAttribute(constListJumlah, listJumlah);
        model.addAttribute(constListObat, listObat);

        return formAddPage;
    }

    // Update resep
    @GetMapping("/resep/update/{id}")
    public String resepUpdate(@PathVariable Long id, Model model, Principal principal, Authentication authentication) {
        if (userService.isApoteker(principal)) {
            ResepModel resep = resepService.getResepById(id);
            ApotekerModel apoteker = apotekerService.getApotekerByUsername(authentication.getName());

            // cek kuantitas obat, ada semua --> bisa confirm
            var canConfirm = true;
            canConfirm = resepService.canConfirm(resep);

            // update status resep, update appointment, dan buat tagihan
            if (canConfirm && !resep.getIsDone()) {
                // update resep
                resep.setIsDone(true);
                resep.setApoteker(apoteker);
                // update appointment
                resep.getAppointment().setIsDone(true);

                // buat tagihan
                Integer harga = resep.getAppointment().getDokter().getTarif();
                for (JumlahModel jml : resep.getJumlah()) {
                    harga += jml.getObat().getHarga();
                }
                var newBill = new TagihanModel();
                tagihanService.addTagihan(newBill, harga, resep.getAppointment());

                model.addAttribute(constResep, resep);
                model.addAttribute("canConfirm", canConfirm);
                return "dashboard/resep/confirmation-update";
            } else {
                return notFoundError;
            }
        } else {
            logger.error("Gagal mengkonfirmasi resep. Role Anda bukan Apoteker");
            return notFoundError;
        }
    }
}
