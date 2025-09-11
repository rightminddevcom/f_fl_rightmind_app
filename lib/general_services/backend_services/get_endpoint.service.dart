import '../../constants/app_constants.dart';
import '../../models/endpoint.model.dart';

abstract class EndpointServices {
  static EndPoint getApiEndpoint(EndpointsNames name) {
    switch (name) {
      case EndpointsNames.createAuthentication:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_users/v1/create_authentication');
      case EndpointsNames.authentication:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_users/v1/authentication');
      case EndpointsNames.registration:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_users/v1/registration');
      case EndpointsNames.activateTfa:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_users/v1/tfa/activate');
      case EndpointsNames.device:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_users/v1/device');
      case EndpointsNames.updateInfo:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_users/v1/update_profile');
      case EndpointsNames.registrationFields:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_users/v1/registration_fields');
      case EndpointsNames.forgetPassword:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_users/v1/forget_password');
      case EndpointsNames.logOut:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_users/v1/log_out');
      case EndpointsNames.startApp:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_users/v1/start_app');
      case EndpointsNames.generalSettings:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_general/v1/get_general_settings');
      case EndpointsNames.userSettings:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_general/v1/get_user_settings');
      case EndpointsNames.updateDeviceInfo:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_users/v1/update_device_info');
      case EndpointsNames.updatePassword:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_users/v1/update_password');
      case EndpointsNames.updateNotification:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_users/v1/update_notification');
      case EndpointsNames.home:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_screens/v1/home');
      case EndpointsNames.pointsHistory:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_pointsys/v1/history');
      case EndpointsNames.taxonomy:
        return EndPoint(
            name: name,
            url:
                '${AppConstants.baseUrl}/rm_taxonomy/v1/get?key=projects_location');
      case EndpointsNames.addNew:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_pointsys/v1/add_new');
      case EndpointsNames.getPosts:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_postcontrol/v1/get_posts');
      case EndpointsNames.getPost:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_postcontrol/v1/get_post');
      case EndpointsNames.myProject:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_screens/v1/myprojects');
      case EndpointsNames.newRequest:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_postcontrol/v1/add_request');
      case EndpointsNames.getComments:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_postcontrol/v1/get_comment');
      case EndpointsNames.addComments:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_postcontrol/v1/add_comment');
      case EndpointsNames.pages:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_page/v1/get');
      case EndpointsNames.notificationStatus:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_users/v1/get_notification_status');
      case EndpointsNames.deviceSys:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_users/v1/device_sys');
      case EndpointsNames.taxonomyPosts:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_taxonomy/v1/taxonomy/posts');
      case EndpointsNames.fingerprint:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_fingerprint/v1/add_fingerprint');
      case EndpointsNames.fingerprints:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_fingerprint/v1/add_fingerprints');
      case EndpointsNames.getCalendar:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_postcontrol/v1/calendar_posts');
      case EndpointsNames.empAddRequest:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/emp_requests/v1/create_new_request');
      case EndpointsNames.getRequests:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/emp_requests/v1/my_requests');
      case EndpointsNames.getRequest:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/emp_requests/v1/my_request');
      case EndpointsNames.askIgnore:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/emp_requests/v1/ask_ignore');
      case EndpointsNames.managerAction:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/emp_requests/v1/action');
      case EndpointsNames.askRemember:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/emp_requests/v1/ask_remember');
      case EndpointsNames.getEmployeeBalance:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/emp_requests/v1/balance');
      case EndpointsNames.getFingerprints:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_fingerprint/v1/get_fingerprints');
      case EndpointsNames.getFingerprint:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_fingerprint/v1/get_fingerprint');
      case EndpointsNames.new_:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_postcontrol/v1/add_request');
      case EndpointsNames.empGetPosts:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/emp_requests/v1/employee');
      case EndpointsNames.empTasks:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/emp_requests/v1/task');
      case EndpointsNames.empAddTasks:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/emp_requests/v1/task');
      case EndpointsNames.tasksUsers:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/emp_requests/v1/users');
      case EndpointsNames.empStatistics:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/emp_requests/v1/statistics');
      case EndpointsNames.companyStructure:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/emp_reports/v1/company_structure');
      case EndpointsNames.postActions:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_postcontrol/v1/action');
      case EndpointsNames.payGetPosts:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_payroll/v1/payroll');
      case EndpointsNames.payGetPost:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_payroll/v1/payroll');
      case EndpointsNames.addNewNotification:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_notification/v1');
      case EndpointsNames.getUsers:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_general/v1/json/users');
      case EndpointsNames.getDepartments:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_general/v1/json/departments');
      case EndpointsNames.updateTasks:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/emp_requests/v1/task');
      case EndpointsNames.resend:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_users/v1/2fa/resend');
      case EndpointsNames.oauth:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_users/v1/oauth');
      case EndpointsNames.removeAccount:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_users/v1/remove_account');
      case EndpointsNames.empEvaluation:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/emp_reports/v1/evaluation');
      case EndpointsNames.summaryReport:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/emp_reports/v1/summary_report');
      case EndpointsNames.myStores:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_ecommarce/v1/stores');
        case EndpointsNames.myOrdersOdoo:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_ecommarce/v1/stores');
      case EndpointsNames.myOrders:
        return EndPoint(name: name, url: 'orders');
        case EndpointsNames.myOrders:
        return EndPoint(name: name, url: 'stock/orders');
      case EndpointsNames.avaialbleProducts:
        return EndPoint(name: name, url: '/stock/availability');
      case EndpointsNames.calculateOrder:
        return EndPoint(name: name, url: '/stock/orders/calculate-order');
      case EndpointsNames.completeOrder:
        return EndPoint(name: name, url: '/stock/orders/complete-order');
      case EndpointsNames.showTeam:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_social/v1/team/show');
      case EndpointsNames.topRated:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_social/v1/team/top-rated');
      case EndpointsNames.team:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_social/v1/team');
      case EndpointsNames.teamJoin:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_social/v1/team/join');
      case EndpointsNames.teamApproveRequest:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_social/v1/team/approve-request');
      case EndpointsNames.leaveTeam:
        return EndPoint(
            name: name, url: '${AppConstants.baseUrl}/rm_social/v1/team/leave');
      case EndpointsNames.deleteMember:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_social/v1/team/delete-member');
        case EndpointsNames.getDeviceToken:
        return EndPoint(
            name: name,
            url: '${AppConstants.baseUrl}/rm_users/v1/get_device_token');
    }
  }
}
