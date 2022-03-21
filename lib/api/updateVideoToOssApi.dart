
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class UploadOss {

  static String ossAccessKeyId = 'LTAI5tFZDUZcohgrzY9pPa9J';

  static String ossAccessKeySecret = 'ayeo5nfron3mmMblXsjLFT9S7f09YW';
  // oss设置的bucket的名字
  static String bucket = 'videowushirong';
  // 发送请求的url,根据你自己设置的是哪个城市的
  static String url = 'https://$bucket.oss-cn-hangzhou.aliyuncs.com';

  // 过期时间
  static String expiration = '2025-01-01T12:00:00.000Z';

  /**
   * @params file 要上传的文件对象
   * @params rootDir 阿里云oss设置的根目录文件夹名字
   * @param fileType 文件类型例如jpg,mp4等
   * @param callback 回调函数我这里用于传cancelToken，方便后期关闭请求
   * @param onSendProgress 上传的进度事件
   */

  static Future<String> upload({ required File file , String rootDir = 'video', String? fileType, Function? callback, Function? onSendProgress}) async {
    String policyText = '{"expiration": "$expiration","conditions": [{"bucket": "$bucket" },["content-length-range", 0, 1048576000]]}';

    // 获取签名
    String signature = getSignature(policyText);

    print("signature=${signature}");
    BaseOptions options = new BaseOptions();
    options.responseType = ResponseType.plain;

    //创建dio对象
    Dio dio = new Dio(options);
    // 生成oss的路径和文件名我这里目前设置的是moment/20201229/test.mp4
    String pathName = '$rootDir/${getDate()}/${getRandom(12)}.${fileType == null ? getFileType(file.path) : fileType}';

    print("pathName=${pathName}");
    // 请求参数的form对象
    FormData data = new FormData.fromMap({
      'key': pathName,
      'policy': getSplicyBase64(policyText),
      'OSSAccessKeyId': ossAccessKeyId,
      'success_action_status': '200', //让服务端返回200，不然，默认会返回204
      'signature': signature,
      'contentType': 'multipart/form-data',
      'file': MultipartFile.fromFileSync(file.path),
    });

    Response response;
    CancelToken uploadCancelToken = CancelToken();
    if(callback!=null){
      callback(uploadCancelToken);
    }

    try {
      // 发送请求
      //print("urllll=${url}");
      response = await dio.post(url, data: data, cancelToken: uploadCancelToken, onSendProgress: (int count, int data) {
        if(onSendProgress!=null){
          onSendProgress(count, data);
        }
      });
      // 成功后返回文件访问路径
      return '$url/$pathName';
    } catch(e) {
      throw(e);
    }

  }


  /*
  * 生成固定长度的随机字符串
  * */
  static String getRandom(int num) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String left = '';
    for (var i = 0; i < num; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }
  /*
  * 根据图片本地路径获取图片名称
  * */
  static String getImageNameByPath(String? filePath) {
    // ignore: null_aware_before_operator
    if(filePath==null||filePath.isEmpty){
      return "";
    }
    return filePath.substring(filePath.lastIndexOf("/")+1,filePath.length);
  }
  /**
   * 获取文件类型
   */
  static String getFileType(String path) {
    print(path);
    List<String> array = path.split('.');
    return array[array.length -1];
  }
  /// 获取日期
  static String getDate() {
    DateTime now = DateTime.now();
    return '${now.year}${now.month}${now.day}';
  }

  // 获取plice的base64
  static getSplicyBase64(String policyText) {
    //进行utf8编码
    List<int> policyText_utf8 = utf8.encode(policyText);
    //进行base64编码
    String policy_base64 = base64.encode(policyText_utf8);
    return policy_base64;
  }

  /// 获取签名
  static String getSignature(String policyText) {
    //进行utf8编码
    List<int> policyText_utf8 = utf8.encode(policyText);
    //进行base64编码
    String policy_base64 = base64.encode(policyText_utf8);
    //再次进行utf8编码
    List<int> policy = utf8.encode(policy_base64);
    //进行utf8 编码
    List<int> key = utf8.encode(ossAccessKeySecret);
    //通过hmac,使用sha1进行加密
    List<int> signature_pre = Hmac(sha1, key).convert(policy).bytes;
    //最后一步，将上述所得进行base64 编码
    String signature = base64.encode(signature_pre);
    return signature;
  }
}
