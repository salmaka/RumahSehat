package apap.tugas.akhir.rumahsehat.model.DTO;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class AppointmentDTO {
    private LocalDateTime waktuAwal;
    private String dokterId;
    private String pasienId;
}
