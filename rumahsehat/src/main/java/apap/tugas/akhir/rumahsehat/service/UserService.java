package apap.tugas.akhir.rumahsehat.service;

import java.security.Principal;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import apap.tugas.akhir.rumahsehat.model.users.UserModel;
import apap.tugas.akhir.rumahsehat.model.users.UserType;
import apap.tugas.akhir.rumahsehat.repository.UserDb;

@Service
@Transactional
public class UserService {
    @Autowired
    private UserDb userDb;

    public List<UserModel> getListUser() {
        return userDb.findAll();
    }

    public UserModel getUserById(String id) {
        Optional<UserModel> user = userDb.findById(id);
        return user.orElse(null);
    }

    public UserModel getRestUserById(String id) {
        Optional<UserModel> user = userDb.findById(id);
        if (user.isPresent()) {
            return user.get();
        } else {
            throw new NoSuchElementException();
        }
    }

    public void addUser(UserModel user) {
        userDb.save(user);
    }

    public UserModel updateUser(UserModel user) {
        userDb.save(user);
        return user;
    }

    public UserModel deleteUser(UserModel user) {
        userDb.delete(user);
        return user;
    }

    public String encrypt(String password) {
        var passwordEncoder = new BCryptPasswordEncoder();
        return passwordEncoder.encode("{noop}" + password);
    }

    public UserModel getUserByUsername(String username) {
        return userDb.findByUsername(username);
    }

    public UserModel getUserByEmail(String email) {
        return userDb.findByEmail(email);
    }

    public boolean isAdmin(Principal principal) {
        UserModel user = userDb.findByUsername(principal.getName());
        return user.getRole().equals(UserType.ADMIN);
    }

    public boolean isApoteker(Principal principal) {
        UserModel user = userDb.findByUsername(principal.getName());
        return user.getRole().equals(UserType.APOTEKER);
    }

    public boolean isDokter(Principal principal) {
        UserModel user = userDb.findByUsername(principal.getName());
        return user.getRole().equals(UserType.DOKTER);
    }

    public boolean isPasien(Principal principal) {
        UserModel user = userDb.findByUsername(principal.getName());
        return user.getRole().equals(UserType.PASIEN);
    }
}
