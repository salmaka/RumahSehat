package apap.tugas.akhir.rumahsehat.controller.api;

import java.util.List;
import java.util.NoSuchElementException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import apap.tugas.akhir.rumahsehat.controller.web.AppointmentController;
import apap.tugas.akhir.rumahsehat.model.users.DokterModel;
import apap.tugas.akhir.rumahsehat.service.DokterService;

@CrossOrigin()
@RestController
@RequestMapping("/api/v1")
public class DokterAPIController {

    @Autowired
    DokterService dokterService;

    Logger logger = LoggerFactory.getLogger(AppointmentController.class);

    // List dokter
    @GetMapping("/dokter")
    public List<DokterModel> getDokterList() {
        try {
            logger.info("API GET: Daftar semua dokter.");
            return dokterService.getListDokter();
        } catch (NoSuchElementException e) {
            logger.error("Gagal API GET: Tidak ada dokter ditemukan.");
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Belum ada dokter tersedia");
        }
    }
}
