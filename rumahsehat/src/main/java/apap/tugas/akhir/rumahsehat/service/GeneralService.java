package apap.tugas.akhir.rumahsehat.service;

import javax.transaction.Transactional;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@Transactional
public class GeneralService {
    BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public String encrypt(String password) {
        return passwordEncoder.encode("{noop}" + password);
    }
}
