package apap.tugas.akhir.rumahsehat.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig {
    String adminRole = "ADMIN";
    String dokterRole = "DOKTER";
    String pasienRole = "PASIEN";

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf().disable()
                .authorizeRequests()
                .antMatchers("/css/**").permitAll()
                .antMatchers("/js/**").permitAll()
                .antMatchers("/bootstrap/**").permitAll()
                .antMatchers("/dist/**").permitAll()
                .antMatchers("/plugins/**").permitAll()
                .antMatchers("/api/v1/appointment/**").hasAuthority(pasienRole)
                .antMatchers("/api/v1/dokter").hasAuthority(pasienRole)
                .antMatchers("/api/v1/resep/{id}").hasAnyAuthority(pasienRole)
                .antMatchers("/api/**").permitAll()
                .antMatchers("/login-sso", "/validate-ticket").permitAll()
                .antMatchers("/appointment").hasAnyAuthority(adminRole, dokterRole)
                .antMatchers("/appointment/detail/**").hasAnyAuthority(adminRole, dokterRole)
                .antMatchers("/appointment/update/**").hasAuthority(dokterRole)
                .antMatchers("/resep/add/{kode}").hasAnyAuthority(dokterRole)
                .antMatchers("/resep").hasAnyAuthority("APOTEKER", adminRole)
                .antMatchers("/apoteker").hasAnyAuthority(adminRole)
                .antMatchers("/dokter").hasAnyAuthority(adminRole)
                .antMatchers("/pasien").hasAnyAuthority(adminRole)
                .antMatchers("/apoteker/add").hasAnyAuthority(adminRole)
                .antMatchers("/dokter/add").hasAnyAuthority(adminRole)
                .antMatchers("/chart/*").hasAnyAuthority(adminRole)
                .anyRequest().authenticated()
                .and()
                .formLogin()
                .loginPage("/login").permitAll()
                .and()
                .logout().logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                .logoutSuccessUrl("/login").permitAll();
        return http.build();
    }

    @Bean
    public BCryptPasswordEncoder encoder() {
        return new BCryptPasswordEncoder();
    }

}
