import 'package:adaniwilmar/gmcore/model/login_meta.dart';
import 'package:adaniwilmar/gmcore/network/GMCore.dart';
import 'package:adaniwilmar/models/user_login.dart';
import 'package:adaniwilmar/models/validate.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/url_utils.dart';

class LoginRepository {
  Future<LoginMeta> authorizeLogin(UserLogin userLogin) async {
    LoginMeta meta = LoginMeta();
    var clientKey = Constants.APP_KEY;
    GMAPIService gmapiService = GMAPIService();
    if (clientKey.isEmpty) {
      gmapiService.logPrinting("Login - Client key is missing");
      meta.statusMsg = "Client key is missing";
      meta.statusCode = 201;
      return meta;
    } else {
      Validate v = Validate(clientKey: Constants.APP_KEY, clientType: "AppKey");

      return await getLevel2Token(
          userLogin,
          (await gmapiService.getLevel1Token(
                  URLUtils().getValidateUrl(), v.toJson()))
              .statusMsg);
    }
  }

  Future<LoginMeta> getLevel2Token(UserLogin userLogin, String token) async {
    GMAPIService gmapiService = GMAPIService();
    return await gmapiService.getLevel2Token(
        URLUtils().getAuthorizeLoginUrl(), userLogin.toJson(), token);
  }
}
