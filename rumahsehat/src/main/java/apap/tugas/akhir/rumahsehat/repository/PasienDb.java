package apap.tugas.akhir.rumahsehat.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import apap.tugas.akhir.rumahsehat.model.users.PasienModel;

@Repository
public interface PasienDb extends JpaRepository<PasienModel, String> {
    PasienModel findByUsername(String username);
}
