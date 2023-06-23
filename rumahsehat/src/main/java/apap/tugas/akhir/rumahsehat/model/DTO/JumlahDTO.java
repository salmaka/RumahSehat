package apap.tugas.akhir.rumahsehat.model.DTO;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class JumlahDTO {
    private String namaObat;
    private Integer kuantitas;

    public JumlahDTO(String obat, Integer kuantitas) {
        this.namaObat = obat;
        this.kuantitas = kuantitas;
    }
}
