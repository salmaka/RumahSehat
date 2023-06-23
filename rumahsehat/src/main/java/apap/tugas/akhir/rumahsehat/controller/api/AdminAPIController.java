package apap.tugas.akhir.rumahsehat.controller.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import apap.tugas.akhir.rumahsehat.service.AdminService;
import apap.tugas.akhir.rumahsehat.service.AuthService;

@CrossOrigin()
@RestController
@RequestMapping("/api/v1")
public class AdminAPIController {

    @Autowired
    AdminService adminService;

    @Autowired
    AuthService authService;

    // List admin
    @GetMapping("/admin")
    public ResponseEntity<?> getAdminList(@RequestHeader("Authorization") String bearerToken) {
        if (!authService.tokenCheck(bearerToken)) {
            return new ResponseEntity<>("Unauthorized", HttpStatus.UNAUTHORIZED);
        }
        return new ResponseEntity<>(adminService.getListAdmin(), HttpStatus.OK);
    }
}
