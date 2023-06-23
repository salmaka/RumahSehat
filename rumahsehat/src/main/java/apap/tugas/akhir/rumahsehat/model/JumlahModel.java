package apap.tugas.akhir.rumahsehat.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "jumlah")
public class JumlahModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull
    @Column(nullable = false, name = "kuantitas")
    private Integer kuantitas;

    @ManyToOne
    @JoinColumn(name = "resep_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    ResepModel resep;

    @ManyToOne
    @JoinColumn(name = "obat_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    ObatModel obat;

    public void setId(Long id) {
        this.id = id;
    }
}
