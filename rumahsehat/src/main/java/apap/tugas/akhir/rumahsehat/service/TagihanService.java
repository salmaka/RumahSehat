package apap.tugas.akhir.rumahsehat.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.transaction.Transactional;

import apap.tugas.akhir.rumahsehat.model.AppointmentModel;
import apap.tugas.akhir.rumahsehat.model.JumlahModel;
import apap.tugas.akhir.rumahsehat.model.ObatModel;
import apap.tugas.akhir.rumahsehat.model.ResepModel;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import apap.tugas.akhir.rumahsehat.model.TagihanModel;
import apap.tugas.akhir.rumahsehat.model.DTO.TagihanDTO;
import apap.tugas.akhir.rumahsehat.model.users.PasienModel;
import apap.tugas.akhir.rumahsehat.repository.TagihanDb;

@Service
@Transactional
public class TagihanService {
    @Autowired
    private TagihanDb tagihanDb;

    @Autowired
    PasienService pasienService;

    String constLunas = "LUNAS";
    String constBelumLunas = "BELUM LUNAS";

    public List<TagihanModel> getListTagihan() {
        return tagihanDb.findAll();
    }

    public List<TagihanDTO> getTagihanDTO(String idPasien) {
        List<TagihanModel> tagihan = tagihanDb.findAll();
        List<TagihanDTO> tagihanDTO = new ArrayList<>();

        for (TagihanModel aTagihan: tagihan){
            if(aTagihan.getAppointment().getPasien().getId().equals(idPasien)){
                var newTagihan = new TagihanDTO();
                PasienModel pasien = aTagihan.getAppointment().getPasien();
                newTagihan.setNomorTagihan(aTagihan.getKode());
                newTagihan.setTanggalTerbuat(aTagihan.getTanggalTerbuat().toString());
                newTagihan.setIdPasien(pasien.getId());
                newTagihan.setJumlahTagihan(aTagihan.getJumlahTagihan());

                // Cek Status Pasien
                if (aTagihan.getIsPaid()){
                    newTagihan.setStatus(constLunas);
                    newTagihan.setTanggalBayar(aTagihan.getTanggalBayar().toString());
                } else{
                    newTagihan.setStatus(constBelumLunas);
                    newTagihan.setTanggalBayar("Anda belum melunasi pembayaran");
                }

                tagihanDTO.add(newTagihan);
            }
        }
        return tagihanDTO;
    }

    public TagihanDTO getTagihanById(String id) {
        TagihanModel tagihan;
        Optional<TagihanModel> opt = tagihanDb.findById(id);
        tagihan = opt.orElse(null);
        if (tagihan == null) {
            return null;
        }

        var tagihanDTO = new TagihanDTO();

        tagihanDTO.setIdPasien(tagihan.getAppointment().getPasien().getId());
        tagihanDTO.setNomorTagihan(tagihan.getKode());
        tagihanDTO.setTanggalTerbuat(tagihan.getTanggalTerbuat().toString());
        tagihanDTO.setJumlahTagihan(tagihan.getJumlahTagihan());

        // Cek Status Pasien
        if (tagihan.getIsPaid()){
            tagihanDTO.setStatus(constLunas);
            tagihanDTO.setTanggalBayar(tagihan.getTanggalBayar().toString());
        } else{
            tagihanDTO.setStatus(constBelumLunas);
            tagihanDTO.setTanggalBayar("Anda belum melunasi pembayarab");
        }
        return tagihanDTO;
    }

    public TagihanDTO pembayaranTagihan(String id) {
        TagihanModel tagihan;
        Optional<TagihanModel> opt = tagihanDb.findById(id);
        tagihan = opt.orElse(null);
        if (tagihan == null) {
            return null;
        }

        var tagihanDTO = new TagihanDTO();

        // Pemilik tagihan dan saldonya
        PasienModel pasien = tagihan.getAppointment().getPasien();
        int saldoBaru = pasien.getSaldo() - tagihan.getJumlahTagihan();

        // Pembayaran valid: Set pembayaran terbayar dan tanggal ke model tagihan
        if(pasien.getSaldo() > tagihan.getJumlahTagihan()){
            ResepModel resep = tagihan.getAppointment().getResep(); 
            // Mengecek apakah terdapat tagihan untuk resep obat
            if (resep != null){
                List<JumlahModel> listResepTagihan = resep.getJumlah();
                for(JumlahModel jumlahModel: listResepTagihan){
                    ObatModel obat = jumlahModel.getObat();
                    int jumlahObat = jumlahModel.getKuantitas();
                    
                    // Update stok onat
                    obat.setStok(obat.getStok() - jumlahObat);
                }

            }
            tagihan.setTanggalBayar(LocalDateTime.now());
            tagihan.setIsPaid(true);
            pasien.setSaldo(saldoBaru);
        } 

        // Buat tagihanDTO untuk di-pass
        tagihanDTO.setIdPasien(tagihan.getAppointment().getPasien().getId());
        tagihanDTO.setNomorTagihan(tagihan.getKode());
        tagihanDTO.setTanggalTerbuat(tagihan.getTanggalTerbuat().toString());
        tagihanDTO.setJumlahTagihan(tagihan.getJumlahTagihan());

        // Cek Status Pasien
        if (tagihan.getIsPaid()){
            tagihanDTO.setStatus(constLunas);
            tagihanDTO.setTanggalBayar(tagihan.getTanggalBayar().toString());
        } else{
            tagihanDTO.setStatus(constBelumLunas);
            tagihanDTO.setTanggalBayar("Anda belum melunasi pembayarab");
        }

        return tagihanDTO;
    }


    public TagihanModel addTagihan(TagihanModel newTagihan, Integer jumlahTagihan, AppointmentModel appointment) {
        // set default values
        int count = getListTagihan().size();
        newTagihan.setKode("BILL-" + (count+1));
        newTagihan.setIsPaid(false);
        newTagihan.setTanggalTerbuat(LocalDateTime.now());
        newTagihan.setTanggalBayar(null);
        newTagihan.setJumlahTagihan(jumlahTagihan);
        newTagihan.setAppointment(appointment);

        // save
        return tagihanDb.save(newTagihan);
    }

    public Long getTotalPendapatan (String month){
        Long result = 0L;
        List<TagihanModel> listBill = tagihanDb.findAll();

        for (TagihanModel check : listBill){
            if (check.getIsPaid() && check.getTanggalBayar().getMonth().toString().equals(month)){
                for (JumlahModel obat : check.getAppointment().getResep().getJumlah()){
                    result = result + (obat.getObat().getHarga() * obat.getKuantitas());
                }
            }
        }
        return result;
    }
}
