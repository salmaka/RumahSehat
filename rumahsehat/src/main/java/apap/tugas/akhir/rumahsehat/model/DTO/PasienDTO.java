package apap.tugas.akhir.rumahsehat.model.DTO;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class PasienDTO {
    private String nama;
    private String username;
    private String password;
    private String email;
    private Integer saldo;
    private Integer umur;
}