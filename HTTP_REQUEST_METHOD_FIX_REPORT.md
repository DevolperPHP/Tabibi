# HTTP Request Method Error - Complete Solution

## Problem Analysis

The error `HttpException: Invalid request method, uri = http://165.232.78.163/passport/login` was caused by a **port mismatch** between the frontend and backend.

### Root Cause
- **Backend server** runs on port 3000 (configured in `tabibi-backend/app.js`)
- **Frontend API calls** were targeting port 80 (default HTTP port)
- Server on port 80 didn't understand the request format, resulting in "Invalid request method"

## Applied Fixes

### 1. Updated API Base URL
**File**: `lib/utils/constants/api_constants.dart`
```dart
// Before
static String baseUrl = 'http://165.232.78.163/';

// After  
static String baseUrl = 'http://165.232.78.163:3000/';
```

### 2. Added Proper Content-Type Header
**File**: `lib/services/api_service.dart`
```dart
headers: {
  'Accept': 'application/json',
  'Content-Type': 'application/json',  // Added this line
  if (StorageController.checkLoginStatus())
    'Authorization': 'Bearer ${StorageController.getToken()}',
},
```

### 3. Enhanced POST Data Formatting
**File**: `lib/services/api_service.dart`
```dart
static Future<StateReturnData> postData(String endpoint, dynamic data) async {
  try {
    // Ensure data is properly formatted for JSON
    final jsonData = data is Map ? data : {'data': data};
    final response = await _dio.post(endpoint, data: jsonData);
    // ... rest of method
  }
}
```

## Expected Results

After applying these fixes:
1. ✅ Authentication requests will target the correct port (3000)
2. ✅ Proper JSON Content-Type header will be sent
3. ✅ Request data will be properly formatted
4. ✅ DioError and HttpException should be resolved

## Testing the Fix

1. **Start the backend server**:
   ```bash
   cd tabibi-backend
   npm start
   ```

2. **Test the authentication endpoint**:
   - Run the Flutter app
   - Attempt to login with valid credentials
   - Monitor console for any remaining errors

3. **Verify in browser**:
   - Visit `http://165.232.78.163:3000/passport/login`
   - Should show "Cannot GET /passport/login" (expected for POST endpoint)

## Additional Recommendations

### For Production Deployment
1. **Use environment variables** for API base URL
2. **Enable CORS properly** on backend
3. **Use HTTPS** in production
4. **Add request logging** for debugging

### For Development
1. **Add API health check endpoint**
2. **Implement retry logic** for failed requests
3. **Add request/response logging** for debugging

## Files Modified
- ✅ `lib/utils/constants/api_constants.dart`
- ✅ `lib/services/api_service.dart`

## Next Steps
1. Test the authentication flow
2. Monitor for any remaining DioError issues
3. Consider implementing the additional recommendations above