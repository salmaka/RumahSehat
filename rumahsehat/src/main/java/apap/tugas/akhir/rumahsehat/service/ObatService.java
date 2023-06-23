package apap.tugas.akhir.rumahsehat.service;

import java.util.List;
import java.util.Optional;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import apap.tugas.akhir.rumahsehat.model.JumlahModel;
import apap.tugas.akhir.rumahsehat.model.ObatModel;
import apap.tugas.akhir.rumahsehat.repository.ObatDb;

@Service
@Transactional
public class ObatService {
    @Autowired
    private ObatDb obatDb;

    @Autowired
    private JumlahService jumlahService;

    public List<ObatModel> getListObat() {
        return obatDb.findAll();
    }

    public ObatModel getObatById(String id) {
        Optional<ObatModel> obat = obatDb.findById(id);
        return obat.orElse(null);
    }

    public ObatModel updateObat(ObatModel obat) {
        obatDb.save(obat);
        return obat;
    }

    public Long pemasukanTotalObat(ObatModel obat) {
        List<JumlahModel> jumlahList = jumlahService.getListJumlah();
        Long result = 0L;

        for (JumlahModel jumlah : jumlahList) {
            if (jumlah.getObat().equals(obat)) {
                result += jumlah.getObat().getHarga();
            }
        }

        return result;
    }

    public Integer penjualanTotalObat(ObatModel obat) {
        List<JumlahModel> jumlahList = jumlahService.getListJumlah();
        Integer result = 0;

        for (JumlahModel jumlah : jumlahList) {
            if (jumlah.getObat().equals(obat)) {
                result++;
            }
        }

        return result;
    }
}
