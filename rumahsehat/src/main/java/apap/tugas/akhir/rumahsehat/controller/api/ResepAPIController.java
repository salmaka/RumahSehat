package apap.tugas.akhir.rumahsehat.controller.api;

import java.util.NoSuchElementException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import apap.tugas.akhir.rumahsehat.controller.web.ResepController;
import apap.tugas.akhir.rumahsehat.model.ResepModel;
import apap.tugas.akhir.rumahsehat.model.DTO.ResepDTO;
import apap.tugas.akhir.rumahsehat.service.ResepService;

@CrossOrigin()
@RestController
@RequestMapping("/api/v1")
public class ResepAPIController {

    @Autowired
    ResepService resepService;

    Logger logger = LoggerFactory.getLogger(ResepController.class);

    // Detail resep
    @GetMapping("/resep/{id}")
    public ResepDTO getResepById(@PathVariable Long id) {
        try {
            logger.info("API GET: Detail Resep {}.", id);
            ResepModel resep = resepService.getResepById(id);
            return resepService.getResepApi(resep);
        } catch (NoSuchElementException e) {
            logger.error("Gagal API GET: Kode resep tidak ditemukan.");
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "ID Resep " + id + " not found.");
        }
    }

}
