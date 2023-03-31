import 'package:app_peliculas/models/models.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class CardSwiper extends StatelessWidget {
  const CardSwiper({
    super.key, 
    required this.movies
    });


final List <Movies> movies;



  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
    if (movies.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: size.height*0.5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
    }





    return Container(
      width: double.infinity,
      height: size.height *0.5,
      color: Colors.deepPurple,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width*0.6,
        itemHeight: size.height *0.4,
        itemBuilder: ( _, int index) {
          final movie=movies[index];
        //  print(movie.fullPosterImg);
        
        movie.heroId='swiper-${movie.id}';
        
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag:movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:  FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage(movie.fullPosterImg),
                  fit: BoxFit.cover,
                  ),
              ),
            ),
          );
        },

        ),
    );
  }
}