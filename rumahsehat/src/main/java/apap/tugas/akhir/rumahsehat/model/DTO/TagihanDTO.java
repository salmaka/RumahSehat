package apap.tugas.akhir.rumahsehat.model.DTO;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class TagihanDTO {
    private String nomorTagihan;
    private String tanggalTerbuat;
    private String status;
    private String idPasien;
    private int jumlahTagihan;
    private String tanggalBayar;
}
