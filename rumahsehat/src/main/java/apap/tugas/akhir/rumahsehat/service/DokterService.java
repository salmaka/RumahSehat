package apap.tugas.akhir.rumahsehat.service;

import java.util.List;
import java.util.Optional;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import apap.tugas.akhir.rumahsehat.model.users.DokterModel;
import apap.tugas.akhir.rumahsehat.repository.DokterDb;

@Service
@Transactional
public class DokterService {
    @Autowired
    private DokterDb dokterDb;

    @Autowired
    private GeneralService generalService;

    public List<DokterModel> getListDokter() {
        return dokterDb.findAll();
    }

    public DokterModel getDokterById(String id) {
        Optional<DokterModel> dokter = dokterDb.findById(id);
        return dokter.orElse(null);
    }

    public void addDokter(DokterModel dokter) {
        String pass = generalService.encrypt(dokter.getPassword());
        dokter.setPassword(pass);
        dokterDb.save(dokter);
    }

}
