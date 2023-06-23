package apap.tugas.akhir.rumahsehat.model;

import java.io.Serializable;
import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.springframework.format.annotation.DateTimeFormat;

import apap.tugas.akhir.rumahsehat.model.users.DokterModel;
import apap.tugas.akhir.rumahsehat.model.users.PasienModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Entity
// @JsonIgnoreProperties(value={"appointment"}, allowSetters = true)
@Table(name = "appointment")

public class AppointmentModel implements Serializable {
    @Id
    @Size(max = 30)
    @Column(name = "kode")
    private String Kode;

    @NotNull
    @Column(name = "isDone", nullable = false)
    private Boolean isDone;

    @NotNull
    @Column(nullable = false, name = "waktu_awal")
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime waktuAwal;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "dokterId", referencedColumnName = "id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private DokterModel dokter;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "pasienId", referencedColumnName = "id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private PasienModel pasien;

    @OneToOne(mappedBy = "appointment")
    private TagihanModel tagihan;

    @OneToOne(mappedBy = "appointment")
//    @JsonIgnore
    private ResepModel resep;

}
