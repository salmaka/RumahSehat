package apap.tugas.akhir.rumahsehat.service;

import java.util.List;
import java.util.Optional;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import apap.tugas.akhir.rumahsehat.model.DTO.PasienDTO;
import apap.tugas.akhir.rumahsehat.model.users.PasienModel;
import apap.tugas.akhir.rumahsehat.model.users.UserType;
import apap.tugas.akhir.rumahsehat.repository.PasienDb;

@Service
@Transactional
public class PasienService {
    @Autowired
    private PasienDb pasienDb;

    @Autowired
    private GeneralService generalService;

    public List<PasienModel> getListPasien() {
        return pasienDb.findAll();
    }

    public PasienModel getPasienById(String id) {
        Optional<PasienModel> pasien = pasienDb.findById(id);
        return pasien.orElse(null);
    }

    public PasienModel addPasien(PasienDTO pasien) {
        var newPasien = new PasienModel();
        newPasien.setNama(pasien.getNama());
        newPasien.setUsername(pasien.getUsername());
        String pass = generalService.encrypt(pasien.getPassword());
        newPasien.setPassword(pass);
        newPasien.setEmail(pasien.getEmail());
        newPasien.setUmur(pasien.getUmur());
        newPasien.setSaldo(0);
        newPasien.setIsSso(false);
        newPasien.setRole(UserType.PASIEN);
        newPasien.setToken("0");
        return pasienDb.save(newPasien);
    }

    public PasienModel updatePasien(String username, int saldo) {
        PasienModel updatePasien = pasienDb.findByUsername(username);
        updatePasien.setSaldo(updatePasien.getSaldo()+saldo);
        return pasienDb.save(updatePasien);
    }
}
