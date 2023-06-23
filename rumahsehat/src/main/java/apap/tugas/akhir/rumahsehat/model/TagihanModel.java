package apap.tugas.akhir.rumahsehat.model;

import java.io.Serializable;
import java.time.LocalDateTime;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import org.springframework.format.annotation.DateTimeFormat;

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
@Table(name = "tagihan")

public class TagihanModel implements Serializable {
    @Id
    @Size(max = 30)
    private String Kode;

    @NotNull
    @Column(name = "isPaid", nullable = false)
    private Boolean isPaid;

    @NotNull
    @Column(nullable = false, name = "tanggal_terbuat")
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime tanggalTerbuat;

    @Column(nullable = true, name = "tanggal_bayar")
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime tanggalBayar;

    @NotNull
    @Column(name = "jumlah_tagihan", nullable = false)
    private Integer jumlahTagihan;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "appointment_kode", referencedColumnName = "kode")
    @JsonIgnore
    private AppointmentModel appointment;

}
