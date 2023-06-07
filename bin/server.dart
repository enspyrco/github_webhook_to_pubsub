import 'dart:convert';
import 'dart:io';

import 'package:github_webhook_to_pubsub/utils/typedefs.dart';
import 'package:github_webhooks/github_webhooks.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

Future<Response> _publishMessage(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body) as JsonMap;

  // TODO: put json in a PubSub message

  return Response.ok('Diddley dunarooni.');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that verifies the request came from GitHub before publishing.
  final handler = Pipeline()
      .addMiddleware(
          verifyGitHubSignature(Platform.environment['WEBHOOK_SECRET']!))
      .addHandler(_publishMessage);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
