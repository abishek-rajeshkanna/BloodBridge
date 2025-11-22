// API Configuration
const API_URL = 'http://localhost:5000/api';

// Get auth token from localStorage
function getToken() {
    return localStorage.getItem('token');
}

// Get user info from localStorage
function getUser() {
    const user = localStorage.getItem('user');
    return user ? JSON.parse(user) : null;
}

// Check if user is authenticated
function isAuthenticated() {
    return !!getToken();
}

// Logout function
function logout() {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    window.location.href = '../login.html';
}

// API call with authentication
async function apiCall(endpoint, method = 'GET', body = null) {
    const headers = {
        'Content-Type': 'application/json',
    };

    const token = getToken();
    if (token) {
        headers['Authorization'] = `Bearer ${token}`;
    }

    const options = {
        method,
        headers
    };

    if (body && method !== 'GET') {
        options.body = JSON.stringify(body);
    }

    try {
        const response = await fetch(`${API_URL}${endpoint}`, options);
        const data = await response.json();

        if (response.status === 401) {
            // Token expired or invalid
            logout();
            return null;
        }

        return { ok: response.ok, status: response.status, data };
    } catch (error) {
        console.error('API call error:', error);
        return { ok: false, error: error.message };
    }
}

// Protect pages - redirect if not authenticated
function protectPage(requiredRole = null) {
    if (!isAuthenticated()) {
        window.location.href = '../login.html';
        return;
    }

    const user = getUser();
    if (requiredRole && user.role !== requiredRole) {
        alert('Unauthorized access!');
        logout();
    }
}