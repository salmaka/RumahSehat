package apap.tugas.akhir.rumahsehat.service;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import apap.tugas.akhir.rumahsehat.model.users.ApotekerModel;
import apap.tugas.akhir.rumahsehat.repository.ApotekerDb;

@Service
@Transactional
public class ApotekerService {
    @Autowired
    private ApotekerDb apotekerDb;

    @Autowired
    private GeneralService generalService;

    public List<ApotekerModel> getListApoteker() {
        return apotekerDb.findAll();
    }

    public ApotekerModel getApotekerByUsername(String username){
        return apotekerDb.findByUsername(username);
    }

    public void addApoteker(ApotekerModel apoteker) {
        String pass = generalService.encrypt(apoteker.getPassword());
        apoteker.setPassword(pass);
        apotekerDb.save(apoteker);
    }
}
