package apap.tugas.akhir.rumahsehat.model.users;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import apap.tugas.akhir.rumahsehat.model.ResepModel;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Entity
@Table(name = "apoteker")
public class ApotekerModel extends UserModel {
    @OneToMany(mappedBy = "apoteker", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JsonIgnore
    private List<ResepModel> listResep;
}