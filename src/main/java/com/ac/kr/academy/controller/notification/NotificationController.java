package com.ac.kr.academy.controller.notification;

import com.ac.kr.academy.service.notification.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/notifications")
@RequiredArgsConstructor
public class NotificationController {
    private final NotificationService notificationService;

    //사용자 ID에 해당하는 알림 목록
    @GetMapping("/{targetId}")
    public String notificationList(@PathVariable Long targetId, Model model){
        model.addAttribute("notifications", notificationService.getNotificationList(targetId));
        return "notification/notificationList";
    }
}
