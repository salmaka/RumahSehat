package apap.tugas.akhir.rumahsehat.controller.api;

import java.util.NoSuchElementException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import apap.tugas.akhir.rumahsehat.controller.web.PasienController;
import apap.tugas.akhir.rumahsehat.model.DTO.PasienDTO;
import apap.tugas.akhir.rumahsehat.model.DTO.SaldoDTO;
import apap.tugas.akhir.rumahsehat.model.users.PasienModel;
import apap.tugas.akhir.rumahsehat.service.PasienService;
import apap.tugas.akhir.rumahsehat.service.UserService;

@CrossOrigin()
@RestController
@RequestMapping("/api/v1")
public class PasienAPIController {

    @Autowired
    PasienService pasienService;

    @Autowired
    UserService userService;

    Logger logger = LoggerFactory.getLogger(PasienController.class);

    // Confirmation create pasien
    @PostMapping(value = "/pasien/add")
    public PasienModel createPasien(@RequestBody PasienDTO pasien, BindingResult bindingResult) {
        if (bindingResult.hasFieldErrors()) {
            logger.error("Gagal API POST: Bad Request.");
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Request body has invalid type or missing field.");
        } else {
            logger.info("API POST: Pasien baru berhasil dibuat.");
            return pasienService.addPasien(pasien);
        }
    }

    @GetMapping("/pasien/{pasienId}")
    public PasienModel getUserProfile(@PathVariable("pasienId") String pasienId) {
        try {
            logger.info("API GET: Informasi Pasien {}.", pasienId);
            return (PasienModel) userService.getRestUserById(pasienId);
        } catch (NoSuchElementException e) {
            logger.error("Gagal API GET: Kode pasien tidak ditemukan.");
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Pasien ID " + pasienId + " not found.");
        }
    }

    @PostMapping("/pasien/addSaldo")
    public PasienModel updateSaldo(@RequestBody SaldoDTO saldoPasien, BindingResult bindingResult) {
        if (bindingResult.hasFieldErrors()) {
            logger.error("Gagal API POST: Bad Request.");
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Request body has invalid type or missing field.");
        } else {
            logger.info("API POST: Saldo pasien berhasil diubah.");
            var saldo = new SaldoDTO(saldoPasien.getUsername(), saldoPasien.getSaldo());
            return pasienService.updatePasien(saldo.getUsername(), saldo.getSaldo());
        }
    }
}
