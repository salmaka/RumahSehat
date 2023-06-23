package apap.tugas.akhir.rumahsehat.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import apap.tugas.akhir.rumahsehat.model.users.UserModel;

@Repository
public interface UserDb extends JpaRepository<UserModel, String> {
    UserModel findByUsername(String username);

    UserModel findByEmail(String email);
    
}
