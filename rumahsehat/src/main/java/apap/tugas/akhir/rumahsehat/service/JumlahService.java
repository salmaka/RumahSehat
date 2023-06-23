package apap.tugas.akhir.rumahsehat.service;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import apap.tugas.akhir.rumahsehat.model.JumlahModel;
import apap.tugas.akhir.rumahsehat.repository.JumlahDb;

@Service
@Transactional
public class JumlahService {
    @Autowired
    private JumlahDb jumlahDb;

    public List<JumlahModel> getListJumlah() {
        return jumlahDb.findAll();
    }

}
