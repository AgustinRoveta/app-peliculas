import 'package:app_peliculas/models/models.dart';
import 'package:flutter/material.dart';
import 'package:app_peliculas/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  final List <Movies> movies;
  
  const DetailsScreen({Key? key, required this.movies}) : super(key: key);


  @override
  Widget build(BuildContext context) {
//todo cambiar por una instancia de movie
    final Movies movie =ModalRoute.of(context)!.settings.arguments as Movies;
//print(movie.title);
/* En Dart, ModalRoute.of(context)?.settings.arguments se utiliza para 
acceder a los argumentos pasados ​​a la ruta actual a través de
 Navigator.pushNamed() o Navigator.pushNamedAndRemoveUntil().
ModalRoute.of(context) devuelve la ruta actual del widget modal.
?. es el operador de navegación segura que evita que se produzca una 
excepción si la ruta actual es nula. settings es un objeto que contiene
la configuración de la ruta actual, como el nombre de la ruta, 
los argumentos y la configuración de transición. arguments es una propiedad
del objeto settings que contiene los argumentos pasados ​​a la ruta actual.
Por lo tanto, ModalRoute.of(context)?.settings.arguments devuelve los
 argumentos pasados ​​a la ruta actual o nulo si no hay argumentos. */
    return Scaffold(
        body: CustomScrollView(
      slivers: [
         _CustomAppBar(movie),
        SliverList(
            delegate: SliverChildListDelegate([
           _PosterAndTitle(movie),
           _Overview(movie),
           _Overview(movie),
           CastingCards(movieId:movie.id),
        ]))
      ],
    ));
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movies movie;

  const _CustomAppBar(this.movie);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      //    color: Colors.teal.withOpacity(0.4),
          child: Text(
            movie.title,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        background:  FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
    final Movies movie;
  const _PosterAndTitle(this.movie);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size= MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.55),
              child:  FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                height: 150,
                
              ),
            ),
          ),
          const SizedBox(width: 20,),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width-175),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                movie.title,
                style: textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(
                    movie.originalTitle,
                    style: textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_border_outlined,
                      size: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      (movie.voteAverage).toString(),
                      style: textTheme.bodySmall,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movies movie;
  const _Overview(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Text(
          movie.overview,
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
/*los slivers sons widgets que tienen un cierto comportamiento pre-programado
cuando se hace scroll en el contenido del padre
*/