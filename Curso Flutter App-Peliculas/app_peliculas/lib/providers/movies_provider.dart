import 'dart:async';
import 'dart:convert';
import 'package:app_peliculas/helpers/debouncer.dart';
import 'package:app_peliculas/models/models.dart';
import 'package:app_peliculas/models/search_movies_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoviesProvider extends ChangeNotifier {
final String _apiKey='e2231daa807905aa0f05f580faa1e9cc';

final String _baseUrl='api.themoviedb.org';

final String _language='es-ES';

List <Movies> onDisplayMovies=[];
List <Movies> popularMovies=[];
Map <int, List<Cast>> moviesCast={};
// ignore: unused_field
int _popularPage= 0;

final debouncer= Debouncer(
  duration: const Duration(
    milliseconds: 500),
    
    );
final StreamController<List <Movies>> _suggestionsStreamController= StreamController.broadcast();
Stream <List<Movies>> get suggestionsStream => _suggestionsStreamController.stream;



  MoviesProvider() {
   // print('MoviesProvider inicializado');

    getOnDisplayMovies();
    getPopularMovies();
    //*Los streamcontrollers deben cerrarse, en algun dispose
    //* por ejemplo en caso de que la aplicacion sea mas compleja,
    //* como este va a ser nuestro unico streamcontroller lo 
    //*dejamos asi. abajo esta la linea de codigo para cerrarlo
    //*_suggestionsStreamController.close();
  }

  Future <String> _getJsonData(String endpoint, [int page=1])async{
    final url =Uri.https(_baseUrl, endpoint, {
     'api_key' : _apiKey,
     'language':_language,
     'page'    :'$page',
      });

    final response = await http.get(url);
    return response.body;



  }

  getOnDisplayMovies() async {
  final jsonData= await _getJsonData('3/movie/now_playing');

    final nowPlayingResponse=NowPlayingResponse.fromMap(jsonDecode(jsonData));
    // if (response.statusCode!=200) return print('error');
   // print(nowPlayingResponse.results[12].title);
    onDisplayMovies=nowPlayingResponse.results;

    notifyListeners(); 
    //*cuando hacemos alguna modificacion, pej: agregamos
    //* una propiedad a onDisplayMovies y necesitamos redibujar widgets, llamamos
    //*el método notifyListeners(), el cual notifica a los widgets que esten
    //*escuchando ese cambio, informandole a estos que se redibujen
  }


  getPopularMovies()async{

_popularPage++;

      final jsonData= await _getJsonData('3/movie/popular',1);

    final popularResponse=PopularResponse.fromMap(jsonDecode(jsonData));
    // if (response.statusCode!=200) return print('error');
   // print(nowPlayingResponse.results[12].title);
    popularMovies=[...popularMovies,...popularResponse.results];
//print(popularMovies[0]);
    notifyListeners(); 
    
  }

Future <List<Cast>> getMovieCast(int movieId)async{
if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

  //print('pidiendo elenco');

  final jsonData= await _getJsonData('3/movie/$movieId/credits',1);
  final creditsResponse =CreditsResponse.fromMap(jsonDecode(jsonData));
moviesCast[movieId]= creditsResponse.cast;
return creditsResponse.cast;
}

Future<List <Movies>> searchMovies( String query) async{
  final url =Uri.https(_baseUrl, '3/search/movie', {
     'api_key' : _apiKey,
     'language':_language,
      'query': query,
      });
    final response = await http.get(url);
    final searchMoviesResponse= SearchMoviesResponse.fromMap(jsonDecode(response.body));
    return searchMoviesResponse.results;
}
void getSuggestionsByQuery (String searchTerm){
debouncer.value='';
debouncer.onValue=(value) async {
  final results = await searchMovies(value);
  _suggestionsStreamController.add(results);
};
final timer=Timer.periodic(const Duration(milliseconds: 300), (_) { 

debouncer.value=searchTerm;

});

Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());


}





}
