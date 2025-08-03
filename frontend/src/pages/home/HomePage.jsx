import React, { useState, useEffect } from 'react';
import axios from 'axios';
import {
  BarChart3, DollarSign, Users, TrendingUp, TrendingDown,
  Activity, Bell, Search, Settings, Menu, LogOut, User, ChevronDown
} from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import './HomePage.scss';

const HomePage = () => {
  const navigate = useNavigate();
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [userDropdownOpen, setUserDropdownOpen] = useState(false);
  const [currentUser, setCurrentUser] = useState(null);

  useEffect(() => {
    const token = localStorage.getItem('token');

    const fetchProfile = async () => {
      try {
        const res = await axios.get('http://localhost:8080/api/v1/user/profile', {
          headers: {
            Authorization: `Bearer ${token}`
          }
        });
        setCurrentUser(res.data.data);
      } catch (error) {
        console.error('Lỗi khi lấy thông tin người dùng:', error);
      }
    };

    fetchProfile(); // Chỉ gọi API này thay vì cả callAdminApi và callUserApi
  }, []);

  const handleLogout = () => {
    if (window.confirm('Are you sure you want to logout?')) {
      try {
        localStorage.removeItem('token');
        setUserDropdownOpen(false);
        navigate('/', { replace: true });
        window.location.reload();
      } catch (error) {
        console.error('Error during logout:', error);
        alert('An error occurred during logout. Please try again.');
      }
    }
  };

  const dashboardData = [
    {
      title: currentUser?.name,
      subtitle: "Today",
      value: "145",
      change: "+12%",
      isPositive: true,
      icon: BarChart3,
      color: "emerald"
    },
    {
      title: "Revenue",
      subtitle: "This Month",
      value: "$3,264",
      change: "+8%",
      isPositive: true,
      icon: DollarSign,
      color: "blue"
    },
    {
      title: "Customers",
      subtitle: "This Year",
      value: "1,244",
      change: "-12%",
      isPositive: false,
      icon: Users,
      color: "purple"
    }
  ];

  const activities = [
    { time: "32 min", text: "Quia quae rerum", highlight: "explicabo officiis" },
    { time: "2 hrs", text: "Voluptates corrupti molestias voluptatem", highlight: "" },
    { time: "1 day", text: "Tempore autem saepe", highlight: "occaecati voluptatem" }
  ];

  const pathname = window.location.pathname;

  const navigationItems = [
    { name: 'Dashboard', icon: BarChart3, path: '/home' },
    { name: 'Users', icon: User, path: '/users' }
  ];

  return (
    <div className="dashboard">
      {sidebarOpen && <div className="sidebar-overlay" onClick={() => setSidebarOpen(false)} />}
      {userDropdownOpen && <div className="dropdown-overlay" onClick={() => setUserDropdownOpen(false)} />}

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

      <div className="main-container">
        <main className="main">
          <header className="header">
            <div className="header__content">
              <div className="header__left">
                <button className="header__menu-btn" onClick={() => setSidebarOpen(true)}>
                  <Menu className="header__menu-icon" />
                </button>
                <h1 className="header__title">Dashboard</h1>
              </div>

              <div className="header__right">
                <div className="header__search">
                  <Search className="header__search-icon" />
                  <input
                    type="search"
                    placeholder="Search..."
                    className="header__search-input"
                  />
                </div>
                <button className="header__btn header__btn--notification">
                  <Bell className="header__btn-icon" />
                  <span className="header__notification-dot"></span>
                </button>
                <button className="header__btn">
                  <Settings className="header__btn-icon" />
                </button>

                <div className="user-dropdown">
                  <button
                    className="user-dropdown__trigger"
                    onClick={() => setUserDropdownOpen(!userDropdownOpen)}
                  >
                    {currentUser?.linkAvatar ? (
                      <img src={currentUser.linkAvatar} alt="avatar" className="user-dropdown__avatar" />
                    ) : (
                      <div className="user-dropdown__avatar">
                        {currentUser?.firstName?.charAt(0) || 'A'}
                      </div>
                    )}
                    <div className="user-dropdown__info">
                      <span className="user-dropdown__name">{currentUser?.firstName} {currentUser?.lastName}</span>
                      <span className="user-dropdown__role">{currentUser?.role}</span>
                    </div>
                    <ChevronDown className={`user-dropdown__chevron ${userDropdownOpen ? 'user-dropdown__chevron--open' : ''}`} />
                  </button>

                  {userDropdownOpen && (
                    <div className="user-dropdown__menu">
                      <div className="user-dropdown__header">
                        {currentUser?.linkAvatar ? (
                          <img src={currentUser.linkAvatar} alt="avatar" className="user-dropdown__avatar user-dropdown__avatar--large" />
                        ) : (
                          <div className="user-dropdown__avatar user-dropdown__avatar--large">
                            {currentUser?.firstName?.charAt(0) || 'A'}
                          </div>
                        )}
                        <div className="user-dropdown__details">
                          <p className="user-dropdown__name">{currentUser?.firstName} {currentUser?.lastName}</p>
                          <p className="user-dropdown__email">{currentUser?.email}</p>
                        </div>
                      </div>

                      <div className="user-dropdown__divider"></div>

                      <div className="user-dropdown__items">
                        <a href="#" className="user-dropdown__item">
                          <User className="user-dropdown__item-icon" />
                          <span>Profile Settings</span>
                        </a>
                        <a href="#" className="user-dropdown__item">
                          <Settings className="user-dropdown__item-icon" />
                          <span>Account Settings</span>
                        </a>
                      </div>

                      <div className="user-dropdown__divider"></div>

                      <button
                        className="user-dropdown__item user-dropdown__item--logout"
                        onClick={handleLogout}
                      >
                        <LogOut className="user-dropdown__item-icon" />
                        <span>Logout</span>
                      </button>
                    </div>
                  )}
                </div>
              </div>
            </div>
          </header>

          <div className="content">
            <div className="stats">
              {dashboardData.map((item, index) => (
                <div key={index} className={`card card--${item.color}`}>
                  <div className="card__content">
                    <div className="card__header">
                      <div className={`card__icon card__icon--${item.color}`}>
                        <item.icon className="card__icon-svg" />
                      </div>
                      <div className={`card__change ${item.isPositive ? 'card__change--positive' : 'card__change--negative'}`}>
                        {item.isPositive ? <TrendingUp className="card__change-icon" /> : <TrendingDown className="card__change-icon" />}
                        {item.change}
                      </div>
                    </div>
                    <div className="card__body">
                      <h3 className="card__subtitle">{item.title} | {item.subtitle}</h3>
                      <p className="card__value">{item.value}</p>
                    </div>
                  </div>
                  <div className={`card__accent card__accent--${item.color}`}></div>
                </div>
              ))}
            </div>

            <div className="activity">
              <div className="activity__header">
                <div className="activity__title-wrapper">
                  <Activity className="activity__title-icon" />
                  <h2 className="activity__title">Recent Activity</h2>
                  <span className="activity__subtitle">Today</span>
                </div>
              </div>

              <div className="activity__content">
                <div className="activity__list">
                  {activities.map((activity, index) => (
                    <div key={index} className="activity__item">
                      <div className="activity__dot"></div>
                      <div className="activity__details">
                        <div className="activity__time-wrapper">
                          <span className="activity__time">{activity.time}</span>
                        </div>
                        <p className="activity__text">
                          {activity.text}{' '}
                          {activity.highlight && (
                            <span className="activity__highlight">{activity.highlight}</span>
                          )}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>

                <div className="activity__footer">
                  <button className="activity__view-all">View All Activities</button>
                </div>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
};
  
export default HomePage;
