package com.example.corevo.controller;

import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.domain.dto.request.TrainingPlanFlowRequestDto;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.PersonalInformationRequestDto;
import com.example.corevo.service.TrainingPlanFlowService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestApiV1
@RequiredArgsConstructor
@Validated
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class TrainingPlanFlowController {

    TrainingPlanFlowService trainingPlanFlowService;

    @Operation(
            summary = "Chọn thông tin mong muốn theo từng bước",
            description = "Dùng để người dùng chọn các mong muốn trong tập luyện",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.TrainingPlan.FLOW_STEP)
    public ResponseEntity<?> enterStep(@Valid @RequestBody TrainingPlanFlowRequestDto request) {
        return VsResponseUtil.success(trainingPlanFlowService.processStep(
                request.getCurrentStep(),
                request.getSelectedValue(),
                request.getSelectedValues()
        ));
    }
}
