import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/services/apiservice.dart';
import 'package:myapp/services/storage.dart';

ApiService apiService = ApiService(dotenv.env['API_URL'] ?? '');
