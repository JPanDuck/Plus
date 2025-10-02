package com.ac.kr.academy.controller.auth;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminPageController {

    /** 계정 생성 페이지 */
    @GetMapping("/auth/user-create")
    public String createAccountPage() {
        // /WEB-INF/views/admin/user/user-create.jsp
        return "admin/user/user-create";
    }

    /** 사용자 목록 페이지 */
    @GetMapping("/auth/user-list")
    public String userListPage() {
        // /WEB-INF/views/admin/user/user-list.jsp
        return "admin/user/user-list";
    }

    /** 사용자 상세 페이지 */
    @GetMapping("/auth/user-detail")
    public String userDetailPage() {
        // /WEB-INF/views/admin/user/user-detail.jsp
        return "admin/user/user-detail";
    }
}
