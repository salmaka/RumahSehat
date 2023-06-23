package apap.tugas.akhir.rumahsehat.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.transaction.Transactional;

import apap.tugas.akhir.rumahsehat.model.DTO.JumlahDTO;
import apap.tugas.akhir.rumahsehat.model.DTO.ResepDTO;
import apap.tugas.akhir.rumahsehat.model.JumlahModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import apap.tugas.akhir.rumahsehat.model.ResepModel;
import apap.tugas.akhir.rumahsehat.repository.ResepDb;

@Service
@Transactional
public class ResepService {
    @Autowired
    private ResepDb resepDb;

    public List<ResepModel> getListResep() {
        return resepDb.findAll();
    }

    public ResepModel getResepById(Long id) {
        Optional<ResepModel> resep = resepDb.findById(id);
        return resep.orElse(null);
    }

    public void addResep(ResepModel resep) {
        resepDb.save(resep);
    }

    public ResepDTO getResepApi (ResepModel resep){
        List<JumlahDTO> listObat = new ArrayList<>();
        for (JumlahModel obat : resep.getJumlah()){
            var med = new JumlahDTO(obat.getObat().getNamaObat(), obat.getKuantitas());
            listObat.add(med);
        }
        var apiResep = new ResepDTO(resep.getId(), resep.getAppointment().getDokter().getNama(),
                resep.getAppointment().getPasien().getNama(), listObat);
        if (resep.getApoteker() != null){
            apiResep.setApoteker(resep.getApoteker().getNama());
        }
        else {
            apiResep.setApoteker("-");
        }
        if (resep.getIsDone()){
            apiResep.setStatusResep("Selesai");
        }
        else apiResep.setStatusResep("Belum Selesai");

        return apiResep;
    }

    public Boolean canConfirm(ResepModel resep) {
        Boolean canConfirm = true;
        for (JumlahModel obat : resep.getJumlah()){
            if (obat.getObat().getStok() < obat.getKuantitas()){
                canConfirm = false;
                break;
            }
        }
        return canConfirm;
    }

}
