import 'package:app_peliculas/models/models.dart';
import 'package:app_peliculas/providers/movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
    String? get searchFieldLabel => 'Buscar';
  
  @override

  List<Widget>? buildActions(BuildContext context) {
  return [
    IconButton
    (onPressed: () => query='', 
    icon: const Icon(Icons.clear))
  ];
  //*acciones, en este caso la accion es purgar lo que se haya escrito
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      }, 
      icon: const Icon(Icons.arrow_back)
      );
  }
//*regresar a la pantalla anterior
  @override
  Widget buildResults(BuildContext context) {
   return const Text('buildResults');
  }

Widget _emptyContainer(){
 // ignore: avoid_unnecessary_containers
 return Container(
      child: const Center(
        child: Icon(
          Icons.movie_creation_outlined, 
          color: Colors.black38,
          size:100 ,),

      ),
    );

}



  @override
  Widget buildSuggestions(BuildContext context) {
  if (query.isEmpty) {
    return _emptyContainer();
  }
  //print('http request');


  final moviesProvider= Provider.of<MoviesProvider>(context, listen: false);
moviesProvider.getSuggestionsByQuery(query);



return StreamBuilder(
  stream: moviesProvider.suggestionsStream,
    builder: ( _, AsyncSnapshot<List<Movies>> snapshot) {

    if(!snapshot.hasData) return _emptyContainer() ;
    
    final movies = snapshot.data!;

    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (_, index) => _MovieItem(movie: movies[index],) ,
      );
  },
);
  }

//*sugerencias de busqueda
 
}
class _MovieItem extends StatelessWidget {
final Movies movie;
  const _MovieItem({
    required this.movie
    });

  @override
  Widget build(BuildContext context) {
    movie.heroId='search-${movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(placeholder: const AssetImage('assets/no-image.jpg'),
        image: NetworkImage(movie.fullPosterImg),
        width: 50,
        fit:  BoxFit.contain,
        ),
      ),
      title:Text(movie.title) ,
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context,'details', arguments: movie );
      },
    );
  }
}