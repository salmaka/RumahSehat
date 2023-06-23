package apap.tugas.akhir.rumahsehat.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import apap.tugas.akhir.rumahsehat.model.ObatModel;

@Repository
public interface ObatDb extends JpaRepository<ObatModel, String> {

}
