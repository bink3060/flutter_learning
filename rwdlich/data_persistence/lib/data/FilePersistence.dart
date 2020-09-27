/*
 * Copyright (c) 2019 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:magiccart/Repository.dart';
import 'package:path_provider/path_provider.dart';

class FilePersistence implements Repository {
  Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<String> getFilename(String userId, String type, String key) async {
    return userId + '/' + type + '/' + key;
  }

  @override
  Future<Uint8List> getImage(String userId, String key) async {
    final filename = await getFilename(userId, 'images', key);
    final file = await _localFile(filename);

    if (await file.exists()) return await file.readAsBytes();
    return null;
  }

  @override
  Future<String> getString(String userId, String key) async {
    final filename = await getFilename(userId, 'strings', key);
    final file = await _localFile(filename);

    if (await file.exists()) return await file.readAsString();
    return null;
  }

  @override
  Future<Map<String, dynamic>> getObject(String userId, String key) async {
    final filename = await getFilename(userId, 'objects', key);
    final file = await _localFile(filename);

    if (await file.exists()) {
      final objectString = await file.readAsString();
      return JsonDecoder().convert(objectString);
    }

    return null;
  }

  @override
  Future<String> saveImage(String userId, String key, Uint8List image) async {
    final filename = await getFilename(userId, 'images', key);
    final file = await _localFile(filename);

    if (!await file.parent.exists()) await file.parent.create(recursive: true);

    await file.writeAsBytes(image);

    return filename;
  }

  @override
  void saveObject(
      String userId, String key, Map<String, dynamic> object) async {
    final filename = await getFilename(userId, 'objects', key);
    final file = await _localFile(filename);

    if (!await file.parent.exists()) await file.parent.create(recursive: true);

    final jsonString = JsonEncoder().convert(object);
    await file.writeAsString(jsonString);
  }

  @override
  void saveString(String userId, String key, String value) async {
    final filename = await getFilename(userId, 'strings', key);
    final file = await _localFile(filename);

    if (!await file.parent.exists()) await file.parent.create(recursive: true);

    await file.writeAsString(value);
  }

  @override
  Future<void> removeImage(String userId, String key) async {
    final filename = await getFilename(userId, 'images', key);
    final file = await _localFile(filename);
    if (await file.exists()) await file.delete();
  }

  @override
  Future<void> removeObject(String userId, String key) async {
    final filename = await getFilename(userId, 'objects', key);
    final file = await _localFile(filename);
    if (await file.exists()) await file.delete();
  }

  @override
  Future<void> removeString(String userId, String key) async {
    final filename = await getFilename(userId, 'strings', key);
    final file = await _localFile(filename);
    if (await file.exists()) await file.delete();
  }
}
