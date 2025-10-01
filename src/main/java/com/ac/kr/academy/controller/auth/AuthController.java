package com.ac.kr.academy.controller.auth;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * JSP 페이지 이동 역할
 */

@Controller
@RequestMapping("/auth")
public class AuthController {

    //기본 루트 접속시 로그인페이지로 이동
    @GetMapping("/")
    public String home(){
        return "redirect:/auth/login";
    }

    @GetMapping("/login")
    public String loginPage(){
        return "auth/login";
    }

    //로그인 성공 시 메인 페이지로 이동
//    @GetMapping("/login-success")
//    public String loginSuccessPage(){
//        return "index";
//    }

    //비밀번호 변경 페이지로 이동
    @GetMapping("/change-password")
    public String changePasswordPage(){
        return "auth/change-password";
    }

    //비밀번호 초기화
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/reset-password")
    public String resetPasswordPage(){
        return "auth/reset-password";
    }

    //접속기록관리
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/log-history")
    public String logHistoryPage(){
        return "log/log-history";
    }

    //로그 모니터링
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/log-monitor")
    public String logMonitorPage(){
        return "log/log-monitor";
    }

    //메인페이지
    @GetMapping("/index")
    public String indexPage(){
        return "index";
    }

}
