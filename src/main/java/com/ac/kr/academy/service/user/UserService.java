package com.ac.kr.academy.service.user;

import com.ac.kr.academy.domain.user.*;
import com.ac.kr.academy.mapper.admin.AdminMapper;
import com.ac.kr.academy.mapper.user.UserMapper;
import com.ac.kr.academy.mapper.user.advisor.AdvisorMapper;
import com.ac.kr.academy.mapper.user.professor.ProfessorMapper;
import com.ac.kr.academy.mapper.user.staff.StaffMapper;
import com.ac.kr.academy.mapper.user.student.StudentMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Year;
import java.util.*;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserMapper userMapper;
    private final StudentMapper studentMapper;
    private final ProfessorMapper professorMapper;
    private final StaffMapper staffMapper;
    private final AdvisorMapper advisorMapper;
    private final AdminMapper adminMapper;
    private final BCryptPasswordEncoder passwordEncoder;

    private final ObjectMapper objectMapper;

    //로그인 ID 자동생성 - 관리자 / 데이터 준비
//    @Transactional
    public Map<String, String> createUser(String role, Long deptId, String email, String name){
        //역할에 따라 순번 키와 최종 사용자 ID(username)을 생성 - AdminMapper
        String sequenceKey;
        String username;

        if ("ROLE_STUDENT".equals(role)) {
            String formatedDeptId = String.format("%02d", deptId);
            sequenceKey = Year.now().toString() + formatedDeptId;
            adminMapper.incrementSequence(sequenceKey);
            int sequence = adminMapper.findSequenceNum(sequenceKey);
            username = sequenceKey + String.format("%03d", sequence);
        } else {
            sequenceKey = role.replace("ROLE_", "");
            adminMapper.incrementSequence(sequenceKey);
            int sequence = adminMapper.findSequenceNum(sequenceKey);
            username = sequenceKey + String.format("%05d", sequence);
        }

        User user = new User();
        user.setEmail(email);
        user.setName(name);
        user.setRole(role);
        user.setUsername(username);

        //임시 비밀번호 생성 및 암호화
        String tempPassword = UUID.randomUUID().toString().substring(0, 8);
        user.setPassword(passwordEncoder.encode(tempPassword));
        user.setPasswordTemp(true);

        Object roleEntity = null;
        if("ROLE_STUDENT".equals(role)){
            Student student = new Student();
            student.setStudentNum(username);
            student.setDeptId(deptId);
            roleEntity = student;
        } else if ("ROLE_PROFESSOR".equals(role)) {
            Professor professor = new Professor();
            professor.setProfessorNum(username);
            roleEntity = professor;
        } else if ("ROLE_STAFF".equals(role)) {
            Staff staff = new Staff();
            staff.setStaffNum(username);
            roleEntity = staff;
        }
        saveUser(user, roleEntity);

        //로그인 ID와 임시 비밀번호 반환 -> Map 사용
        Map<String, String> userInfo = new HashMap<>();
        userInfo.put("username", username);
        userInfo.put("password", tempPassword);

        return userInfo;
    }

    //사용자 등록 / DB 저장
//    @Transactional
    public void saveUser(User user, Object roleEntity){
        //공통 계정(users 테이블) 등록
//        user.setPassword(passwordEncoder.encode(user.getPassword()));
//        user.setPasswordTemp(true);
        userMapper.insertUser(user);

        //역할에 따라 상세정보 각 테이블 등록
        if("ROLE_STUDENT".equals(user.getRole())){
            Student student = (Student) roleEntity;
            student.setUserId(user.getId());
            student.setStudentNum(user.getUsername());
            studentMapper.insertStudent(student);
        } else if ("ROLE_PROFESSOR".equals(user.getRole())) {
            Professor professor = (Professor) roleEntity;
            professor.setUserId(user.getId());
            professor.setProfessorNum(user.getUsername());
            professorMapper.insertProfessor(professor);
        } else if ("ROLE_STAFF".equals(user.getRole())) {
            Staff staff = (Staff) roleEntity;
            staff.setUserId(user.getId());
            staff.setStaffNum(user.getUsername());
            staffMapper.insertStaff(staff);
        }
    }

    //지도교수 등록(지정)
//    @Transactional
    public void setAdvisor(Long professorId, Long studentId){
        advisorMapper.insertAdvisor(professorId, studentId);
    }

    //사용자 수정
