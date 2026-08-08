// ignore_for_file: constant_identifier_names

class Constants {
    static const String BaseUrlDev = "https://saudauat.awl.in:8081/";
    static const String BaseUrlTest = "https://saudauat.awl.in:8081/";
    static const String BaseUrlRelease = "https://saudauat.awl.in:8081/";

   // static String BaseUrlDev = "http://4.224.127.208:82/";
   // static String BaseUrlTest = "http://4.224.127.208:82/";
   // static String BaseUrlRelease = "http://4.224.127.208:82/";

   // static String BaseUrlDev = "http://74.225.173.53:82/";
   // static String BaseUrlTest = "http://74.225.173.53:82/";
   // static String BaseUrlRelease = "http://74.225.173.53:82/";

  // static const String BaseUrlDev = "https://saudaapp.awl.in/";
  // static const String BaseUrlTest = "https://saudaapp.awl.in/";
  // static const String BaseUrlRelease = "https://saudaapp.awl.in/";

  static const String KEY_TOKEN_1 = "KEY_TOKEN_1";
  static String AUTH_TOKEN = "";
  static int AUTH_USERID = 0;
  static int AUTH_ROLEID = 0;
  static String AUTH_DEALER_CODE = "0";
  static int AUTH_SELECTED_STATEID = 0;
  static String DEALER_NAME = "";
  static String AUTH_USER_NAME = "";
  static String AUTH_LAST_ACCESS_DATE = "";
  static String AUTH_PUSH_TOKEN = "";
  static const int REPORT_START_DAY = -15;
  static const int REPORT_START_DAY_REPORT = -0;
  static const int REPORT_MAX_DAY = 30;
  static const int REPORT_MAX_DAY_PENDING_SAUDA = -30;
  static String APP_KEY = "";
  static String ENCRYPTION_KEY = "";
  static String VECTOR_KEY = "";
  static bool NOTIFICATION_RECD = false;
  static bool APPUPDATE_REQUEST = false;

  static const String SecretKey = "secret_key";
  static const String VectorKey = "vector_key";
  static const String AppKey = "app_key";
  static const String TG_CLIENT_ID = "TG_CLIENT_ID";
  static const String TG_CLIENT_SECRET = "TG_CLIENT_SECRET_KEY";
  static const String TG_BEARER_TOKEN = "token";
  static const String TG_BEARER_TOKEN_TIME = "tokenTime";
  static const String TEG_AUTH_URL = "tegAuthUrl";
  static const String AuthToken = "auth_token";
  static const String VersionCode = "app_version";
  static const String AndroidVersionCode = "adani_android_app_version";
  static const String IOSVersionCode = "adani_ios_app_version";
  static const String ForceUpdate = "force_update";
  static const String SaveDate = "save_date";

  static const int REGISTER_AS_PARENT = 15;
  static const int REGISTER_AS_PWDPERSON = 16;
  static const int REGISTER_AS_GUARDIAN = 17;

  static const int SUCCESSMSG = 1;
  static const int ERRORMSG = 2;
  static const int INFOMSG = 3;

  static const String REGISTER = "register";
  static const String CHANGE_PASSWORD = "change_password";

  //Language
  static const String DEFAULT_LANGUAGE = "default_language";
  static const int LANGUAGE_ENGLISH = 1;
  static const int LANGUAGE_TAMIL = 2;
  static const String CURRENT_LANGUAGE = 'current_language';
  static const String COUNTRY_CODE_JSON = 'country_code_json';

  static bool isViewMore = false;
  static bool isNotFromNotificationFamily = false;
  static int isFromNotificationFamily = 0;
  static bool isLogoutDoneToClearPreference = false;

// DOB

  // static DateTime now = DateTime.now();
  // static String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  // ignore: non_constant_identifier_names
  static String MIN_DATETIME = '1950-01-01';

  static const String dobFormat = 'dd-MM-yyyy';

