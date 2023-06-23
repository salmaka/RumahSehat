package apap.tugas.akhir.rumahsehat.model.DTO;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class LoginAPIDTO {
    private String password;
    private String email;
}