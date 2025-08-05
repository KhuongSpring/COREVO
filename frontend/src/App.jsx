import React, { useContext } from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import LoginPage from "./pages/Auth/LoginPage";
import HomePage from "./pages/home/HomePage";
import UserManagement from "./pages/home/UserPage";
import ExercisePage from "./pages/exercise/ExercisePage";
import { AuthContext } from "./context/AuthContext";

const App = () => {
  const { isLoggedIn } = useContext(AuthContext);
  console.log('isLogged', isLoggedIn);

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
        <Route
          path="/exercise"
          element={
            isLoggedIn ? <ExercisePage /> : <Navigate to="/" replace />
          }
        />
      </Routes>
    </BrowserRouter>
  );
};

export default App;
