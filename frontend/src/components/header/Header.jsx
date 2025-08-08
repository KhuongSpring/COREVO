import React from 'react';
import { Menu, ChevronDown, LogOut } from 'lucide-react';

const Header = ({
  currentUser,
  sidebarOpen,
  setSidebarOpen,
  userDropdownOpen,
  setUserDropdownOpen,
  handleLogout,
  pageTitle
}) => {
  return (
    <header className="header">
      <div className="header__content">
        {/* Bên trái */}
        <div className="header__left">
          <button className="header__menu-btn" onClick={() => setSidebarOpen(true)}>
            <Menu className="header__menu-icon" />
          </button>
          <h1 className="header__title">{pageTitle}</h1>
        </div>

        {/* Bên phải */}
        <div className="header__right">
          {/* User dropdown */}
          <div className="user-dropdown">
            <button
              className="user-dropdown__trigger"
              onClick={() => setUserDropdownOpen(!userDropdownOpen)}
            >
              {currentUser?.linkAvatar ? (
                <img
                  src={currentUser.linkAvatar}
                  alt="avatar"
                  className="user-dropdown__avatar"
                />
              ) : (
                <div className="user-dropdown__avatar">
                  {currentUser?.firstName?.charAt(0) || 'A'}
                </div>
              )}
              <div className="user-dropdown__info">
                <span className="user-dropdown__name">
                  {currentUser?.firstName} {currentUser?.lastName}
                </span>
                <span className="user-dropdown__role">{currentUser?.role}</span>
              </div>
              <ChevronDown
                className={`user-dropdown__chevron ${
                  userDropdownOpen ? 'user-dropdown__chevron--open' : ''
                }`}
              />
            </button>

            {userDropdownOpen && (
              <div className="user-dropdown__menu">
                {/* Thông tin user */}
                <div className="user-dropdown__header">
                  {currentUser?.linkAvatar ? (
                    <img
                      src={currentUser.linkAvatar}
                      alt="avatar"
                      className="user-dropdown__avatar user-dropdown__avatar--large"
                    />
                  ) : (
                    <div className="user-dropdown__avatar user-dropdown__avatar--large">
                      {currentUser?.firstName?.charAt(0) || 'A'}
                    </div>
                  )}
                  <div className="user-dropdown__details">
                    <p className="user-dropdown__name">
                      {currentUser?.firstName} {currentUser?.lastName}
                    </p>
                    <p className="user-dropdown__email">{currentUser?.email}</p>
                  </div>
                </div>

                <div className="user-dropdown__divider"></div>

                {/* Nút logout */}
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
  );
};

export default Header;
