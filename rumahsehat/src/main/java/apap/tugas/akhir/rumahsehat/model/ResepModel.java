package apap.tugas.akhir.rumahsehat.model;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonIgnore;

import apap.tugas.akhir.rumahsehat.model.users.ApotekerModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

// @JsonIgnoreProperties(value={"resep"}, allowSetters = true)
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "resep")
public class ResepModel implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull
    @Column(name = "isDone", nullable = false)
    private Boolean isDone;

    @NotNull
    @Column(nullable = false, name = "created_at")
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime createdAt;


    @OneToOne(cascade = CascadeType.ALL)
    @JoinTable(name = "resep_appointment", joinColumns = {
            @JoinColumn(name = "resep_id", referencedColumnName = "id") }, inverseJoinColumns = {
                    @JoinColumn(name = "appointment_kode", referencedColumnName = "kode") })
    @JsonIgnore
    private AppointmentModel appointment;

    @OneToMany(mappedBy = "resep", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JsonIgnore
    private transient List<JumlahModel> jumlah;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(nullable = true, name = "confirmer_uuid", referencedColumnName = "id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private ApotekerModel apoteker;

}
