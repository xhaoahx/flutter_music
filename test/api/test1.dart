import 'package:dio/dio.dart';

void main() async {
  final url = 'http://lesheng.ink:8080/song';
  final dio = Dio();
  final result = await dio.get(url,queryParameters:  {
    'num' : 1,
  });
  print(result);
}