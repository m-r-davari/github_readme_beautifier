import 'package:flutter/material.dart';

class GithubGridView extends StatefulWidget {
  const GithubGridView({Key? key}) : super(key: key);

  @override
  State<GithubGridView> createState() => _GithubGridViewState();
}



class _GithubGridViewState extends State<GithubGridView> {

  List<int> grids = List.filled(368, 0);//368

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FittedBox(
        child: SizedBox(
          height: 350,
          child: GridView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(24),
              itemCount: grids.length,//371
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (ctx, index) {
                return const GithubGridItem();
              }),
        ),
      ),
    );
  }
}


class GithubGridItem extends StatefulWidget {
  const GithubGridItem({Key? key}) : super(key: key);

  @override
  State<GithubGridItem> createState() => _GithubGridItemState();
}

class _GithubGridItemState extends State<GithubGridItem> {

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Material(
        color: isSelected ? Colors.green : const Color(0xffededf0),
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: (){
            setState(() {
              isSelected = !isSelected;
            });
          },
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(border: Border.all(color: const Color(0xffdfe1e3),width: 1),borderRadius: const BorderRadius.all(Radius.circular(6))),
          ),
        ),
      ),
    );
  }
}
