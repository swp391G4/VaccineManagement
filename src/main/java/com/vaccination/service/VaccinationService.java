package com.vaccination.service;

import com.vaccination.dao.*;
import com.vaccination.model.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class VaccinationService {
    private final VaccinationScheduleTemplateDAO scheduleTemplateDAO;
    private final AppointmentDAO appointmentDAO;
    private final CenterDAO centerDAO;
    
    public VaccinationService() {
        this.scheduleTemplateDAO = new VaccinationScheduleTemplateDAO();
        this.appointmentDAO = new AppointmentDAO();
        this.centerDAO = new CenterDAO();
    }
    
    /**
     * Tự động tạo appointments cho TẤT CẢ vaccine MIỄN PHÍ phù hợp với độ tuổi của bé
     * Được gọi khi:
     * 1. Thêm bé mới vào hệ thống
     * 2. Cập nhật thông tin bé (nếu cần)
     * 
     * @param child Child object với thông tin ngày sinh
     * @return số lượng appointments được tạo
     */
    public int autoScheduleFreeVaccines(Child child) {
        if (child == null || child.getDateOfBirth() == null) {
            return 0;
        }
        
        // Lấy tất cả vaccine ĐÚNG tuổi hiện tại (exact match)
        List<VaccinationScheduleTemplate> currentAgeTemplates = 
            scheduleTemplateDAO.findMandatoryByAge(child.getAgeInMonths());
        
        if (currentAgeTemplates.isEmpty()) {
            return 0;
        }
        
        // Lấy center mặc định (center đầu tiên active) để gán appointment
        Center defaultCenter = getDefaultCenter();
        if (defaultCenter == null) {
            System.err.println("No active center found to create appointments");
            return 0;
        }
        
        int createdCount = 0;
        LocalDate childDOB = child.getDateOfBirth();
        int timeOffset = 0;
        
        for (VaccinationScheduleTemplate template : currentAgeTemplates) {
            // Chỉ tạo appointment cho vaccine MIỄN PHÍ (IsFree = true)
            if (template.getVaccine() != null && template.getVaccine().isFree()) {
                
                // Kiểm tra xem đã có appointment cho vaccine này chưa
                boolean alreadyScheduled = appointmentDAO.findByChildId(child.getChildId())
                    .stream()
                    .anyMatch(apt -> apt.getVaccineId() == template.getVaccineId());
                
                if (!alreadyScheduled) {
                    // Tính toán ngày tiêm dựa trên DOB + AgeInMonths
                    LocalDate vaccinationDate = childDOB.plusMonths(template.getAgeInMonths());
                    
                    // Nếu ngày tiêm đã qua, đặt vào ngày mai
                    if (vaccinationDate.isBefore(LocalDate.now())) {
                        vaccinationDate = LocalDate.now().plusDays(1);
                    }
                    
                    // Tạo appointment với thời gian staggered (mỗi vaccine cách nhau 30 phút)
                    java.time.LocalTime appointmentTime = java.time.LocalTime.of(9, 0).plusMinutes(timeOffset * 30);
                    
                    Appointment appointment = new Appointment();
                    appointment.setChildId(child.getChildId());
                    appointment.setVaccineId(template.getVaccineId());
                    appointment.setCenterId(defaultCenter.getCenterId());
                    appointment.setAppointmentDate(vaccinationDate);
                    appointment.setAppointmentTime(appointmentTime);
                    appointment.setStatus("PENDING");
                    appointment.setNotes("Tự động tạo lịch tiêm cho vaccine miễn phí: " + 
                                       template.getVaccine().getVaccineName());
                    
                    if (appointmentDAO.createAppointment(appointment)) {
                        createdCount++;
                        timeOffset++;
                    }
                }
            }
        }
        
        return createdCount;
    }
    
    /**
     * Lấy center mặc định để tạo appointment tự động
     * Ưu tiên: Center active đầu tiên trong danh sách
     */
    private Center getDefaultCenter() {
        List<Center> centers = centerDAO.getAllCenters();
        return centers.isEmpty() ? null : centers.get(0);
    }
    
    /**
     * Kiểm tra xem child có appointment nào đang pending không
     */
    public boolean hasPendingFreeVaccineAppointments(int childId) {
        return appointmentDAO.findByChildId(childId)
            .stream()
            .anyMatch(apt -> "PENDING".equals(apt.getStatus()));
    }
}
