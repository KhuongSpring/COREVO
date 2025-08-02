import React, { useContext } from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import LoginPage from "./pages/Auth/LoginPage";
import HomePage from "./pages/home/HomePage";
import UserManagement from "./pages/home/UserPage";
import { AuthContext } from "./context/AuthContext"; // Đã sửa lại cho đúng với .jsx

const App = () => {
  const { isLoggedIn } = useContext(AuthContext);

  return (
    <BrowserRouter>
      <Routes>
        <Route
          path="/"
          element={
            isLoggedIn ? <Navigate to="/home" replace /> : <LoginPage />
          }
        />
        <Route
          path="/home"
          element={
            isLoggedIn ? <HomePage /> : <Navigate to="/" replace />
          }
        />
        <Route
          path="/users"
          element={
            isLoggedIn ? <UserManagement /> : <Navigate to="/" replace />
          }
        />
      </Routes>
    </BrowserRouter>
  );
};

export default App;
