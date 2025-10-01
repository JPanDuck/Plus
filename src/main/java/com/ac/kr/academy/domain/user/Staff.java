package com.ac.kr.academy.domain.user;

import lombok.Data;

import java.time.LocalDate;

@Data
public class Staff {
    private Long id;
    private String staffNum;
    private LocalDate createAt;
    private LocalDate endedAt;
    private Long userId;
}
