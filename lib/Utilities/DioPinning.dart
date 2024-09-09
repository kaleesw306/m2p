import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';

Future<Dio> createDioWithPinning() async {
  Dio dio = Dio();


  final sslCert = await rootBundle.load('assets/certificates/itunes_certificate.pem');
  SecurityContext context = SecurityContext(withTrustedRoots: false);

    context.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
    HttpClient httpClient = HttpClient(context: context);
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => false;


  dio.httpClientAdapter = IOHttpClientAdapter()
    ..createHttpClient = () {
      return httpClient;
    };


  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    responseType: ResponseType.json,
  );

  return dio;
}
