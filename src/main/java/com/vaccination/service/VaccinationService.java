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
     * Tự động tạo appointments cho TẤT CẢ vaccine MIỄN PHÍ theo lịch TCMR
     * Tạo TẤT CẢ appointments theo lịch tiêm (không phụ thuộc tuổi hiện tại)
     * Được gọi khi: Thêm bé mới vào hệ thống
     * 
     * @param child Child object với thông tin ngày sinh
     * @return số lượng appointments được tạo
     */
    public int autoScheduleFreeVaccines(Child child) {
        if (child == null || child.getDateOfBirth() == null) {
            return 0;
        }
        
        // Lấy TẤT CẢ vaccine MIỄN PHÍ từ lịch TCMR (từ 0 tháng trở đi)
        List<VaccinationScheduleTemplate> allFreeTemplates = 
            scheduleTemplateDAO.findRecommendedForAge(0);
        
        if (allFreeTemplates.isEmpty()) {
            return 0;
        }
        
        // Lọc chỉ lấy vaccine MIỄN PHÍ
        List<VaccinationScheduleTemplate> freeTemplates = allFreeTemplates.stream()
            .filter(t -> t.getVaccine() != null && t.getVaccine().isFree())
            .collect(java.util.stream.Collectors.toList());
        
        if (freeTemplates.isEmpty()) {
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
        
        // Đảm bảo appointments cách ít nhất 2 ngày từ ngày hiện tại
        // (Không tiêm ngay trong ngày thêm trẻ, cần thời gian chuẩn bị)
        LocalDate earliestAllowedDate = LocalDate.now().plusDays(2);
        
        // Group templates by date để xử lý staggered times cho vaccines cùng ngày
        java.util.Map<LocalDate, java.util.List<VaccinationScheduleTemplate>> templatesByDate = 
            new java.util.LinkedHashMap<>();
        
        for (VaccinationScheduleTemplate template : freeTemplates) {
            // Kiểm tra xem đã có appointment cho vaccine này chưa
            boolean alreadyScheduled = appointmentDAO.findByChildId(child.getChildId())
                .stream()
                .anyMatch(apt -> apt.getVaccineId() == template.getVaccineId());
            
            if (!alreadyScheduled) {
                // Tính toán ngày tiêm dựa trên DOB + AgeInMonths
                // AgeInMonths có thể là decimal (0.5, 12.5...)
                int months = (int) template.getAgeInMonths();
                int days = (int) ((template.getAgeInMonths() - months) * 30);
                LocalDate vaccinationDate = childDOB.plusMonths(months).plusDays(days);
                
                // ĐẢM BẢO ngày tiêm cách ít nhất 2 ngày từ hôm nay
                if (vaccinationDate.isBefore(earliestAllowedDate)) {
                    vaccinationDate = earliestAllowedDate;
                }
                
                // Group by date
                templatesByDate.computeIfAbsent(vaccinationDate, k -> new java.util.ArrayList<>())
                    .add(template);
            }
        }
        
        // Tạo appointments với staggered times cho vaccines cùng ngày
        // ĐẢM BẢO không trùng giờ với appointments của trẻ khác
        for (java.util.Map.Entry<LocalDate, java.util.List<VaccinationScheduleTemplate>> entry : templatesByDate.entrySet()) {
            LocalDate date = entry.getKey();
            java.util.List<VaccinationScheduleTemplate> templatesOnDate = entry.getValue();
            
            // Lấy danh sách appointments đã tồn tại trong ngày này tại center
            List<Appointment> existingAppointments = appointmentDAO.findByCenterAndDate(defaultCenter.getCenterId(), date);
            java.util.Set<java.time.LocalTime> occupiedTimes = existingAppointments.stream()
                .map(Appointment::getAppointmentTime)
                .collect(java.util.stream.Collectors.toSet());
            
            for (VaccinationScheduleTemplate template : templatesOnDate) {
                // Tìm slot trống đầu tiên, bắt đầu từ 9h00
                java.time.LocalTime appointmentTime = java.time.LocalTime.of(9, 0);
                while (occupiedTimes.contains(appointmentTime)) {
                    appointmentTime = appointmentTime.plusMinutes(30);
                }
                
                Appointment appointment = new Appointment();
                appointment.setChildId(child.getChildId());
                appointment.setVaccineId(template.getVaccineId());
                appointment.setCenterId(defaultCenter.getCenterId());
                appointment.setAppointmentDate(date);
                appointment.setAppointmentTime(appointmentTime);
                appointment.setStatus("PENDING");
                appointment.setNotes("Tu dong tao lich tiem TCMR: " + 
                                   template.getVaccine().getVaccineName());
                
                if (appointmentDAO.createAppointment(appointment)) {
                    createdCount++;
                    // Đánh dấu time này đã bị chiếm để vaccine tiếp theo không trùng
                    occupiedTimes.add(appointmentTime);
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
