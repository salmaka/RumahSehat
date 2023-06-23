package apap.tugas.akhir.rumahsehat.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import apap.tugas.akhir.rumahsehat.model.ResepModel;

@Repository
public interface ResepDb extends JpaRepository<ResepModel, Long> {

}