import 'package:flutter/material.dart';

class FriendsCheckItem extends StatefulWidget {
  final String friendName;
  final String friendAvatar;
  final void Function(bool value) onChange;
  final bool enabled;
  final bool value;
  const FriendsCheckItem({Key? key,required this.friendName, required this.friendAvatar, required this.onChange,required this.enabled,required this.value}) : super(key: key);

  @override
  State<FriendsCheckItem> createState() => _FriendsCheckItemState();
}

class _FriendsCheckItemState extends State<FriendsCheckItem> {

  bool isChecked = false;

  @override
  void initState() {
    isChecked = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey,width: 0.5)
      ),
      child: CheckboxListTile(
        enabled: widget.enabled,
        splashRadius: 8,
        contentPadding: const EdgeInsets.only(left: 0.1,right: 16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = !isChecked;
          });
          widget.onChange(isChecked);
        },
        title: Text(widget.friendName),
        //subtitle: Text('subtitle'),
        secondary: ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8)),child: Image.network(widget.friendAvatar,width: 50,height: 50,fit: BoxFit.fill,key: Key(widget.friendName),cacheHeight: 50,cacheWidth: 50,)),
      ),
    );
  }
}
