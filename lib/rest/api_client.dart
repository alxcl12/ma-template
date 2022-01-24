import 'package:dio/dio.dart' hide Headers;
import 'package:non_native/domain/data.dart';
import 'package:retrofit/http.dart';
import 'apis.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:5000")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET(Apis.all)
  Future<List<BoardGame>> getAll();

  @GET("/bg/{id}")
  Future<BoardGame> getOne(@Path("id") int id);

  @DELETE("/bg/{id}")
  Future<void> delete(@Path("id") int id);

  @POST("/bg")
  Future<BoardGame> add(@Body() BoardGame entity);

  @PATCH("/bg/{id}")
  Future<BoardGame> update(@Body() BoardGame entity, @Path("id") int id);
}
