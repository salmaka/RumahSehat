package apap.tugas.akhir.rumahsehat.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

// @JsonIgnoreProperties(value={"appointment"}, allowSetters = true)
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "obat")
public class ObatModel implements Serializable {

    @Id
    @Size(max = 30)
    @Column(name = "id_obat")
    private String idObat;

    @NotNull
    @Size(max = 100)
    @Column(name = "nama_obat", nullable = false)
    private String namaObat;

    @NotNull
    @Column(name = "harga", nullable = false)
    private Integer harga;

    // @NotNull
    @Column(name = "stok", nullable = true, columnDefinition = "integer default 100")
    private Integer stok;

    @OneToMany(mappedBy = "obat", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private transient List<JumlahModel> jumlah;

}