//    @Transactional
    public void updateUser(User user, Object roleEntity){
        userMapper.updateUser(user);

        //object 타입인 roleEntity를 ObjectMapper를 이용해 형변환
        if (roleEntity instanceof LinkedHashMap && !((LinkedHashMap)roleEntity).isEmpty()) {
            if ("ROLE_STUDENT".equals(user.getRole())) {
                Student student = objectMapper.convertValue(roleEntity, Student.class);
                if (student.getDeptId() != null || student.getEndedAt() != null || student.getStatus() != null) {
                    studentMapper.updateStudent(student);
                }
            } else if ("ROLE_PROFESSOR".equals(user.getRole())) {
                Professor professor = objectMapper.convertValue(roleEntity, Professor.class);
                if (professor.getDeptId() != null || professor.getEndedAt() != null) {
                    professorMapper.updateProfessor(professor);
                }
            } else if ("ROLE_STAFF".equals(user.getRole())) {
                Staff staff = objectMapper.convertValue(roleEntity, Staff.class);
                if (staff.getEndedAt() != null) {
                    staffMapper.updateStaff(staff);
                }
            }
        } else {    //object 타입일때
            if ("ROLE_STUDENT".equals(user.getRole())) {
                Student student = (Student) roleEntity;
                if (student.getDeptId() != null || student.getEndedAt() != null || student.getStatus() != null) {
                    studentMapper.updateStudent(student);
                }
            } else if ("ROLE_PROFESSOR".equals(user.getRole())) {
                Professor professor = (Professor) roleEntity;
                if (professor.getDeptId() != null || professor.getEndedAt() != null) {
                    professorMapper.updateProfessor(professor);
                }
            } else if ("ROLE_STAFF".equals(user.getRole())) {
                Staff staff = (Staff) roleEntity;
                if (staff.getEndedAt() != null) {
                    staffMapper.updateStaff(staff);
                }
            }
        }
    }

    //사용자 삭제 - 관리자
//    @Transactional
    public void deleteUser(Long userId){
        //user의 role 정보 가져오기
        User user = userMapper.findById(userId);

        if(user==null){
            throw new IllegalArgumentException("사용자를 찾을 수 없습니다.");
        }

        if("ROLE_STUDENT".equals(user.getRole())){
            studentMapper.deleteStudent(userId);
        } else if ("ROLE_PROFESSOR".equals(user.getRole())) {
            professorMapper.deleteProfessor(userId);
        } else if ("ROLE_STAFF".equals(user.getRole())) {
            staffMapper.deleteStaff(userId);
        }
        userMapper.deleteUser(userId);
    }

    //사용자 전체 조회
    public List<User> getAllUsers(){
        return userMapper.findAllUsers();
    }

    //권한별 사용자 조회
    public List<User> getUsersByRole(String role){
        return userMapper.findAllUsersByRole(role);
    }

    //사용자 ID, role로 상세 정보 조회 - 마이페이지
    public Object findByRole(Long userId, String role){
        if("ROLE_STUDENT".equals(role)){
            return studentMapper.findByUserId(userId);
        } else if ("ROLE_PROFESSOR".equals(role)) {
            return professorMapper.findByUserId(userId);
        } else if ("ROLE_STAFF".equals(role)) {
            return staffMapper.findByUserId(userId);
        }
        return null;
    }

    public User findByUsername(String username){
        return userMapper.findByUsername(username);
    }

    public User findById(Long id){
        return userMapper.findById(id);
    }

    //비밀번호 변경 - 사용자
//    @Transactional
    public void changePassword(String username, String currentPassword, String newPassword){
        User user = userMapper.findByUsername(username);
        if(user == null){
            throw new IllegalArgumentException("사용자를 찾을 수 없습니다.");
        }

        if(!passwordEncoder.matches(currentPassword, user.getPassword())){
            throw new IllegalArgumentException("입력하신 비밀번호가 일치하지 않습니다.");
        }

        String encodedNewPassword = passwordEncoder.encode(newPassword);
        userMapper.updateUserPassword(username, encodedNewPassword, false);
    }

    //비밀번호 초기화 - 관리자
//    @Transactional
    public String resetPassword(String username){
        User user = userMapper.findByUsername(username);
        if (user == null) {
            throw new IllegalArgumentException("사용자를 찾을 수 없습니다.");
        }
        String tempPassword = UUID.randomUUID().toString().substring(0, 8);
        userMapper.updateUserPassword(username, passwordEncoder.encode(tempPassword), true);
        return tempPassword;
    }

    //학생 상태값 변경 (재학중, 휴학중, 졸업)
//    @Transactional
    public void updateStudentStatus(Long userId, String status){
        studentMapper.updateStatusByUserId(userId, status);
    }
}
