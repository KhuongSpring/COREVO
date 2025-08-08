import React, { useState, useEffect } from 'react';
import './AddUserModal.scss';

const ViewUserModal = ({ onClose, viewData }) => {
  const [step, setStep] = useState(1);
  const [personalInfo, setPersonalInfo] = useState({});
  const [healthInfo, setHealthInfo] = useState({});

  useEffect(() => {
    if (viewData) {
      setPersonalInfo(viewData?.personalInfo || {});
      setHealthInfo(viewData?.healthInfo || {});
    }
  }, [viewData]);

  const handleNext = () => setStep(2);
  const handleBack = () => setStep(1);

  return (
    <div className="modal-overlay">
      <div className="modal-content">
        <h2>{step === 1 ? 'Thông tin cá nhân' : 'Thông tin sức khỏe'}</h2>
        
        {step === 1 ? (
          <form className="form-step">
            <input placeholder="Username" value={personalInfo.username || ''} disabled />
            <input placeholder="Email" value={personalInfo.email || ''} disabled />
            <input placeholder="First name" value={personalInfo.firstName || ''} disabled />
            <input placeholder="Last name" value={personalInfo.lastName || ''} disabled />
            <input type="date" placeholder="Birth" value={personalInfo.birth || ''} disabled />
            <input placeholder="Phone" value={personalInfo.phone || ''} disabled />
            <input placeholder="Nationality" value={personalInfo.nationality || ''} disabled />
            
            {/* Đổi từ select sang input để tránh lỗi và đẹp hơn */}
            <input
              placeholder="Role"
              value={personalInfo.role === 'ADMIN' ? 'Admin' : 'User'}
              disabled
            />
          </form>
        ) : (
          <form className="form-step">
            <select value={personalInfo.gender || ''} disabled style={{ appearance: 'none', WebkitAppearance: 'none', MozAppearance: 'none' }}>
              <option value="MALE">Nam</option>
              <option value="FEMALE">Nữ</option>
              <option value="OTHER">Khác</option>
            </select>
            <input placeholder="Chiều cao (cm)" type="number" value={healthInfo.height || ''} disabled />
            <input placeholder="Cân nặng (kg)" type="number" value={healthInfo.weight || ''} disabled />
            <input placeholder="Tuổi" type="number" value={healthInfo.age || ''} disabled />
            <select value={healthInfo.activityLevel || ''} disabled style={{ appearance: 'none', WebkitAppearance: 'none', MozAppearance: 'none' }}>
              <option value="LOW">Thấp</option>
              <option value="MEDIUM">Trung bình</option>
              <option value="HIGH">Cao</option>
            </select>
          </form>
        )}

        <div className="modal-buttons">
          {step === 2 && <button onClick={handleBack}>Quay lại</button>}
          {step === 1 && <button onClick={handleNext}>Tiếp</button>}
          <button className="cancel" onClick={onClose}>Đóng</button>
        </div>
      </div>
    </div>
  );
};

export default ViewUserModal;
