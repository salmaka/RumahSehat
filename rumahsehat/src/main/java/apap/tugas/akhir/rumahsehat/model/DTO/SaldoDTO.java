package apap.tugas.akhir.rumahsehat.model.DTO;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
public class SaldoDTO {
    private String username;
    private Integer saldo;

    public SaldoDTO(String username, Integer saldo) {
        this.username = username;
        this.saldo = saldo;
    }
}
