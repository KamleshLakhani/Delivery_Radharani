class ApiSheet {
  // static String preBaseUrl = 'http://sixty13.com/laravel/radha-ranis/';
  static String preBaseUrl = "https://www.radharaniskitchendelivery.com/";
  // static String preBaseUrl = 'http://192.168.0.30/laravel/radha-rani/';
  static String imageUrl = preBaseUrl + "storage/app/public/delivery-boy/";
  static String baseUrl = preBaseUrl + "api/deliveryboy/";

  static String configUrl = preBaseUrl + 'get-config-value?config_key=';
  static String getUrl = baseUrl;
  static String cmsUrl = preBaseUrl + 'get-cms-value?cms_key=';

  static String login = 'login';
  static String sendOtpForForget =
      'forgot-password'; //used also for verify deliver order
  static String submitForgetOtp =
      'forgot-password-verify-otp'; //used also for verify deliver order
  static String setNewPassword = 'updatePassword'; //append id
  static String getProfile = 'getProfile';
  static String updateProfile = 'updateProfile';
  static String getOrderData = 'getOrderData';
  static String saveImage = 'avtar-update';
  static String saveImagePayment = 'signature-upload/';
  static String logout = 'logout';
  static String searchLocation = 'search-location/';
  static String orderDetails = 'order-details';
  static String locationPoints = 'location-points';
  static String getDeliveries = 'get-deliveries/';
  static String updateOrderDetails = 'updateOrderDetails/';
  static String getAreaFromCityName = 'city-area';
  static String orderConfirmOtp =
      baseUrl + 'forgot-password/0';//forgot/password/verify/
  static String getTimeSlot =
      preBaseUrl + 'api/delivery-boy/my-delivery-time-slot/';
}
