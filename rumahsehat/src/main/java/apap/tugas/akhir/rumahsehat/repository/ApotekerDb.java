package apap.tugas.akhir.rumahsehat.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import apap.tugas.akhir.rumahsehat.model.users.ApotekerModel;

@Repository
public interface ApotekerDb extends JpaRepository<ApotekerModel, String> {
    ApotekerModel findByUsername(String username);
}
