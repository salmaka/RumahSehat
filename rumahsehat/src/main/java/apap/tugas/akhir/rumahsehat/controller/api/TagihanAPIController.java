package apap.tugas.akhir.rumahsehat.controller.api;

import java.util.List;
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

import apap.tugas.akhir.rumahsehat.controller.web.TagihanController;
import apap.tugas.akhir.rumahsehat.model.DTO.TagihanDTO;
import apap.tugas.akhir.rumahsehat.service.TagihanService;

@CrossOrigin()
@RestController
@RequestMapping("/api/v1")
public class TagihanAPIController {

    @Autowired
    TagihanService tagihanService;

    Logger logger = LoggerFactory.getLogger(TagihanController.class);

    // All tagihan pasien
    @GetMapping("/tagihan/{id}")
    public List<TagihanDTO> getTagihanPasien(@PathVariable("id") String id) {
        try {
            List<TagihanDTO> tagihanDTO = tagihanService.getTagihanDTO(id);
            logger.info("API GET: Daftar tagihan milik pasien");
            return tagihanDTO;
        } catch (NoSuchElementException e) {
            logger.error("Gagal API GET: Kode pasien tidak ditemukan.");
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Kode Pasien not found.");
        }
    }

    // Detail tagihan pasien
    @GetMapping("/tagihan/detail/{id}")
    public TagihanDTO getDetailTagihan(@PathVariable("id") String id) {
        try {
            logger.info("API GET: Detail Tagihan {}.", id);
            return tagihanService.getTagihanById(id);
        } catch (Exception e) {
            logger.error("Gagal API GET: Kode tagihan tidak ditemukan.");
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Tagihan not found.");
        }
    }

    // Pembayaran tagihan
    @GetMapping("/tagihan/pembayaran/{noTagihan}")
    public TagihanDTO pembayaranTagihan(@PathVariable("noTagihan") String noTagihan) {
        try {
            logger.info("API GET: Validitas pembayaran tagihan {}.", noTagihan);
            return tagihanService.pembayaranTagihan(noTagihan);
        } catch (Exception e) {
            logger.error("Gagal API GET: Kode tagihan tidak ditemukan.");
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Tagihan not found.");
        }
    }
}
