package apap.tugas.akhir.rumahsehat.model.users;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

import apap.tugas.akhir.rumahsehat.model.AppointmentModel;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "pasien")
public class PasienModel extends UserModel {

    @NotNull
    @Column(name = "saldo", nullable = false)
    private Integer saldo;

    @NotNull
    private Integer umur;

    @OneToMany(mappedBy = "pasien", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JsonIgnore
    private List<AppointmentModel> listAppointment;
}
