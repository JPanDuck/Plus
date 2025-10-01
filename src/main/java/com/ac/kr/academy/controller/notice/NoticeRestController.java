package com.ac.kr.academy.controller.notice;

import com.ac.kr.academy.domain.notice.Notice;
import com.ac.kr.academy.service.notice.NoticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/notices")
public class NoticeRestController {
    private final NoticeService noticeService;

    //전체 조회
    @GetMapping
    public ResponseEntity<?> getNoticeList(){
        List<Notice> notices = noticeService.getNoticeList();
        return ResponseEntity.ok(notices);
    }

    //상세 조회
    @GetMapping("/{id}")
    public ResponseEntity<Notice> getNotice(@PathVariable Long id){
        Notice notice = noticeService.getNoticeDetail(id);
        if(notice == null){
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(notice);
    }

    //생성
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/add")
    public ResponseEntity<?> addNotice(@RequestBody Notice notice){
        noticeService.createNotice(notice);
        return ResponseEntity.status(201).body(notice);
    }

    //수정
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ResponseEntity<?> editNotice(@PathVariable Long id, @RequestBody Notice notice){
        notice.setId(id);
        Notice updated = noticeService.editNotice(notice);
        if(updated == null){
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(updated);
    }

    //삭제
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<?> removeNotice(@PathVariable Long id){
        boolean deleted = noticeService.removeNotice(id);
        if(!deleted){
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.noContent().build();
    }
}
