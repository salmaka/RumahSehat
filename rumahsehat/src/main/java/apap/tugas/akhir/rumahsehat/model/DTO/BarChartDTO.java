package apap.tugas.akhir.rumahsehat.model.DTO;

import apap.tugas.akhir.rumahsehat.model.ObatModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class BarChartDTO {
    private ObatModel obat1;

    private ObatModel obat2;

    private ObatModel obat3;

    private ObatModel obat4;

    private ObatModel obat5;

    private ObatModel obat6;

    private ObatModel obat7;

    private ObatModel obat8;

    private String type;

}
