import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {

  final String image;
  final String title;
  final String author;
  final String published;
  final String genre;
  final String plot;

  const BookCard(
      {Key? key, required this.image, required this.title, required this.author, required this.published, required this.genre, required this.plot,
      }) : super(key: key);

  static BookCard fromJson(Map<String, dynamic> json){
    return BookCard(
      image: json["image"],
      title: json["title"],
      author: json["author"],
      published: json["published"],
      genre: json["genre"],
      plot: json["plot"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[

          Image(
            image: NetworkImage(
              image,
            ),
            fit: BoxFit.contain,
          ),

          ...List.generate(
            1, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),

              child: Column(
                children: <Widget>[
                  Text(
                    "$title - $author",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    published,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),

                  Text(
                    genre,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            );
          },),
        ],
      ),
    );
  }
}

// class Books {
//   List<BookCard> books = [
//     BookCard(
//       image: "https://m.media-amazon.com/images/I/41vVi7L43xL._SL500_.jpg",
//       title: "The Chef",
//       author: "James Patterson",
//       published: "February 18, 2019",
//       genre: "Thriller",
//       plot: "The Chef is a stand-alone thriller novel by James Patterson and Max DiLallo",
//     ),
//
//     BookCard(
//       image: "https://m.media-amazon.com/images/I/41vVi7L43xL._SL500_.jpg",
//       title: "The Chef",
//       author: "James Patterson",
//       published: "February 18, 2019",
//       genre: "Thriller",
//       plot: "The Chef is a stand-alone thriller novel by James Patterson and Max DiLallo",
//     ),
//
//     BookCard(
//       image: "https://m.media-amazon.com/images/I/41vVi7L43xL._SL500_.jpg",
//       title: "The Chef",
//       author: "James Patterson",
//       published: "February 18, 2019",
//       genre: "Thriller",
//       plot: "The Chef is a stand-alone thriller novel by James Patterson and Max DiLallo",
//     ),
//
//     BookCard(
//       title: "The Chef",
//       author: "James Patterson",
//       published: "February 18, 2019",
//       genre: "Thriller",
//       plot: "The Chef is a stand-alone thriller novel by James Patterson and Max DiLallo",
//     ),
//
//     BookCard(
//       image: "https://m.media-amazon.com/images/I/41vVi7L43xL._SL500_.jpg",
//       title: "The Chef",
//       author: "James Patterson",
//       published: "February 18, 2019",
//       genre: "Thriller",
//       plot: "The Chef is a stand-alone thriller novel by James Patterson and Max DiLallo",
//     ),
//   ];
// }