package com.example.corevo.helper;

import com.example.corevo.domain.dto.request.user.enter_personal_infomation.UpdatePersonalInformationRequestDto;

import org.springframework.stereotype.Component;

@Component
public class PersonalInformationHelper {

    public UpdatePersonalInformationRequestDto handleEmptyStrings(
            UpdatePersonalInformationRequestDto personalInformation) {
        if (personalInformation == null) {
            return null;
        }

        if (personalInformation.getFirstName() != null && personalInformation.getFirstName().trim().isEmpty()) {
            personalInformation.setFirstName(null);
        }

        if (personalInformation.getLastName() != null && personalInformation.getLastName().trim().isEmpty()) {
            personalInformation.setLastName(null);
        }

        if (personalInformation.getPhone() != null && personalInformation.getPhone().trim().isEmpty()) {
            personalInformation.setPhone(null);
        }

        if (personalInformation.getNationality() != null && personalInformation.getNationality().trim().isEmpty()) {
            personalInformation.setNationality(null);
        }

        if (personalInformation.getAddress() != null) {
            if (personalInformation.getAddress().getProvince() != null &&
                    personalInformation.getAddress().getProvince().trim().isEmpty()) {
                personalInformation.getAddress().setProvince(null);
            }

            if (personalInformation.getAddress().getDistrict() != null &&
                    personalInformation.getAddress().getDistrict().trim().isEmpty()) {
                personalInformation.getAddress().setDistrict(null);
            }

            if (personalInformation.getAddress().getProvince() == null &&
                    personalInformation.getAddress().getDistrict() == null) {
                personalInformation.setAddress(null);
            }
        }

        return personalInformation;
    }

}
