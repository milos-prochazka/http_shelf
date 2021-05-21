// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:mime/mime.dart';

void main() async 
{
  var handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(_echoRequest);

  var server = await shelf_io.serve(handler, '0.0.0.0', 8080);

  // Enable content compression
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}

Future<Response> _echoRequest(Request request) async
{
    
    final filepath = request.url.toString().isEmpty ? 'www/index.html' : 'www/${request.url}';
    final file = File(filepath);
    if (await file.exists())
    {
        var data = await file.readAsBytes();
        final headers = { 'content-type':lookupMimeType(filepath)};
        return Response.ok(data,headers: headers);
    }
    final params = request.url.queryParameters;
    Uri.splitQueryString(request.url.toString());
    return Response.notFound('Request for "${request.url}" not found');
    
}
