package apap.tugas.akhir.rumahsehat.service;

import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import apap.tugas.akhir.rumahsehat.model.DTO.LoginAPIDTO;
import apap.tugas.akhir.rumahsehat.model.users.UserModel;
import apap.tugas.akhir.rumahsehat.repository.UserDb;
import org.springframework.web.server.ResponseStatusException;

@Service
@Transactional
public class AuthService {
    @Autowired
    private UserDb userDb;

    @Autowired
    private UserService userService;

    BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public String getToken(LoginAPIDTO loginAPIDTO) {
        String token = tokenGenerator(256);
        UserModel user = userService.getUserByEmail(loginAPIDTO.getEmail());

        if (encoder.matches(loginAPIDTO.getPassword(), user.getPassword())) {
            user.setToken(token);
            return token;
        }
        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found.");
    }

    public UserModel getUserInfo(String token) {
        List<UserModel> listUser = userDb.findAll();
        String tokenparsed = token.split(" ")[1];
        for (UserModel user : listUser) {
            if (tokenparsed.equals(user.getToken())) {
                return user;
            }
        }
        return null;
    }

    public boolean tokenCheck(String token) {
        List<UserModel> listUser = userDb.findAll();
        String tokenparsed = token.split(" ")[1];
        for (UserModel user : listUser) {
            if (tokenparsed.equals(user.getToken())) {
                return true;
            }
        }
        return false;
    }

    static String tokenGenerator(int n) {

        var array = new byte[256];
        var random = new SecureRandom();
        random.nextBytes(array);
        var randomString = new String(array, StandardCharsets.UTF_8);

        var r = new StringBuilder();

        for (var k = 0; k < randomString.length(); k++) {
            var ch = randomString.charAt(k);
            if (((ch >= 'a' && ch <= 'z')
                    || (ch >= 'A' && ch <= 'Z')
                    || (ch >= '0' && ch <= '9'))
                    && (n > 0)) {
                r.append(ch);
                n--;
            }
        }
        return r.toString();
    }

}
