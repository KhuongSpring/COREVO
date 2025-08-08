import React from 'react';
import { BarChart3 } from 'lucide-react';
import { useLocation, useNavigate } from 'react-router-dom';
import './Sideb.scss'; // Hoặc đổi thành SCSS riêng nếu bạn tách

const Sidebar = ({ sidebarOpen, setSidebarOpen, navigationItems }) => {
  const navigate = useNavigate();
  const location = useLocation();
  const pathname = location.pathname;

  return (
    <>
      {sidebarOpen && <div className="sidebar-overlay" onClick={() => setSidebarOpen(false)} />}

      <div className="sidebar-container">
        <aside className={`sidebar ${sidebarOpen ? 'sidebar--open' : ''}`}>
          <div className="sidebar__header">
            <h2 className="sidebar__title">
              <div className="sidebar__logo">
                <BarChart3 className="sidebar__logo-icon" />
              </div>
              Dashboard
            </h2>
          </div>

          <nav className="sidebar__nav">
            <ul className="sidebar__list">
              {navigationItems.map((item, index) => {
                const isActive = pathname === item.path;
                return (
                  <li key={index} className="sidebar__item">
                    <button
                      onClick={() => navigate(item.path)}
                      className={`sidebar__link ${isActive ? 'sidebar__link--active' : ''}`}
                    >
                      <item.icon className="sidebar__link-icon" />
                      <span className="sidebar__link-text">{item.name}</span>
                    </button>
                  </li>
                );
              })}
            </ul>
          </nav>
        </aside>
      </div>
    </>
  );
};

export default Sidebar;
