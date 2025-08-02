import React, { useState, useEffect } from 'react';
import './AddUserModal.scss';

const AddUserModal = ({ onClose, onSubmit, editData, viewOnly = false }) => {
  const [personalInfo, setPersonalInfo] = useState({
    username: '',
    password: '',
    email: '',
    firstName: '',
    lastName: '',
    birth: '',
    phone: '',
    nationality: '',
    role: 'USER'
  });

  useEffect(() => {
    if (editData) {
      setPersonalInfo(editData.personalInfo || {});
    }
  }, [editData]);

  const validateForm = () => {
    if (!personalInfo.username) {
      alert("Tên đăng nhập không được bỏ trống.");
      return false;
    }
    if (!personalInfo.email) {
      alert("Email không được bỏ trống.");
      return false;
    }
    if (!personalInfo.password) {
      alert("Mật khẩu không được bỏ trống.");
      return false;
    }
    if (!personalInfo.role) {
      alert("Vui lòng chọn vai trò.");
      return false;
    }

    const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
    if (!emailPattern.test(personalInfo.email)) {
      alert("Email không hợp lệ.");
      return false;
    }

    const passwordPattern = /^(?=.*[0-9])(?=.*[a-z])(?=\S+$).{8,}$/;
    if (!passwordPattern.test(personalInfo.password)) {
      alert("Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ cái và số.");
      return false;
    }

    return true;
  };

  const handleConfirm = () => {
    if (!validateForm()) return;

    // ✅ Gửi đúng format cho backend
    onSubmit(personalInfo);
    onClose();
  };

  return (
    <div className="modal-overlay">
      <div className="modal-content">
        <h2>Thông tin cá nhân</h2>
        <form className="form-step">
          <input
            placeholder="Username"
            value={personalInfo.username}
            onChange={e => setPersonalInfo({ ...personalInfo, username: e.target.value })}
            disabled={viewOnly}
            required
          />
          <input
            type="password"
            placeholder="Password"
            value={personalInfo.password}
            onChange={e => setPersonalInfo({ ...personalInfo, password: e.target.value })}
            disabled={viewOnly}
            required
          />
          <input
            placeholder="Email"
            value={personalInfo.email}
            onChange={e => setPersonalInfo({ ...personalInfo, email: e.target.value })}
            disabled={viewOnly}
            required
          />
          <input
            placeholder="First name"
            value={personalInfo.firstName}
            onChange={e => setPersonalInfo({ ...personalInfo, firstName: e.target.value })}
            disabled={viewOnly}
          />
          <input
            placeholder="Last name"
            value={personalInfo.lastName}
            onChange={e => setPersonalInfo({ ...personalInfo, lastName: e.target.value })}
            disabled={viewOnly}
          />
          <input
            type="date"
            placeholder="Birth"
            value={personalInfo.birth}
            onChange={e => setPersonalInfo({ ...personalInfo, birth: e.target.value })}
            disabled={viewOnly}
          />
          <input
            placeholder="Phone"
            value={personalInfo.phone}
            onChange={e => setPersonalInfo({ ...personalInfo, phone: e.target.value })}
            disabled={viewOnly}
          />
          <p>Nationality</p>
          <input
            placeholder="Nationality"
            value={personalInfo.nationality}
            onChange={e => setPersonalInfo({ ...personalInfo, nationality: e.target.value })}
            disabled={viewOnly}
          />
          <select
            value={personalInfo.role}
            onChange={e => setPersonalInfo({ ...personalInfo, role: e.target.value })}
            disabled={viewOnly}
            required
          >
            <option value="USER">User</option>
            <option value="ADMIN">Admin</option>
          </select>
        </form>

        <div className="modal-buttons">
          <button onClick={onClose} className="cancel">Huỷ</button>
          {!viewOnly && (
            <button className="confirm" onClick={handleConfirm}>
              {editData ? 'Cập nhật' : 'Xác nhận'}
            </button>
          )}
        </div>
      </div>
    </div>
  );
};

export default AddUserModal;
