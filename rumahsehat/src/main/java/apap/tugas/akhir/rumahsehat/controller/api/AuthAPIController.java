package apap.tugas.akhir.rumahsehat.controller.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import apap.tugas.akhir.rumahsehat.model.DTO.LoginAPIDTO;
import apap.tugas.akhir.rumahsehat.service.AuthService;

@CrossOrigin()
@RestController
@RequestMapping("/api/v1")
public class AuthAPIController {

    @Autowired
    AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginAPIDTO loginAPIDTO) {
        String token = authService.getToken(loginAPIDTO);

        if (token == null) {
            return new ResponseEntity<>("Unauthorized", HttpStatus.UNAUTHORIZED);
        }
        return new ResponseEntity<>(authService.getToken(loginAPIDTO), HttpStatus.OK);
    }

    @GetMapping("/info")
    public ResponseEntity<?> getUserInfo(@RequestHeader("Authorization") String bearerToken) {
        if (!authService.tokenCheck(bearerToken)) {
            return new ResponseEntity<>("Unauthorized", HttpStatus.UNAUTHORIZED);
        }
        return new ResponseEntity<>(authService.getUserInfo(bearerToken), HttpStatus.OK);
    }
}
