package com.vaccination.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Vaccine {
    private int vaccineId;
    private String vaccineName;
    private String manufacturer;
    private String description;
    private String diseasesPrevented;
    private String dosageSchedule;
    private String recommendedAge;
    private BigDecimal price;
    private boolean isActive;
    private String sideEffects;
    private String contraindications;
    private LocalDateTime createdAt;

    public Vaccine() {
    }

    public Vaccine(int vaccineId, String vaccineName, String manufacturer, BigDecimal price) {
        this.vaccineId = vaccineId;
        this.vaccineName = vaccineName;
        this.manufacturer = manufacturer;
        this.price = price;
        this.isActive = true;
    }

    public int getVaccineId() {
        return vaccineId;
    }

    public void setVaccineId(int vaccineId) {
        this.vaccineId = vaccineId;
    }

    public String getVaccineName() {
        return vaccineName;
    }

    public void setVaccineName(String vaccineName) {
        this.vaccineName = vaccineName;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDiseasesPrevented() {
        return diseasesPrevented;
    }

    public void setDiseasesPrevented(String diseasesPrevented) {
        this.diseasesPrevented = diseasesPrevented;
    }

    public String getDosageSchedule() {
        return dosageSchedule;
    }

    public void setDosageSchedule(String dosageSchedule) {
        this.dosageSchedule = dosageSchedule;
    }

    public String getRecommendedAge() {
        return recommendedAge;
    }

    public void setRecommendedAge(String recommendedAge) {
        this.recommendedAge = recommendedAge;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public String getSideEffects() {
        return sideEffects;
    }

    public void setSideEffects(String sideEffects) {
        this.sideEffects = sideEffects;
    }

    public String getContraindications() {
        return contraindications;
    }

    public void setContraindications(String contraindications) {
        this.contraindications = contraindications;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Vaccine{" +
                "vaccineId=" + vaccineId +
                ", vaccineName='" + vaccineName + '\'' +
                ", manufacturer='" + manufacturer + '\'' +
                ", price=" + price +
                '}';
    }
}