  // ApplicationId
  static const int Android = 1;
  static const int iOS = 2;

// Roles
  static const int DEALER = 5; // Distributor
  static const int SALE = 7; // State Trader
  static const int NHMANAGER = 12;
  static const int ZHMANAGER = 9;

  // static const int  Web =3 ;

  //emailId
  static const String USER_FIRSTNAME = "user_firstname";
  static const String USER_LASTNAME = "user_lastname";
  static const String USER_EMAIL = "spemail";
  static const String USER_MOBILE = "user_mobile";
  static const String USER_DOB = "user_dob";
  static const String USER_TYPE = "user_type";
  static const String USER_TYPEID = "user_type_id";
  static const String USER_DISTRICTID = "user_country_id";
  static const String REG_USER_EMAIL = "reg_email";
  static const String REG_USER_MOBILE = "reg_mobile";

  //userid
  static const String USERID = "spuserid";

  static const String INTERNET_SPEED = 'internet_speed';
  static const int NET_SPEED_HIGH = 1;
  static const int NET_SPEED_LOW = 2;
  static const String FACILITY_SELECTED_INDEX = 'selected index';

  //  UAE_MOBILE_PATTERN
  static const String INDIA_MOBILE_PATTERN =
      '^(?:\\+971|00971|0)?(?:50|51|52|55|56|54|58)\\d{7}\$';

  static const String IS_NOTIFICATION_LIST_RETRY = 'is_notification_list_retry';
  static const String FCM_TOKEN = 'fcm_token';
  static const String FEEDBACK_TYPE_SURVEY = 'survey';

  //
  static const String IS_NEW_NOTIFY_AVAIL = "is_notification_available";

  //otp resend timer count
  static const int RESEND_TIME = 30;
  static const String STATUSBAR_HEIGHT = 'statusbar_height';
  static const String REFRESH_HOMEPAGE = 'update_homepage';

  //ispage from profile
  static const bool isMultipleChild = false;
  static const bool isPageFromNotificationList = true;

  // silent notification types
  static const String NOTIFICATION_KEY = 'key';
  static const String NOTIFICATION_TOKEN_EXPIRED = 'TOKEN EXPIRED';
  static const String NOTIFICATION_INVALID_USER = '1';
  static const String NOTIFICATION_EVENT = '2';

  static const String LANGUAGE_CHANGE_REFRESH_HOME = 'update_home';
  static const String LANGUAGE_CHANGE_REFRESH_EVENT = 'update_event';
  static const String LANGUAGE_CHANGE_REFRESH_SURVEY = 'update_survey';
  static const String KEYBOARD_HIDE_SURVEY = 'keyboard_hide_survey';
  static const String KEYBOARD_HIDE_REVIEW = 'keyboard_hide_review';
  static const String PREVENT_MULTIPLE_DIALOG = "prevent_multiple_dialog";
  static const String CHECK_APP_UPDATE = "CHECK_APP_UPDATE";

  // ignore: non_constant_identifier_names
  static int USERID_CHECK = 0;

  //Discount
  static const String SELECT_EMPLOYEES = "Select Employees";
  static const String SELECT_DISTRIBUTOR = "Select Distributor";

  //ERROR
  static const String EMP_ERROR = "Select Employees from the list";
  static const String DIS_ERROR = "Select Employees from the list";

// Request Quantity
  static const int PENDING_REQUEST = 1;
  static const int APPROVED_REQUEST = 2;
  static const int REJECTED_REQUEST = 3;
  static const int REQUEST_FOR_APPROVAL = 9;

  static dynamic formId = "";
  static String formName = "";
  static bool isSubmitted = false;
  
  // upated company name
  static const String awlAgriBussiness = "AWL Agri Business";
  static const String aboutAwlAgriBussiness = "About AWL Agri Business";

  static const String forgotPassword = "Forgot/Reset Password?";
}
