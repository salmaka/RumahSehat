package apap.tugas.akhir.rumahsehat.controller.api;

import java.util.List;
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

import apap.tugas.akhir.rumahsehat.controller.web.AppointmentController;
import apap.tugas.akhir.rumahsehat.model.AppointmentModel;
import apap.tugas.akhir.rumahsehat.model.DTO.AppointmentDTO;
import apap.tugas.akhir.rumahsehat.model.users.PasienModel;
import apap.tugas.akhir.rumahsehat.service.AppointmentService;
import apap.tugas.akhir.rumahsehat.service.UserService;

@CrossOrigin()
@RestController
@RequestMapping("/api/v1")
public class AppointmentAPIController {

    @Autowired
    AppointmentService appointmentService;

    @Autowired
    UserService userService;

    private static final Logger logger = LoggerFactory.getLogger(AppointmentController.class);

    // List appointment
    @GetMapping("/appointment/{pasienId}")
    public List<AppointmentModel> getAppointmentList(@PathVariable("pasienId") String pasienId) {
        try {
            PasienModel pasien = (PasienModel) userService.getRestUserById(pasienId);
            logger.info("API GET: Daftar appointment milik pasien {}.", pasien.getId());
            return pasien.getListAppointment();
        } catch (NoSuchElementException e) {
            logger.error("Gagal API GET: Kode pasien tidak ditemukan.");
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Kode Pasien " + pasienId + " not found.");
        }
    }

    // Detail appointment
    @GetMapping("/appointment/detail/{kode}")
    public AppointmentModel getAppointmentById(@PathVariable("kode") String kode) {
        try {
            logger.info("API GET: Detail appointment {}.", kode);
            return appointmentService.getRestAppointmentById(kode);
        } catch (NoSuchElementException e) {
            logger.error("Gagal API GET: Kode appointment tidak ditemukan.");
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Appointment Kode " + kode + " not found.");
        }
    }

    // Form create appointment
    @PostMapping("/appointment/add")
    public AppointmentModel getAppointmentAddForm(@RequestBody AppointmentDTO appointmentDTO,
            BindingResult bindingResult) {
        if (bindingResult.hasFieldErrors()) {
            logger.error("Gagal API POST: Bad Request.");
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Request body has invalid type or missing field");
        } else {
            AppointmentModel result = appointmentService.addAppointment(appointmentDTO);
            if (result == null) {
                logger.error("Gagal membuat appointment. Dokter tidak tersedia di waktu tersebut.");
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Waktu appointment tidak tersedia.");
            } else {
                logger.info("API POST: Appointment baru berhasil dibuat.");
                return result;
            }
        }
    }
}