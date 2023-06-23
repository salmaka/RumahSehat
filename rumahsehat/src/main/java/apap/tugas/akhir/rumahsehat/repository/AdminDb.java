package apap.tugas.akhir.rumahsehat.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import apap.tugas.akhir.rumahsehat.model.users.AdminModel;

@Repository
public interface AdminDb extends JpaRepository<AdminModel, String> {
    AdminModel findByUsername(String username);
}
