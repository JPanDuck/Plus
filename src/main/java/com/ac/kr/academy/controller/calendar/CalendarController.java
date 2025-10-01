package com.ac.kr.academy.controller.calendar;


import com.ac.kr.academy.domain.calendar.Calendar;
import com.ac.kr.academy.service.calendar.CalendarService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/calendar")
public class CalendarController {

    private final CalendarService calendarService;

    @GetMapping({"","/list"})
    public String calendar(Model model) {
        List<Calendar> calendars = calendarService.findAll();
        model.addAttribute("calendars", calendars);
        return "calendar/list";
    }

    @GetMapping("/add")
    public String addForm() {
        return "calendar/add";
    }

    @PostMapping("/save")
    public String saveCalendar(@ModelAttribute Calendar calendar, RedirectAttributes redirectAttributes) {
        log.info("Request body: {}", calendar);
        calendarService.saveCalendar(calendar);
        redirectAttributes.addFlashAttribute("message", "일정이 성공적으로 저장되었습니다.");
        return "redirect:/calendar";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Long id, Model model) {
        Calendar calendar = calendarService.findById(id);
        model.addAttribute("calendar", calendar);
        return "calendar/edit";
    }

    @PostMapping("/update/{id}")
    public String updateCalendar(@ModelAttribute Calendar calendar, RedirectAttributes redirectAttributes) {
        log.info("Update request for calendar: {}", calendar);
        calendarService.saveCalendar(calendar);
        redirectAttributes.addFlashAttribute("message", "일정이 성공적으로 수정되었습니다.");
        return "redirect:/calendar/list";
    }

    @PostMapping("/delete/{id}")
    public String deleteCalendar(@PathVariable Long id) {
        calendarService.delete(id);
        return "redirect:/calendar/list";
    }
}
