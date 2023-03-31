import 'package:flutter/material.dart';

import 'package:app_peliculas/providers/movies_provider.dart';

import 'package:app_peliculas/search/search_delegate.dart';
import 'package:provider/provider.dart';
import 'package:app_peliculas/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

final moviesProvider= Provider.of<MoviesProvider>(context, listen: true);

//print(moviesProvider.onDisplayMovies);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas en cartelera'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
               delegate: MovieSearchDelegate()), 
 /*El delegate es un widget o una clase que requiere ciertas condiciones  */
            icon: const Icon(Icons.search_outlined)
            )
        ],
      ),

      body: SingleChildScrollView( 
        child:Column(
        children:  [
        //*tarjetas principales
         CardSwiper(movies: moviesProvider.onDisplayMovies),
        //*Listado horizontal de peliculas
           MovieSlider(
            movies:moviesProvider.popularMovies,
            title: 'Populares!',
            onNextPage:()=>moviesProvider.getPopularMovies(),
            ),
     
        ],
      )
      ),
    );
  }
}