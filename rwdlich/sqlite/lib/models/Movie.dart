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

abstract class MapConvertible {
  Map<dynamic, dynamic> toMap();

  MapConvertible fromMap(Map<dynamic, dynamic> map);
}

class Movie extends MapConvertible {
  final int id;
  final String imdbId;
  final String name;
  final String imageUrl;
  final String year;
  int watchedOn; // sql doesn't support dates
  int watchedTimes;

  Movie({
    this.id,
    this.imdbId,
    this.name,
    this.imageUrl,
    this.year,
    this.watchedOn,
    this.watchedTimes,
  });

  @override
  Movie fromMap(Map map) {
    return Movie(
      id: map['id'],
      imdbId: map['imdbId'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      year: "${map['year']}",
      watchedOn: map['watchedOn'],
      watchedTimes: map['watchedTimes'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imdbId': imdbId,
      'name': name,
      'imageUrl': imageUrl,
      'year': year,
      'watchedOn': watchedOn
    };
  }
}
