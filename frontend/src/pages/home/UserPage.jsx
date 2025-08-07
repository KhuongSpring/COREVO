import React, { useState, useEffect, useContext } from 'react';
import { BarChart3, User, Dumbbell, Plus, Edit3, Trash2, Eye, Lock, Unlock, Search } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import './UserPage.scss';
import { AuthContext } from '../../context/AuthContext';
import AddUserModal from '../../components/user/AddUserModal';
import UpdateUserModal from '../../components/user/UpdateUserModal';
import ViewUserModal from '../../components/user/ViewUserModal';
import Sidebar from '../../components/sidebar/Sideb';
import Header from '../../components/header/Header';

const UserPage = () => {
  const navigate = useNavigate();
  const { profile, logout, api } = useContext(AuthContext);
  
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [userDropdownOpen, setUserDropdownOpen] = useState(false);
  const [users, setUsers] = useState([]);
  const [showAddModal, setShowAddModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [editUser, setEditUser] = useState(null);
  const [showViewModal, setShowViewModal] = useState(false);
  const [viewUser, setViewUser] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const pageSize = 10;
  const [totalPages, setTotalPages] = useState(1);
  const [searchQuery, setSearchQuery] = useState('');
  const [goToPage, setGoToPage] = useState(''); // <== THÊM MỚI

  const fetchUsers = async () => {
    try {
      const res = await api.get('admin/users', {
        params: { pageNum: currentPage, pageSize }
      });
      const responseData = res.data?.data;
      const totalElement = responseData?.meta?.totalElement || 0;
      
      setUsers(Array.isArray(responseData?.items) ? responseData.items : []);
      setTotalPages(Math.max(1, Math.ceil(totalElement / pageSize)));
    } catch (err) {
      console.error('Lỗi khi lấy danh sách user:', err);
    }
  };

  const searchUsers = async () => {
    if (!searchQuery.trim()) {
      fetchUsers();
      return;
    }

    try {
      let res;
      if (searchQuery.includes('@')) {
        res = await api.post('admin/search-user-by-email',
          { searchSentence: searchQuery },
          { params: { pageNum: currentPage, pageSize } }
        );
      } else if (/^\d+$/.test(searchQuery)) {
        res = await api.post('admin/search-user-by-phone',
          { searchSentence: searchQuery },
          { params: { pageNum: currentPage, pageSize } }
        );
      } else {
        res = await api.post('admin/search-user-by-username',
          { searchSentence: searchQuery },
          { params: { pageNum: currentPage, pageSize } }
        );
      }

      const responseData = res.data?.data;
      const totalElement = responseData?.meta?.totalElement || 0;
      setUsers(Array.isArray(responseData?.items) ? responseData.items : []);
      setTotalPages(Math.max(1, Math.ceil(totalElement / pageSize)));

    } catch (err) {
      console.error('Lỗi khi tìm kiếm user:', err);
    }
  };

  const handleViewUser = async (userId) => {
    try {
      const res = await api.get(`admin/users/${userId}`);
      const user = res.data?.data;
      if (user) {
        setViewUser({ personalInfo: user, healthInfo: user.userHealth || {} });
        setShowViewModal(true);
      } else {
        alert('Không tìm thấy thông tin người dùng');
      }
    } catch (err) {
      console.error('Lỗi khi lấy thông tin user:', err);
      alert('Không thể xem thông tin người dùng');
    }
  };

  const handleAddUser = async (data) => {
    try {
      await api.post('admin/create-user', data);
      alert('Tạo user thành công');
      fetchUsers();
    } catch (err) {
      console.error('Lỗi khi thêm user:', err);
      alert('Thêm user thất bại');
    }
    setShowAddModal(false);
  };

  const handleUpdateUser = async (updatedData) => {
    try {
      await api.put(`admin/update-user/${updatedData.id}`, updatedData);
      alert('Cập nhật thành công');
      fetchUsers();
    } catch (err) {
      console.error('Lỗi khi cập nhật user:', err);
      alert('Cập nhật thất bại');
    }
    setShowEditModal(false);
  };

  const handleLockUser = async (userId) => {
    try {
      await api.put(`admin/lock-user/${userId}`);
      alert('Khóa tài khoản thành công');
      setUsers(prevUsers =>
        prevUsers.map(user =>
          user.id === userId ? { ...user, locked: true } : user
        )
      );
    } catch (err) {
      console.error('Lỗi khi khóa user:', err);
      alert('Khóa tài khoản thất bại');
    }
  };

  const handleUnlockUser = async (userId) => {
    try {
      await api.put(`admin/unlock-user/${userId}`);
      alert('Mở khóa tài khoản thành công');
      fetchUsers();
    } catch (err) {
      console.error('Lỗi khi mở khóa user:', err);
      alert('Mở khóa tài khoản thất bại');
    }
  };

  const handleDeleteUser = async (userId) => {
    if (!window.confirm('Bạn có chắc chắn muốn xóa người dùng này?')) return;
    try {
      await api.delete(`admin/delete-user/${userId}`);
      alert('Xóa user thành công');
      fetchUsers();
    } catch (err) {
      console.error('Lỗi khi xóa user:', err);
      alert('Xóa user thất bại');
    }
  };

  useEffect(() => {
    if (searchQuery.trim()) {
      searchUsers();
    } else {
      fetchUsers();
    }
  }, [currentPage]);

  const handleLogout = () => {
    if (window.confirm('Are you sure you want to logout?')) {
      logout();
      navigate('/', { replace: true });
    }
  };

  const navigationItems = [
    { name: 'Dashboard', icon: BarChart3, path: '/home' },
    { name: 'Users', icon: User, path: '/users' },
    { name: 'Exercise', icon: Dumbbell, path: '/exercise' }
  ];

  if (!profile) return <div className="loading">Đang tải thông tin người dùng...</div>;

  return (
    <div className="dashboard">
      <Sidebar
        sidebarOpen={sidebarOpen}
        setSidebarOpen={setSidebarOpen}
        navigationItems={navigationItems}
      />

      {userDropdownOpen && <div className="dropdown-overlay" onClick={() => setUserDropdownOpen(false)} />}

      {showAddModal && <AddUserModal onClose={() => setShowAddModal(false)} onSubmit={handleAddUser} />}
      {showEditModal && <UpdateUserModal onClose={() => setShowEditModal(false)} onSubmit={handleUpdateUser} editData={editUser} />}
      {showViewModal && <ViewUserModal onClose={() => setShowViewModal(false)} viewData={viewUser} />}

      <div className="main-container">
        <main className="main">
          <Header
            currentUser={profile}
            sidebarOpen={sidebarOpen}
            setSidebarOpen={setSidebarOpen}
            userDropdownOpen={userDropdownOpen}
            setUserDropdownOpen={setUserDropdownOpen}
            handleLogout={handleLogout}
            pageTitle="User Management"
          />

          <div className="content">
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 16 }}>
              <button 
                className="add-user-button" 
                onClick={() => setShowAddModal(true)}
                style={{
                  height: 40,
                  display: 'flex',
                  alignItems: 'center',
                  gap: 6
                }}
              >
                <Plus size={16} /> Add User
              </button>

              <div style={{ display: 'flex', gap: 8 }}>
                <input
                  type="text"
                  placeholder="Search by name, email, phone..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  style={{
                    padding: '6px 10px',
                    borderRadius: 6,
                    border: '1px solid #ccc',
                    minWidth: 300,
                    height: 40
                  }}
                />
                <button
                  onClick={() => {
                    setCurrentPage(1);
                    searchUsers();
                  }}
                  style={{
                    background: '#1e3a8a',
                    color: '#fff',
                    padding: '0 16px',
                    border: 'none',
                    borderRadius: 6,
                    display: 'flex',
                    alignItems: 'center',
                    gap: 4,
                    cursor: 'pointer',
                    height: 40
                  }}
                >
                  <Search size={16} /> Search
                </button>
              </div>
            </div>

            <table className="user-table">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Username</th>
                  <th>Email</th>
                  <th>Phone</th>
                  <th>Nationality</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {users.map(u => (
                  <tr key={u.id}>
                    <td>{u.firstName} {u.lastName}</td>
                    <td>{u.username}</td>
                    <td>{u.email}</td>
                    <td>{u.phone}</td>
                    <td>{u.nationality}</td>
                    <td>
                      <button className="edit" onClick={() => {
                        setEditUser({ personalInfo: u, healthInfo: u.health || {} });
                        setShowEditModal(true);
                      }}><Edit3 size={16} /></button>

                      <button className="delete" onClick={() => handleDeleteUser(u.id)}>
                        <Trash2 size={16} />
                      </button>

                      <button className="view" onClick={() => handleViewUser(u.id)}>
                        <Eye size={16} />
                      </button>

                      <button
                        className={`lock ${u.locked ? 'locked' : ''}`}
                        onClick={() => handleLockUser(u.id)}
                      >
                        <Lock size={16} />
                      </button>

                      <button className="unlock" onClick={() => handleUnlockUser(u.id)}>
                        <Unlock size={16} />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>

            <div className="pagination">
              <button onClick={() => setCurrentPage(p => Math.max(p - 1, 1))} disabled={currentPage === 1}>
                Previous
              </button>
              <span>Page {currentPage} of {totalPages}</span>
              <input
                type="number"
                value={goToPage}
                min={1}
                max={totalPages}
                onChange={(e) => setGoToPage(e.target.value)}
                style={{ width: 60, textAlign: 'center', marginLeft: 8 }}
              />
              <button
                onClick={() => {
                  const pageNum = parseInt(goToPage);
                  if (!isNaN(pageNum) && pageNum >= 1 && pageNum <= totalPages) {
                    setCurrentPage(pageNum);
                  } else {
                    alert(`Vui lòng nhập số trang từ 1 đến ${totalPages}`);
                  }
                }}
              >
                Go
              </button>
              <button onClick={() => setCurrentPage(p => Math.min(p + 1, totalPages))} disabled={currentPage >= totalPages}>
                Next
              </button>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
};

export default UserPage;
