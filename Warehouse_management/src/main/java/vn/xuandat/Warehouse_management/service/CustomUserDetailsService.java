package vn.xuandat.Warehouse_management.service;

import java.util.Collections;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import vn.xuandat.Warehouse_management.entity.User;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserService userService;

    // Inject UserService để sử dụng hàm tìm kiếm User theo Email
    public CustomUserDetailsService(UserService userService) {
        this.userService = userService;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        // 1. Tìm kiếm người dùng trong Database thông qua UserService
        User user = this.userService.getUserByEmail(email);

        // 2. Nếu không tìm thấy, ném ra ngoại lệ để Spring Security xử lý (đẩy về trang login?error)
        if (user == null) {
            throw new UsernameNotFoundException("Không tìm thấy người dùng với email: " + email);
        }

        // 3. Xác định quyền dựa trên role_id từ database
        String roleName = (user.getRole() != null && user.getRole().getId() == 1) 
                      ? "ROLE_ADMIN" 
                      : "ROLE_USER";

        // 4. Chuyển đổi đối tượng User sang đối tượng UserDetails mà Spring Security hiểu được
        // Vì đang dùng NoOpPasswordEncoder, password ở đây sẽ là chuỗi thuần (VD: "123")
        return new org.springframework.security.core.userdetails.User(
                user.getEmail(),
                user.getPassword(),
                Collections.singletonList(new SimpleGrantedAuthority(roleName))
        );
    }
}