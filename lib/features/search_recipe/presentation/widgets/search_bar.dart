import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search_recipe_bloc.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  final _searchBarHeight = kToolbarHeight * 0.65;
  late final SearchRecipeBloc _bloc;
  late final FocusNode _focusNode;
  late final TextEditingController _textEditingController;
  var _isExpanded = false;
  var _searchBarWidth = 0.0, _maxWidth = 0.0;

  _updateSize() {
    setState(() {
      _isExpanded = !_isExpanded;
      _searchBarWidth = _isExpanded ? _maxWidth : 0;
    });
  }

  @override
  void initState() {
    _bloc = BlocProvider.of(context);
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _maxWidth = MediaQuery.of(context).size.width * 0.84;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _searchBarWidth),
      builder: (context, widthDx, _child) {
        if (widthDx > 0 && !_focusNode.hasFocus) {
          _focusNode.requestFocus();
        }

        if (widthDx == 0) {
          _focusNode.unfocus();
          _textEditingController.text = '';
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: widthDx > 0 ? Colors.white : Colors.transparent,
                border: Border.all(
                    color: widthDx > 0 ? Colors.white : Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              child: Container(
                height: _searchBarHeight,
                width: widthDx,
                alignment: Alignment.center,
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: widthDx > 0 ? _maxWidth * 0.04 : 0,
                  bottom: _searchBarHeight * 0.15,
                ),
                child: _child,
              ),
            ),
            IconButton(
              onPressed: () => _updateSize(),
              icon: Icon(widthDx > 0 ? Icons.cancel_outlined : Icons.search),
            ),
          ],
        );
      },
      child: TextField(
        focusNode: _focusNode,
        controller: _textEditingController,
        onChanged: (query) => _bloc.add(
          GetRecipes(query, 1),
        ),
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
        ),
      ),
      curve: Curves.easeOutCubic,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
}
